<?php 
	function show_status()
	{
		global $mysqli;
		$sqlcommand="SELECT * FROM game_status";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		
		$result=$statement->get_result();
		
		header('Content-type: application/json');
		print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
		
		
		
	}


?>