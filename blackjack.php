<?php 
	require_once "lib/board.php";
	require_once "lib/dbconnect.php";
	require_once "lib/game.php";
	
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
	/*
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
	*/
	
	
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
	
	

	/*DONE!*/
	function show_all_players($method)
	{
		global $mysqli;
		if($method=="GET")
		{
			$sqlcommand="SELECT username,melos,points FROM players";
			$statement=$mysqli->prepare($sqlcommand);
			$statement->execute();
			$result=$statement->get_result();
			header("HTTP/1.1 200 OK");
			print json_encode($result->fetch_all(MYSQLI_ASSOC),JSON_PRETTY_PRINT);
		}
		else
		{
				header("HTTP/1.1 400 Bad Request");
		}
		
	}
	/*DONE!*/
	function show_player_info($name)
	{
		global $mysqli;
		$sqlcommand="SELECT username,melos,points FROM players WHERE username like ?";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->bind_param('s',$name);
		$statement->execute();
		$result=$statement->get_result();
		header('Content-type: application/json');
		print json_encode($result->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);	
	}
	/*DONE*/
	function register_player($name,$input)
	{
		global $mysqli;
		//print_r($input);
		/*
		if(!isset($input['username'])) {
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"No username given."]);
		exit;
		*/
		$username=$name;
		$sqlcommand="SELECT COUNT(*) AS C FROM players WHERE username=''";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		$r=$statement->get_result();
		$result=$r->fetch_all(MYSQLI_ASSOC);
		echo "Poses grammes einai eleutheres: \t";
		print_r($result);
		if($result[0]['C']==2){
			$updatecommand="UPDATE players SET username= ? WHERE melos LIKE '1'";
			$statement=$mysqli->prepare($updatecommand);
			$statement->bind_param('s',$name);
			$statement->execute();
		}
		else if($result[0]['C']==1)
		{
			$sqlcommand="SELECT melos FROM players WHERE username=''";
			$statement=$mysqli->prepare($sqlcommand);
			$statement->execute();
			$r=$statement->get_result();
			$result=$r->fetch_all(MYSQLI_ASSOC);
			print_r($result);
			if($result[0]['melos']=='1')
			{
				$updatecommand="UPDATE players SET username= ? WHERE melos='1'";
				$statement=$mysqli->prepare($updatecommand);
				$statement->bind_param('s',$name);
				$statement->execute();
				
			}
			else if($result[0]['melos']=='2')
			{
				$updatecommand="UPDATE players SET username= ? WHERE melos='2'";
				$statement=$mysqli->prepare($updatecommand);
				$statement->bind_param('s',$name);
				$statement->execute();
			}	
		}
		else if($result[0]['C']==0)
		{
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"Can't accept more than 2 players."]);
			exit;
		}

		/*EFOSON KANEI REGISTER O PRWTOS PAIKTHS
		PREPEI AUTOMATA NA ENHMERWSW TON PINAKA game_status*/
	
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
