$(function(){

//example app modal pop up
//sponsor pop up
$('.sampleApps li a').bind('click', function(){
	picAddress = $(this).attr('href');
	appName = $(this).html();
	$(this).parent().parent().parent().parent().parent().parent().find('.exampleModal').append('<div class="appExampleModal">'+
			'<div class="center">'+
				'<p><img src="'+picAddress+'" alt="'+appName+'" width="116" height="174" /><br />'+
				'<span>Live Rider Cycling Computer</span></p>'+
				'<p class="closeBtn"><a href="#">Close</a></p>'+
			'</div>'+
		'</div>').find('.closeBtn a').bind('click', function(){
		
			$(this).parent().parent().parent().parent().empty();
			return false;
		});
		
		return false;
});

//free account pop up
$('.freeAccountInfo .sampleApps li a').bind('click', function(){
	picAddress = $(this).attr('href');
	appName = $(this).html();
	$(this).parent().parent().parent().parent().parent().parent().parent().find('.exampleModal').append('<div class="appExampleModal">'+
			'<div class="center">'+
				'<p><img src="'+picAddress+'" alt="'+appName+'" width="116" height="174" /><br />'+
				'<span>Live Rider Cycling Computer</span></p>'+
				'<p class="closeBtn"><a href="#">Close</a></p>'+
			'</div>'+
		'</div>').find('.closeBtn a').bind('click', function(){
		
			$(this).parent().parent().parent().parent().empty();
			return false;
		});
		
		return false;
});
//end example app modal pop up

//free account info expand
$('.companyName a').bind('click', function(){
	$(this).parent().parent().find('.freeAccountInfo').css({'height':'auto','overflow':'visible'});
	
	return false;
});
//end free account info expand

//menu drop downs

$('.btn').bind('click',function(){
	
	if($(this).hasClass('active')){
		$(this).removeClass('active');
		$(this).find('.modal').removeClass('active');
	}else{
		$(this).addClass('active');
		$(this).find('.modal').addClass('active');
	}
	
	return false;
});

$('.btn').bind('mouseleave',function(){
	
	$(this).removeClass('active');
	$(this).find('.modal').removeClass('active');
	
	return false;
});

$('.btn2').bind('click',function(){
	
	if($(this).hasClass('active')){
		$(this).removeClass('active');
		$(this).find('.modal').removeClass('active');
	}else{
		$(this).addClass('active');
		$(this).find('.modal').addClass('active');
	}
	
	return false;
});
//end menu drop downs

});//end main.js file