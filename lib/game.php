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

	}

	function update_points($request,$token)
	{
		global $mysqli;
		$points=$request[0];
		
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
			print json_encode(['errormesg'=>"Not a registered player,can't update points."]);
			exit;
		}
		
		$update="UPDATE players SET points= ? WHERE token = ?";
		$statement=$mysqli->prepare($update);
		$statement->bind_param('is',$points,$token);
		$statement->execute();
		header('HTTP/1.1 200 OK');
	}
	
	function end_game()
	{
		global $mysqli;
		$new_status='ENDED';
		$new_turn=NULL;
		$null=NULL;
		
		$updatecommand="UPDATE game_status SET status=?,turn= ? ,result = ?";
		$statement=$mysqli->prepare($updatecommand);
		$statement->bind_param('sss',$new_status,$new_turn,$null);
		$statement->execute();
		
		
	}	
	
	function fetch_played_cards($request)
	{
		global $mysqli;
		$melos=$request[0];
		if($melos != 'Player' && $melos!='Dealer')
		{
			print json_encode(['errormesg' =>"You need to fetch the cards of either PLAYER or DEALER ." ]);
			exit;
		}
		else
		{
			if($melos=='Player')
			{
				$statement=$mysqli->query("SELECT id,symbol,value,sxima FROM cards WHERE player_cards_played=1");
				header("HTTP/1.1 200 OK");
				print json_encode($r=$statement->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
			}
			else
			{
				$statement=$mysqli->query("SELECT id,symbol,value,sxima FROM cards WHERE dealer_cards_played=1");
				header("HTTP/1.1 200 OK");
				print json_encode($r=$statement->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
			}
		}
	}
	
?>
