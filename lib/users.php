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
	function show_all_players()
	{
		global $mysqli;
		$sqlcommand="SELECT * FROM players";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		$result=$statement->get_result();
		header("HTTP/1.1 200 OK");
		print json_encode($result->fetch_all(MYSQLI_ASSOC),JSON_PRETTY_PRINT);
		
	}
	/*DONE!*/
	function show_player_info($input)
	{
		global $mysqli;
		if(!isset($input['melos'])) {
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"Didn't choose a role."]);
			exit;
		}
		$melos=$input['melos'];
		$sqlcommand="SELECT * FROM players WHERE melos like ?";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->bind_param('s',$melos);
		$statement->execute();
		$result=$statement->get_result();
		if($result->num_rows == 0)
		{
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"No $melos found in the database."]);
		}
		else{
			header('Content-type: application/json');
			print json_encode($result->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);	
		}
	}
	
	
		/*DONE!*/
	function register_user($input)
	{
		global $mysqli;
		
		if(!isset($input['username'])) {
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"No username given."]);
			exit;
		}
		if(!isset($input['melos'])) {
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"Didn't choose a role."]);
			exit;
		}
		$melos=$input['melos'];
		$username=$input['username'];
		//$melos=$request[0];
		
		$select="SELECT username FROM players WHERE melos LIKE ? ";
		$statement=$mysqli->prepare($select);
		$statement->bind_param('s',$melos);
		$statement->execute();
		$r=$statement->get_result();
		$result=$r->fetch_assoc();
		
		if($result['username']==''){
			$update="UPDATE players SET username=? ,token=md5(CONCAT( ? ,NOW())) WHERE melos LIKE ? ";
			$statement=$mysqli->prepare($update);
			$statement->bind_param('sss',$username,$username,$melos);
			$statement->execute();
			
		}
		else{
			header("HTTP/1.1 400 Bad Request");
			print json_encode(['errormesg'=>"Role '$melos' already taken."]);
			exit;
		}	
		update_game_status();		
		$sqlcommand="SELECT * FROM players WHERE username like ?";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->bind_param('s',$username);
		$statement->execute();
		$result=$statement->get_result();
		header("HTTP/1.1 200 OK");
		header('Content-type: application/json');
		print json_encode($result->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
	
	}
	




?>