<?php 
	ini_set('display_errors','on' );
	require_once "lib/board.php";
	require_once "lib/dbconnect.php";
	require_once "lib/game.php";
	require_once "lib/users.php";
	
	//$method=$_SERVER['REQUEST_METHOD'];

	$method="GET";
	
	$request=explode('/',trim($_SERVER['PATH_INFO'],'/'));
	$input = json_decode(file_get_contents('php://input'),true);
	if(isset($_SERVER['HTTP_X_TOKEN'])) {
		$input['token']=$_SERVER['HTTP_X_TOKEN'];
	}
	
	
	
	
	//print_r($request);
	switch ($uri=array_shift($request)) 
	{
		case "deck":
					switch ($par=array_shift($request)) 
					{
							
							case '':
							case null: manipulate_board($method);
										break;
							case 'hit' :
										if($method=="GET"){
											hit_card($input['token']);
										}
										else
										{	
											header("HTTP/1.1 400 Bad Request");
											print json_encode(['errormesg'=>"Method $method not allowed here."]);
										}
										break;
							case 'stand':
										stand_card($method,$input);
										break;
							default:
									header("HTTP/1.1 404 Not Found");
									break;
					}		
					break;
		case "players":
					manipulate_players($method,$request,$input);
					break;
		case "status":
					if(count($request)==0)
						show_status();
					else{
						header("HTTP/1.1 404 Not Found");
					}
					break;	
		default:
				header("HTTP/1.1 404 Not Found");
                exit;
	}		
	//DONE	
	function manipulate_board($method)
	{
		if($method=="GET")
		{
			show_deck();
		}
		else if ($method=="POST")
			reset_deck();
	}
	
	
	
	/*USERS FUNCTIONS*/
	function manipulate_players($method,$request,$input)
	{
		switch($name=array_shift($request))
		{
			case '':
			case null:
					if ($method=="GET")
					{
						show_all_players($method);
					}
					else
					{
						header("HTTP/1.1 400 Bad Request");
						print json_encode(['errormesg'=>"Method $method not allowed here."]);
					}
					break;
			case($name!=''):
					if($method=="GET")
					{
						show_player_info($name);
					}
					else if($method=="PUT")
					{
						register_player($name,$input);
					}
				
		}
		
	}
	
	
	

	
	
	
	function hit_card($token)
	{
		global $mysqli;
		if($token=='' || $token==NULL)
		{
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"token is not set."]);
			exit;
		}
		
		$melos=is_melos($token);
		if($melos==NULL)
		{
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"You are not a registered player of this game."]);
			exit;
		}
		$status=return_current_status();
		if($status['status']!='STARTED')
		{
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"Game hasn't started yet. Waiting for a Second Player."]);
			exit;
		}
		if($status['turn'] != $melos){
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"It is not your turn to play!."]);
			exit;	
		}
		
		$hitcommand="CALL draw_card()";
		$updatecommand="UPDATE cards SET used=1 WHERE id=?";
		
		$statement=$mysqli->prepare($hitcommand);
		$statement->execute();
		$r=$statement->get_result();
		$result=$r->fetch_assoc();
		$temp=$mysqli->store_result();
		print_r($result);
		//Δουλευει μεχρι την γραμμη 151
		//αμα παω να βαλω και αλλο prepared statement που βγαζει το ερρορ με την bind_param...	
	}
	
	function stand()
	{
		$statuscommand="SELECT turn FROM game_status";
		$statement=$mysqli->prepare($statuscommand);
		$statement->execute();
		$result=$statement->get_result();
		if($result==1)
		{
			$new_turn='2';
			$updatecommand="UPDATE game_status SET turn= ? ";
			$statement=$mysqli->prepare($updatecommand);
			$statement->bind_param('s',$new_turn);
			$statement->execute();
		}
		else if($result==2)
		{
			check_winner();
		}
	}
	
	function check_winner()
	{
		
	}
?>
