<?php 
	function show_deck()
	{
		global $mysqli;
		
		$sqlcommand="SELECT * FROM cards";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		
		$result=$statement->get_result();
		header('Content-type: application/json');
		
		print json_encode($result->fetch_all(MYSQLI_ASSOC),JSON_PRETTY_PRINT);			
	}
	
	function reset_deck(){
		global $mysqli;
		
		$sqlcommand="call reset_cards()";
		$mysqli->query($sqlcommand);
		
		$sqlcommand="UPDATE players SET username='' , token=NULL , points=0 WHERE melos LIKE 'Player' OR melos LIKE 'Dealer'";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		
		
		$sqlcommand="UPDATE game_status SET status='NOT ACTIVE',turn=NULL";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		
		show_deck();
		
		
		
	}


?>