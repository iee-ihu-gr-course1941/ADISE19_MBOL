<?php 
	//DONE
	function return_current_status()
	{
		global $mysqli;
		$sqlcommand="SELECT status,turn,result,last_change FROM game_status";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		$result=$statement->get_result();
		$status=$result->fetch_assoc();
		return $status;
		
	}

	//DONE
	function show_status()
	{
		global $mysqli;
		$sqlcommand="SELECT status,turn,result,last_change FROM game_status";
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		
		$result=$statement->get_result();
		
		header('Content-type: application/json');
		print json_encode($result->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
		
		
		
	}
	//DONE
	function update_game_status()
	{
		global $mysqli;
		$new_status=NULL;
		$new_turn=NULL;
		
		
		/*PAIRNW TO TREXON STIGMIOTIPO TOU GAME_STATUS*/
		$statuscommand="SELECT status,turn,result,last_change FROM game_status";
		$statement=$mysqli->prepare($statuscommand);
		$statement->execute();
		$result=$statement->get_result();
		$status=$result->fetch_assoc();
		
		/*ELEGXO GIA AUTOUS POU PREPEI NA FANE TIME OUT*/
		$sqlcommand="SELECT COUNT(*) AS INACTIVE FROM players WHERE last_action<(NOW() - INTERVAL 1000 MINUTE)";//KICK INTERVAL EINAI 5 LEPTA 
		$statement=$mysqli->prepare($sqlcommand);
		$statement->execute();
		$r=$statement->get_result();
		$result=$r->fetch_assoc()['INACTIVE'];
		if($result>0)
		{
			$sqlcommand = "UPDATE players SET username='', token=NULL WHERE last_action< (NOW() - INTERVAL 1000 MINUTE)";
			$statement = $mysqli->prepare($sqlcommand);
			$statement->execute();
			if($status['status']=='STARTED')//AN TO PAIXNIDI EXEI KSEKINISEI KAI O PAIKTHS ARGISEI PANW APO 5 LEPTA NA KANEI ACTION TRWWEI KICK KAI TO STATUS
				$new_status='ABORTED'; //GINETAI ABOIRTED
			
		}
		
		
		/*PAIRNW TO POSOI PAIKTES EINAI AUTH THN STIGMH STHN BASH*/
		$playerscommand="SELECT COUNT(*) AS C FROM players WHERE username !='' ";
		$statement=$mysqli->prepare($playerscommand);
		$statement->execute();
		$result=$statement->get_result();
		$players=$result->fetch_assoc();
		
		
		
		
		
		if($players['C']==0)
		{
			$new_status='NOT ACTIVE';
		}
		else if($players['C']==1)
		{
			$new_status='INITIALIZED';
		}
		else if($players['C']==2)
		{
			$new_status='STARTED';
			//EDW ELEGXO AN KSEKINAEI TO PAIXNIDI GIA PRWTI FORA NA DWSW TO TURN STON PLAYER
			if($status['turn']==NULL)
			{
				$new_turn='Player';
			}
		}
		
		$updatecommand="UPDATE game_status SET status=?,turn= ? ";
		$statement=$mysqli->prepare($updatecommand);
		$statement->bind_param('ss',$new_status,$new_turn);
		$statement->execute();
		echo "SUCCESS IN UPDATING GAME STATUS: STATUS IS NOW ".$new_status;
	}


?>