var me={token:null,melos:null};
var game_status={};
var card={};
var last_update=new Date().getTime();
var timer=null;

$(document).ready(function(){
$(function () {
	//draw_empty_card();
	//fill_deck();
	
	$('#bj_login').click( login_to_game);
	$('#bj_reset').click( reset_card);

	//$('#move_div').hide();
	game_status_update();
});

function draw_empty_card(data){
	
};

function fill_card_by_data() {
	
}


function login_to_game() {
	if($('#username').val()=='' ||  $('#username').val()== null ) {
		alert('You have to set a username');
		return;
	}
	var username = $('#username').val();
	//draw_empty_card(ch_seat);
	//fill_card();			
	
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
	alert(me);
	$('#game_initializer').hide(1000);
	update_info();
	game_status_update();
}	


function login_error(data,y,z,c) {
	var x = data.responseJSON;
	alert(x.errormesg);
}


function game_status_update() {
	
	clearTimeout(timer);
	$.ajax({url: "blackjack.php/status/", success: function(data)
	{
		var st=data[0];
		
		$('#player-score-value').html("<h1>"+st.status+ "</h1>");
	} 
	, headers: {"X-Token": me.token} });
	
}



function update_info(){
	$('#game_info').html("I am Player: "+me.melos+", my name is "+me.username +'<br>Token='+me.token/*+'<br>Game state: '+game_status.status+', '+ game_status.melos+' must play now.'*/);
}


/*
function fill_card() {
	$.ajax({url: "blackjack.php/deck/hit/", 
		headers: {"X-Token": me.token,
		method: "GET" },
		success: fill_card_by_data });
}

*/
function reset_card() {
	$.ajax({url: "blackjack.php/deck/", headers: {"X-Token": me.token}, method: 'POST',  success: fill_card_by_data });
	$('#move_div').hide();
	$('#game_initializer').show(2000);
}

/*
function update_status(data) {
	last_update=new Date().getTime();
	var game_stat_old = game_status;
	game_status=data[0];
	update_info();
	clearTimeout(timer);
	if(game_status.turn==me.melos &&  me.melos!=null) {
		x=0;
		// do play
		if(game_stat_old.p_turn!=game_status.p_turn) {
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
