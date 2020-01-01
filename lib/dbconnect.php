<?php
	$host="localhost";
	$db="blackjack";
	$user="root";
	$pass="";
	if(gethostbyname($host)=='users.iee.ihu.gr')
		$mysqli=new mysqli($host,$user,$pass,$db,null,"/home/student/it/2017/it174896/mysql/run/mysql.sock");
	else
		$mysqli=new mysqli($host,$user,$pass,$db);
	
	if($mysqli->connect_errno)
	{
		echo "Failed to connect to MySQL: (".$mysqli->connect_errno.") ".$mysqli->connect_error; 
		
	}
 ?>
