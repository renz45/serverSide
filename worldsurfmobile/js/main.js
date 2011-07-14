$(function(){
	//nav buttons
	$('.expandButton').bind('click',function(){
		if($(this).hasClass('active')){
			$(this).removeClass('active').parent().parent().find('.expandArea').removeClass('active');
		}else{
			$('.expandArea').removeClass('active');
			$('.expandButton').removeClass('active');
			$(this).addClass('active').parent().parent().find('.expandArea').addClass('active');
		}
		
		return false;
	})
	
	
	
	//cardstack
	$('.card1').bind('click',function(){
		
		$(this).addClass('active');
		$('.cardArea1').addClass('active');
		$('.card2').removeClass('active');
		$('.cardArea2').removeClass('active');
		
		return false;

	});
	
	$('.card2').bind('click',function(){
		
		$(this).addClass('active');
		$('.cardArea2').addClass('active');
		$('.card1').removeClass('active');
		$('.cardArea1').removeClass('active');

		return false;
	});
	
	//geolocation
	
	function initiate_geolocation() {  
		navigator.geolocation.getCurrentPosition(handle_geolocation_query,handle_errors);  
	}  
	
	function handle_errors(error)  
	{  
		switch(error.code)  
		{  
			case error.PERMISSION_DENIED: alert("user did not share geolocation data");  
			break;  
			
			case error.POSITION_UNAVAILABLE: alert("could not detect current position");  
			break;  
			
			case error.TIMEOUT: alert("retrieving position timed out");  
			break;  
			
			default: alert("unknown error");  
			break;  
		}  
	}  
	
	function handle_geolocation_query(position){  
		document.location.href = 'city.php?city='+ position.coords.latitude +'&country='+ position.coords.longitude +'&lat='+ position.coords.latitude +'&long='+position.coords.longitude;
	}
	
	$(".geoLoc").click(initiate_geolocation); 
	
	//swell indicator
	/*
	min swell = 0m
	max swell = 3m
	
	water min = -1.4em
	water max = -14em
	11.6em difference
	*/
	
	//filter the swell value from the string
	var swellHeights = $('.swellHeight');
	
	$.each(swellHeights,function(i){
		
		var txt= $(swellHeights[i]).html();
		var re1='.*?';	// Non-greedy match on filler
		var re2='([+-]?\\d*\\.\\d+)(?![-+0-9\\.])';	// Float 1
		
		var p = new RegExp(re1+re2,["i"]);
		var m = p.exec(txt);
		
		var swell = m[1];
		
		//find perecent based on a 3m max
		var swellPercent = swell/3;
		
		if(swellPercent > 1){
			swellPercent = 1;
		}
		
		//get the ems based on swell percent to move the water graphic
		var moveDistance = 11.6 * swellPercent;
		//subtract from 13, which is our zero point 
		moveDistance = 14 - moveDistance;
		//change to negative since we are working negative in css
		moveDistance *= -1;
		//change the css value to adjust the image
		$(swellHeights[i]).parent().parent().css({'bottom':moveDistance+"em"});
	
	});
	
	     
		 
		
		
});//end main.js