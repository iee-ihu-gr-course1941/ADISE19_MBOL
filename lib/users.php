<?php 	
	//function 
	function is_melos($token)
	{
		global $mysqli;
		$sqlcommand="SELECT * FROM players WHERE token like ?";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->bind_param('s',$token);
		$statement->execute();
		$result=$statement->get_result();
		
		if($row=$result->fetch_assoc())
		{
			return $row['melos'];
		}
			return null;
	}
	/*DONE*/
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
		$sqlcommand="SELECT * FROM players WHERE username like ?";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->bind_param('s',$name);
		$statement->execute();
		$result=$statement->get_result();
		header('Content-type: application/json');
		print json_encode($result->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);	
	}
	
		/*DONE!*/
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
			$updatecommand="UPDATE players SET username= ? ,token=md5(CONCAT( ? ,NOW())) WHERE melos LIKE '1'";
			$statement=$mysqli->prepare($updatecommand);
			$statement->bind_param('ss',$name,$name);
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
				$updatecommand="UPDATE players SET username= ? ,token=md5(CONCAT( ? ,NOW())) WHERE melos='1'";
				$statement=$mysqli->prepare($updatecommand);
				$statement->bind_param('ss', $name, $name);
				$statement->execute();
				
			}
			else if($result[0]['melos']=='2')
			{
				$updatecommand="UPDATE players SET username= ? ,token=md5(CONCAT( ? ,NOW())) WHERE melos='2'";
				$statement = $mysqli->prepare($updatecommand);
				$statement->bind_param('ss', $name, $name);
				$statement->execute();
			}	
		}
		else if($result[0]['C']==0)
		{
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"Can't accept more than 2 players."]);
			exit;
		}

		update_game_status();
		
		$sqlcommand="SELECT * FROM players WHERE username like ?";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->bind_param('s',$name);
		$statement->execute();
		$result=$statement->get_result();
		
		header('Content-type: application/json');
		print json_encode($result->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
	
	}




?>