var me={token:null,melos:null};
var game_status={};
var card={};
var game_stat_old={};
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



$(document).ready(function(){
$(function () {
	timer=setInterval(function(){ game_status_update(); },1000);
	timer_cards=setInterval(function(){ calculate_points(); },1000);
	fill_card_blank();
	$('#player-score-value').show(500);
	$('#player-chips-value').show(500);
	
	$('#take_card').prop('disabled', true);
	$('#hit').prop('disabled', true);
	$('#stand').prop('disabled', true);
	
	$('#bj_login').click( login_to_game);
	$('#bj_reset').click( reset_card);
	$('#take_card').click(do_deal);
	$('#hit').click(do_hit);
	$('#stand').click(do_stand);

});

function calculate_points(){
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
				
				player_points+=parseInt(obj.value);
				$('#player-score-value').html(player_points);
			}
			if(player_points<=21){
				$.ajax({url: 'blackjack.php/players/'+game_status.turn+'/'+player_points , method: "POST" , headers: {"X-Token": me.token}, success: function(){console.log("Points registered");} } );	
			}
			else{ 
				console.log(player_points);
				console.log("Busted Player!");
				do_stand();
				}
		}
		else if (game_status.turn=='Dealer'){
			for(i=0;i<dealer_cards.length;i++)
			{
				obj=dealer_cards[i];
				dealer_points+=parseInt(obj.value);
				$('#dealer-score-value').html(dealer_points);
			}
			if(dealer_points<=21){
				$.ajax({url: 'blackjack.php/players/'+game_status.turn+'/'+player_points , method: "POST" , headers: {"X-Token": me.token}, success: function(){console.log("Points registered");} } );	
			}
		else {
			console.log(player_points);
			console.log("Busted Player!");
			do_stand();
			}
		}	
	else alert("Something"); 
	
	


}
}

function fill_card_by_data(data) {
	var card = data[0];
	var melos=$('#ch_seat').val();
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
		game_stat_old = game_status;
		game_status=data[0];
		
		
		if(game_status.status=='NOT ACTIVE')
		{
			$('#status').html("<p>"+game_status.status+ "</p>");	
		}
		else if(game_status.status=='INITIALIZED')
		{		
			$('#status').html("<p>"+game_status.status+ "</p>");	
		}
		else if (game_status.status=="STARTED" )  {
			$('#take_card').prop('disabled', false);
			$('#hit').prop('disabled', false);
			$('#stand').prop('disabled', false);
			$('#status').html("<p>"+game_status.status+ "</p>");	
			
		}
		else {
		return;
		}
	} 
	, headers: {"X-Token": me.token} });
	
	if (flag==false) {
		flag=true;
		refresh_dealer();
	}
	
	
	
}

function update_info(){
	$('#game_info').html("I am Player: "+me.melos+", my name is "+me.username +'<br>Token='+me.token);
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
					
					
					
				}
				else if(game_status.turn=='Dealer')
				{
					dealer_cards[counter++]=obj;
					simbolo=obj.symbol;
					schema=obj.sxima;
					$('#card_shown_1').html("<img id='cards' src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
					counter_d=1;
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
					
				}
				else if(game_status.turn=='Dealer')
				{
					dealer_cards[counter++]=obj;
					simbolo=obj.symbol;
					schema=obj.sxima;
					$('#card_shown_3').html("<img id='cards_2' src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
					counter_d=2;
				}
			$('#take_card').hide(1000);
				
				
			} 
			
		});
	
	
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
						}
						else
						{
							player_cards[counter++]=obj;		
							simbolo=obj.symbol;
							schema=obj.sxima;
							$('#card_shown_'+hit_p).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
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
						}
						else
						{
							dealer_cards[counter++]=obj;			
							simbolo=obj.symbol;
							schema=obj.sxima;
							$('#card_shown_'+hit_d).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
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
	var obj;
	var simbolo;
	var schema;
	hit_p=2;
	var sum=0;
	game_status_update();
	if(game_status.turn=='Player')
	{
		$.ajax({url: 'blackjack.php/deck/stand/' , method: "GET" , headers: {"X-Token": me.token} , success: function(){ console.log("Success is standing player "); } });	
	}
	else if(game_status.turn=='Dealer')
	{
		flag=false;
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

	$.ajax({url: 'blackjack.php/deck/fetch/Dealer' , method: "GET" , headers: {"X-Token": me.token} , success: 
		function(data)
		{
			obj=JSON.parse(data);
			console.log(obj);
			console.log(obj.length);
			for(var i=0;i<obj.length;i++)
			{
				simbolo=obj[i].symbol;
				schema=obj[i].sxima;
				sum_dealer+=parseInt(obj[i].value);
				$('#card_shown_'+hit_d).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
				hit_d+=2;
			}
			$('#dealer-score-value').html(sum_dealer);
			
		} });
	
}

function refresh_player() {
	var obj;
	var simbolo;
	var schema;
	hit_p=2;
	var sum_player=0;
	
	$.ajax({url: 'blackjack.php/deck/fetch/Player' , method: "GET" , headers: {"X-Token": me.token} , success: 
		function(data)
		{
			obj=JSON.parse(data);
			console.log(obj);
			console.log(obj.length);
			for(var i=0;i<obj.length;i++)
			{
				simbolo=obj[i].symbol;
				schema=obj[i].sxima;
				sum_player+=parseInt(obj[i].value);
				$('#card_shown_'+hit_p).html("<img src='classic-cards/"+simbolo+"_"+schema+".png' width='71px' height='96px'/>");
				hit_p+=2;
			}
			$('#player-score-value').html(sum_player);
			
		} });
}

function fill_card() {
	$.ajax({url: "blackjack.php/deck/hit/", 
		headers: {"X-Token": me.token,
		method: "GET" },
		success: fill_card_by_data });
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
	$.ajax({url: "blackjack.php/deck/", headers: {"X-Token": me.token}, method: 'POST',  success: fill_card_by_data });
	$('#game_initializer').show(1000);
	fill_card_blank_reset();
	
}

/*
function update_status(data) {
	last_update=new Date().getTime();
	var game_stat_old = game_status;
	game_status=data[0];
	update_info();
	clearTimeout(timer);
	if(game_status.melos==me.melos &&  me.melos!=null) {
		x=0;
		// do play
		if(game_stat_old.melos!=game_status.melos) {
			fill_card();
		}
		$('#move_div').show(1000);
		timer=setTimeout(function() { game_status_update();}, 15000);
	} else {
		// must wait for something
		$('#move_div').hide(1000);
		timer=setTimeout(function() { game_status_update();}, 4000);
	}
}
*/
});
