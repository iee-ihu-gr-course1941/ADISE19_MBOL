<?php 
	require_once "lib/board.php";
	require_once "lib/dbconnect.php";
	require_once "lib/game.php";
	require_once "lib/users.php";
	
	$method=$_SERVER['REQUEST_METHOD'];

	//$method="PUT";

	
	
	$request=explode('/',trim($_SERVER['PATH_INFO'],'/'));
	$input = json_decode(file_get_contents('php://input'),true);
	
	
	
	switch ($uri=array_shift($request)) {
		case "deck ":
					switch ($par=array_shift($request)) 
					{
							case "":	break;
							case null: manipulate_board($method);
										break;
							case "hit" :
										hit_card($method);
										break;
							case "stand":
										stand_card($method);
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
			show_board();
		else if ($method=="POST")
			reset_board();
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
	
	
	

	
	
	
	function hit_card($method)
	{
		;
		
	}
	
	function stand_card($method)
	{
		;
		
	}
	
?>
