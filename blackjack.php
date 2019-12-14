<?php 
	require_once "lib/board.php";
	require_once "lib/dbconnect.php";
	require_once "lib/game.php";
	
	//$method=$_SERVER['REQUEST_METHOD'];

	$method="PUT";

	
	
	$request=explode('/',trim($_SERVER['PATH_INFO'],'/'));
	$input = json_decode(file_get_contents('php://input'),true);
	
	
	
	switch ($uri=array_shift($request)) {
		case "deck ":
					switch ($par=array_shift($request)) {
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
					switch ($par=array_shift($request))
					{
						case "": show_all_players($method);
											break;
						/*EMEINA EDW*/
						case !($par==null) :
											show_players_info($method,array_shift($request));
											break; 
						default:
								header("HTTP/1.1 404 Not Found");
								break;
					}
					
		case "status ":
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
	function manipulate_board($method)
	{
		if($method=="GET")
			show_board();
		else if ($method=="POST")
			reset_board();
	}
	function show_players_info($method,$username)
	{
		global $mysqli;
		
		if($method=="GET")
		{
			$sqlcommand="SELECT * FROM players WHERE username like ?";
			
			$statement=$mysqli->prepare($sqlcommand);
			$statement->bind_param('s',$username);
			$statement->execute();
			$result=$statement->get_result();
			header('Content-type: application/json');
			print json_encode($result->fetch_all(MYSQLI_ASSOC),JSON_PRETTY_PRINT);	
			
			
		}
		else if($method=="PUT")
		{
		  $id_available=return_available_melos();
		  echo "id_available:";
		  echo $id_available;
		  if($id_available == '' )
		  {
			  header("HTTP/1.1 404 Can't handle more Players");
			  exit;
		  } 
		  else{
			$sqlcommand="INSERT INTO players(username,melos,points) VALUES(?,'".$id_available."',0)";
			$statement=$mysqli->prepare($sqlcommand);
			$statement->bind_param("s",$username);
			$statement->execute();
			echo "INSERTION COMPLETE";
			header("HTTP/1.1 200 OK");
		  }
		}
	}
	
	
	function return_available_melos()
	{
		//working
		global $mysqli;
		$sqlcommand="SELECT COUNT(*) AS NUMBER FROM players";
		$statement=$mysqli->query($sqlcommand);
		$resultSet=$statement->fetch_assoc();
		$number_of_rows=$resultSet['NUMBER'];
		
		if($number_of_rows==0)
		{
			return '1';			
		}
		else if($number_of_rows==1)
		{
			$sqlcommand="SELECT melos  FROM players";
			$statement=$mysqli->query($sqlcommand);
			$resultSet=$statement->fetch_assoc();
			echo '$resultSet[melos]';   
			print_r($resultSet['melos']);
			if($resultSet['melos']=='1')
				return '2';
			else if($resultSet['melos']=='2')
				return '1'; 
		}
		else if($number_of_rows>1)
		{
			return '';
			
		}
		
	}
		
	
	
	function show_all_players($method)
	{
		global $mysqli;
		if($method=="GET")
		{
			$sqlcommand="SELECT * FROM players";
			$resultSet=$mysqli->query($sqlcommand);
			print json_encode($resultSet->fetch_all(MYSQLI_ASSOC),JSON_PRETTY_PRINT);
			header("HTTP/1.1 200 OK");
			
		}
		else
		{
				header("HTTP/1.1 404 Not Found");
		}
		
	}
	
	/*
	function hit_card($method)
	{
		;
		
	}
	
	function stand_card($method)
	{
		;
		
	}
	*/
?>
