<?php 
	/*error_reporting(E_ALL);
	ini_set('display_errors', 1);
	ini_set('display_errors','on' );*/
	require_once "lib/board.php";
	require_once "lib/dbconnect.php";
	require_once "lib/game.php";
	require_once "lib/users.php";
	
	$method=$_SERVER['REQUEST_METHOD'];

	//$method="GET";
	
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
										if($method=="GET")
											stand_card($input['token']);
										else
										{
											header("HTTP/1.1 400 Bad Request");
											print json_encode(['errormesg'=>"Method $method not allowed here."]);
										}	
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
			
			case($name!='Dealer' && $name!='Player'):
					if($method=="GET")
					{
						show_player_info($name);
					}
					else
					{
						header("HTTP/1.1 400 Bad Request");
						print json_encode(['errormesg'=>"Method $method not allowed here."]);
						
					}
					break;
			
			case($name=='Player'):
					if($method=="PUT")
					{
						
						register_player($request);
					}
					else
					{
						header("HTTP/1.1 400 Bad Request");
						print json_encode(['errormesg'=>"Method $method not allowed here."]);
					}
					break;
			case($name=='Dealer'):
					if($method=="PUT")
					{
						
						register_dealer($request);
					}
					else
					{
						header("HTTP/1.1 400 Bad Request");
						print json_encode(['errormesg'=>"Method $method not allowed here."]);
					}
					break;
				
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
		$statement=$mysqli->query("CALL draw_card()");
		$result=$statement->fetch_assoc();
		$statement->close();
		print_r($result);
		free_all_results($mysqli);
		mark_a_card($result['id']);
		
		
		/*EMEINA EDW LEITOYRGOYN OLA*/
		
	}
	function free_all_results(mysqli $dbCon)
	{
		do 
		{
			if ($res = $dbCon->store_result()) 
			{
				$res->fetch_all(MYSQLI_ASSOC);
				$res->free();
			}
		}while ($dbCon->more_results() && $dbCon->next_result());
	}
	function mark_a_card($id)
	{
		global $mysqli;
		$update="UPDATE cards SET used=1 WHERE id=?";
		$statement=$mysqli->prepare($update);
        $statement->bind_param('i',$id);
        $statement->execute();
	}
	
	function stand_card($token)
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
		
		/*$statuscommand="SELECT turn FROM game_status";
		$statement=$mysqli->prepare($statuscommand);
		$statement->execute();
		$result=$statement->get_result();*/
		
		if($status['turn']=='Player')
		{
			$new_turn='Dealer';
			$updatecommand="UPDATE game_status SET turn= ? ";
			$statement=$mysqli->prepare($updatecommand);
			$statement->bind_param('s',$new_turn);
			$statement->execute();
		}
		else if($status['turn']=='Dealer')
		{
			echo "Check Winner";
			check_winner();
		}
		
		$selectcommand="SELECT * FROM game_status";
		$statement=$mysqli->query($selectcommand);
		
		
		header('Content-type: application/json');
		print json_encode($result=$statement->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
		
		
	}
	/*
	function check_winner()
	{
		
	}
	*/
?>
