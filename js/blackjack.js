var me={token:null,melos:null};
var game_status={};
var last_update=new Date().getTime();
var timer=null;
var timer_cards=null;
var melos=null;
var hit_p=6;
var hit_d=5;
var flag=true;
var player_played_cards=new Array();
var dealer_played_cards=new Array();
var dealer_cards=new Array();
var counter_d=0;
var player_cards=new Array();
var counter_p=0;
var counter=0;
var player_points=0;
var dealer_points=0;
var ace_point=0;


$(document).ready(function(){
$(function () {
	timer=setInterval(function(){ game_status_update(); },1000);
	timer_cards=setInterval(function(){ calculate_points(); },1000);
	fill_card_blank();
	$('#player-score-value').show(500);
	$('#player-chips-value').show(500);
	$('#game_info').hide();
	$('#display_winner').hide();
	$('#turn').hide();
	$('#ace').hide();
	$('#scores').hide();
	
	$('#take_card').prop('disabled', true);
	$('#hit').prop('disabled', true);
	$('#stand').prop('disabled', true);
	
	$('#bj_login').click( login_to_game);
	$('#bj_reset').click( reset_card);
	$('#take_card').click(do_deal);
	$('#hit').click(do_hit);
	$('#stand').click(do_stand);
	$('#ace_one').click(ace_one);
	$('#ace_eleven').click(ace_eleven);

});

function calculate_points() {
	player_points=0;
	dealer_points=0;
	var obj;
	game_status_update();
	if(game_status.status=='STARTED')
	{
		if(game_status.turn=='Player'){
			for(var i=0;i<player_cards.length;i++)
			{
				obj=player_cards[i];
				if(obj.symbol!="A")
				{
					player_points+=parseInt(obj.value);			
				} 
				else 
				{
					if(ace_point==1)
						player_points+=parseInt(ace_point);
					else if(ace_point==11)
						player_points+=parseInt(ace_point);
				}
				$('#player-score-value').html(player_points);
			}
		}
		else if (game_status.turn=='Dealer')
		{
			for(i=0;i<dealer_cards.length;i++)
			{
				obj=dealer_cards[i];
				if(obj.symbol!="A")
				{
					dealer_points+=parseInt(obj.value);
					
				}
				else 
				{
					if(ace_point==1)
						dealer_points+=parseInt(ace_point);
					else if(ace_point==11)
						dealer_points+=parseInt(ace_point);
				}
			$('#dealer-score-value').html(dealer_points);	
			}
			
		}
		register_points();
	}	 
}

function register_points() {
	if(game_status.turn=='Player')
	{
			/*
			if(player_points<=21)
			{
				$.ajax({url: 'blackjack.php/players/Player/'+player_points+'/', headers: {"X-Token": me.token} , method: "POST"  , success: function(){ console.log("Success in registering Points of Player "); } });	
			}
			else
			{ 
				$.ajax({url: 'blackjack.php/players/Player/0/', headers: {"X-Token": me.token} , method: "POST"  , success: function(){ console.log("Success in registering BUSTED player! "); } });	
				do_stand();
			}
			*/
			if(player_points>21)
			{
				$('#hit').hide(1000);
				$('#stand').html("<b>Fold</b>");
			}
			$.ajax({url: 'blackjack.php/players/Player/'+player_points+'/', headers: {"X-Token": me.token} , method: "POST"  , success: function(){ console.log("Success in registering Points of Player "); } });	
	}
	
	else if(game_status.turn=='Dealer')
	{
		/*
		if(dealer_points<=21)
		{
			$.ajax({url: 'blackjack.php/players/Dealer/'+dealer_points+'/', headers: {"X-Token": me.token} , method: "POST"  , success: function(){ console.log("Success in registering Points of Dealer "); } });	
		}
		else 
		{
			$.ajax({url: 'blackjack.php/players/Dealer/0/', headers: {"X-Token": me.token} , method: "POST"  , success: function(){ console.log("Success in registering BUSTED dealer "); } });	
			do_stand();
		}
		*/
		if(dealer_points>21)
		{
				$('#hit').hide(1000);
				$('#stand').html("<b>Fold</b>");
		}
		$.ajax({url: 'blackjack.php/players/Dealer/'+dealer_points+'/', headers: {"X-Token": me.token} , method: "POST"  , success: function(){ console.log("Success in registering Points of Dealer "); } });	
	}	
}

function login_to_game() {
	if($('#username').val()=='' ||  $('#username').val()== null ) {
		alert('You have to set a username');
		return;
	}
	var username = $('#username').val();		
	
	var melos=$("#ch_seat").val();
	$.ajax({url: "blackjack.php/players/"+melos+"/"+username, 
			method: 'PUT',
			dataType: "json",
			headers: {"X-Token": me.token},
			contentType: 'application/json',
			data: JSON.stringify( {username: $('#username').val(), melos: ch_seat}),
			success: login_result ,
			error: login_error
			});
}

function login_result(data,y,z,c) {
	me = data[0];
	$('#game_initializer').hide(1000);
	update_info();
}	

function login_error(data,y,z,c) {
	var x = data.responseJSON;
	alert(x.errormesg);
}

function game_status_update() {
	
	melos=$('#ch_seat').val(); 
	
	$.ajax({url: "blackjack.php/status/", success: function(data)
	{
		last_update=new Date().getTime();
		game_status=data[0];
		var obj_player;
		var obj_dealer;
		var obj;
		if(game_status.status=='NOT ACTIVE')
		{
			$('#status').html("<p><b>"+game_status.status+ "</b></p>");	
		} 
		else if(game_status.status=='INITIALIZED')
		{	
			$('#game_info').show(1000);
			$('#status').html("<p><b>"+game_status.status+ "</b></p>");
			$.ajax({url: 'blackjack.php/players/' , method:"GET", headers: {"X-token":me.token} , success:function(data)
			{
				obj=JSON.parse(data);
				obj_player=obj[0];
				obj_dealer=obj[1];
				$('#turn').show(1000);
				if(obj_player.username=="")
				{	
					$('#turn').html("Waiting for a <b>Player</b> ");
				}
				else if(obj_dealer.username=="")
				{
					$('#turn').html("Waiting for a <b>Dealer</b> ");
				}
			}});
		}
		else if (game_status.status=="STARTED") {
				$('#scores').show(1000);
				$('#take_card').prop('disabled', false);
				$('#status').html("<p><b>"+game_status.status+ "</b></p>");
				if(game_status.turn!= null)
				{
					$('#turn').show(1000);
					$('#turn').html("It's <b>"+game_status.turn+"'s </b> turn");
				}
		}
		else if(game_status.status=="ENDED" && flag==true)
		{
			flag=false;
			refresh_dealer();
			$('#display_winner').show(1000);
			$('#hit').prop('disabled', true);
			$('#stand').prop('disabled', true);
			if(game_status.result=="DRAW"){
				$('#display_winner').html("IT'S A DRAW!");
			}
			else if (game_status.result=="DW"){
				$.ajax({url :'blackjack.php/players/Dealer', method:"GET", headers:{"X-token":me.token},success: function(data)
				{
					$('#display_winner').html("The Dealer : "+data[0].username+" WINS !");
				}  });
				
			}
			else if (game_status.result=="PW"){
				$.ajax({url :'blackjack.php/players/Player', method:"GET", headers:{"X-token":me.token},success: function(data)
				{
					$('#display_winner').html("The Player: "+data[0].username+" WINS !");
				}  });
			}	
			$('#turn').hide();
			$('#status').html("<p><b>"+game_status.status+ "</b></p>");
			$('#game_info').html("<b>The game has ended.</b></br><p>Please <b>reset</b> to play again</p>");
			clearInterval(timer);
			clearInterval(timer_cards);			
		}
		else if(game_status.status=="ABORTED")
		{
			$('#status').html("<b >ABORTED</b>");
			$('#game_info').html("<b>GAME ABORTED DUE TO PLAYER INACTIVITY</b></br><p>please reset the game</p>");
			$('#turn').hide(1000);
			$('#stand').hide(1000);
			$('#hit').hide(1000);
			
		}
		else {
			return;
		}
	} 
	, headers: {"X-Token": me.token} });
	
	
	
	
}

function update_info(){
	$('#game_info').html("I am Player: <b>"+me.melos+"</b>, my name is <b>"+me.username +'</b><br>Token='+me.token);
}

function do_deal() {
	var simbolo;
	var schema;
	var obj;
		$.ajax({url: 'blackjack.php/deck/hit' , headers: {"X-Token": me.token}, method: "GET" , success: 
			function(data)
			{
				obj=JSON.parse(data);
				if(game_status.turn=='Player')
				{				
					player_cards[counter++]=obj;		
					simbolo=obj.symbol;
					schema=obj.sxima;
					$('#card_shown_2').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
					counter_p=1;
					if(simbolo=="A"){
						$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
						$('#ace').show(1000);
					}
				}
				else if(game_status.turn=='Dealer')
				{
					dealer_cards[counter++]=obj;
					simbolo=obj.symbol;
					schema=obj.sxima;
					$('#card_shown_1').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
					counter_d=1;
					if(simbolo=="A"){
						$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
						$('#ace').show(1000);
					}
				}	
			} 			
		});
		$.ajax({url: 'blackjack.php/deck/hit' , headers: {"X-Token": me.token}, method: "GET" , success: 
			function(data)
			{
				obj=JSON.parse(data);
				if(game_status.turn=='Player')
				{
					player_cards[counter++]=obj;	
					simbolo=obj.symbol;
					schema=obj.sxima;	
					$('#card_shown_4').html("<img id='cards_2' src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
					counter_p=2;
					if(simbolo=="A"){
						$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
						$('#ace').show(1000);
					}					
				}
				else if(game_status.turn=='Dealer')
				{
					dealer_cards[counter++]=obj;
					simbolo=obj.symbol;
					schema=obj.sxima;
					$('#card_shown_3').html("<img id='cards_2' src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
					counter_d=2;
					if(simbolo=="A"){
						$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
						$('#ace').show(1000);
					}
				}
			$('#take_card').hide(1000);
			} 	
		});
		$('#hit').prop('disabled', false);
		$('#stand').prop('disabled', false);
	}
	
function do_hit() {
	var simbolo;
	var schema;
	var obj;
		$.ajax({url: 'blackjack.php/deck/hit' , headers: {"X-Token": me.token}, method: "GET" , success: 
			function(data)
			{
				obj=JSON.parse(data);
				if(game_status.turn=='Player')
				{
					if(counter_p<5)
					{
						if(hit_p==6){
							player_cards[counter++]=obj;		
							simbolo=obj.symbol;
							schema=obj.sxima;
							$('#card_shown_'+hit_p).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
							if(simbolo=="A"){
								$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
								$('#ace').show(1000);
							}
						}
						else
						{
							player_cards[counter++]=obj;		
							simbolo=obj.symbol;
							schema=obj.sxima;
							$('#card_shown_'+hit_p).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
							if(simbolo=="A"){
								$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
								$('#ace').show(1000);
							}
						}
						hit_p+=2;
						counter_p++;
					}
					else alert("You can't Hit more than 5 cards!");
					
				}
				else if(game_status.turn=='Dealer')
				{
					if(counter_p<5)
					{	
						if(hit_d==5)
						{
							dealer_cards[counter++]=obj;		
							simbolo=obj.symbol;
							schema=obj.sxima;
							$('#card_shown_'+hit_d).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
							if(simbolo=="A"){
								$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
								$('#ace').show(1000);
							}
						}
						else
						{
							dealer_cards[counter++]=obj;			
							simbolo=obj.symbol;
							schema=obj.sxima;
							$('#card_shown_'+hit_d).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
							if(simbolo=="A"){
								$('#ace_image').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='25px' height='42px'/>");
								$('#ace').show(1000);
							}
						}
						hit_d+=2;
						counter_d++;
					}
					else alert("You can't hit more than 5 cards!");
				}
			} 	
		});
}

function do_stand() {
	game_status_update();
	if(game_status.turn=='Player')
	{
		$('#hit').hide(1000);
		$('#stand').hide(1000);	
		$.ajax({url: 'blackjack.php/deck/stand/' , method: "GET" , headers: {"X-Token": me.token} , success: function(){ console.log("Success is standing player "); } });	
	}
	else if(game_status.turn=='Dealer')
	{
		$('#hit').hide(1000);
		$('#stand').hide(1000);
		$.ajax({url: 'blackjack.php/deck/stand/' , method: "GET" , headers: {"X-Token": me.token} , success: function(){ console.log("Success is standing dealer "); } });
		refresh_player();
		
	}
	
}

function refresh_dealer() {
	var obj;
	var simbolo;
	var schema;
	hit_d=1;
	var sum_dealer=0;
	/*Edw Pairnw mono ta fylla pou exei traviksei me DEN Ypologizw dynamika tous pontous*/
	$.ajax({url: 'blackjack.php/deck/fetch/Dealer/cards' , method: "GET" , headers: {"X-Token": me.token} , success: 
		function(data)
		{
			obj=JSON.parse(data);
			for(var i=0;i<obj.length;i++)
			{
				simbolo=obj[i].symbol;
				schema=obj[i].sxima;
				$('#card_shown_'+hit_d).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
				hit_d+=2;
			}		
		} });
		/*Edw pairnw mono tous pontous poy exoun eisaxthei sthn vash*/
	$.ajax({url: 'blackjack.php/deck/fetch/Dealer/points' , method: "GET" , headers: {"X-Token": me.token} , success: 
		function(data)
		{
			obj=JSON.parse(data);
			sum_dealer=parseInt(obj.points);
			$('#dealer-score-value').html(sum_dealer);		
		} });
	
}

function refresh_player() {
	var obj;
	var simbolo;
	var schema;
	hit_p=2;
	var sum_player=0;
	/*Edw Pairnw mono ta fylla pou exei traviksei o player me DEN Ypologizw dynamika tous pontous*/
	$.ajax({url: 'blackjack.php/deck/fetch/Player/cards' , method: "GET" , headers: {"X-Token": me.token} , success: 
		function(data)
		{
			obj=JSON.parse(data);
			for(var i=0;i<obj.length;i++)
			{
				simbolo=obj[i].symbol;
				schema=obj[i].sxima;
				$('#card_shown_'+hit_p).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
				hit_p+=2;
			}		
		} });
		/*Edw pairnw mono tous pontous poy exoun eisaxthei sthn vash*/
	$.ajax({url: 'blackjack.php/deck/fetch/Player/points' , method: "GET" , headers: {"X-Token": me.token} , success: 
		function(data)
		{
			obj=JSON.parse(data);
			sum_player=parseInt(obj.points);
			$('#player-score-value').html(sum_player);			
		} });
}

function fill_card_blank() {
	$('#card_shown_1').html("<img src='classic-cards/b2fv.png' width='71px' height='96px'/>");
	$('#card_shown_2').html("<img src='classic-cards/b2fv.png' width='71px' height='96px'/>");
	$('#card_shown_3').html("<img src='classic-cards/b2fv.png' width='71px' height='96px'/>");
	$('#card_shown_4').html("<img src='classic-cards/b2fv.png' width='71px' height='96px'/>");
}

function fill_card_blank_reset() {
	location.reload();
}

function reset_card() {
	$.ajax({url: "blackjack.php/deck/", headers: {"X-Token": me.token}, method: 'POST', success: function(){return;}});
	$('#game_initializer').show(1000);
	fill_card_blank_reset();
	
}

function ace_one(){
	ace_point=1;
	$('#ace').hide(1000);
}

function ace_eleven(){
	ace_point=11;
	$('#ace').hide(1000);
}

function autoDealer(){
	if (game_status.turn=='Dealer')
	{
	while (dealer_points <= 16)
	{
		for(i=0;i<dealer_cards.length;i++)
		{
			obj=dealer_cards[i];
			if(obj.symbol!="A")
				{
					dealer_points+=parseInt(obj.value);
				
				}
				else 
				{
					if(ace_point==1)
						dealer_points+=parseInt($('#ace_one').html());
					else if(ace_point==11)
						dealer_points+=parseInt($('#ace_eleven').html());
				}
			$('#dealer-score-value').html(dealer_points);	
		}
		if (dealer_points =< 16)
		{
			do_hit();
		}
		else
		{
			do_stand();
		}
	}
	}
}

function create_autoDealer(){
	var username = $Computer;		
	
	var melos=$Dealer;
	$.ajax({url: "blackjack.php/players/"+melos+"/"+username, 
			method: 'PUT',
			dataType: "json",
			headers: {"X-Token": me.token},
			contentType: 'application/json',
			data: JSON.stringify( {username: $Computer, melos: $Dealer}),
			success: login_result ,
			error: login_error
			});
}


function login_to_vsComp() {
	if($('#username').val()=='' ||  $('#username').val()== null ) {
		alert('You have to set a username');
		return;
	}
	var username = $('#username').val();		
	
	var melos=$Player;
	$.ajax({url: "blackjack.php/players/"+melos+"/"+username, 
			method: 'PUT',
			dataType: "json",
			headers: {"X-Token": me.token},
			contentType: 'application/json',
			data: JSON.stringify( {username: $('#username').val(), melos: Player}),
			success: login_result ,
			error: login_error
			});
	create_autoDealer();
}
});
