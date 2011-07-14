<?php
	require('php/MobileSupportUtil.php');
	
	$profiler = new MobileSupportUtil();
	$mobileDevice = $profiler->isMobileDevice();
	
	$arrayDevices = array('iphone','ipod','android','pre');
	
	$isFeaturePhone = false;
	
	$currentURL = (!empty($_SERVER['HTTPS'])) ? "https://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'] : "http://".$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
	
	if($mobileDevice)
	{
		if(in_array(strtolower($mobileDevice), $arrayDevices))
		{
			//is advanced
			echo '<!DOCTYPE html>
			
			<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
				<meta charset="utf-8"/>';
		} else {
			//is not advanced
			echo '<?xml version=”1.0” encoding=”UTF-8”?>
			<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.1//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile11.dtd">
			
			<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<meta http-equiv="Content-Type" content="application/xhtml+xml" />';
			
			$isFeaturePhone = true;
		}
	} else {
		echo '<!DOCTYPE html>
		
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta charset="utf-8"/>';
		
	} 
	
	//load favs from a cookie
	$cookieArray = unserialize( stripcslashes($_COOKIE['surfFavs']));
		
?>
		<title>World Surf | Mobile</title>
		
		<!-- <meta http-equiv="Cache-Control" content="max-age=10" /> -->
		
		<?php
			if($isFeaturePhone ==false){
				echo '<link rel="stylesheet" type="text/css" href="css/main.css" />'."\n";
			}
		?>
		<script src="js/jquery-1.4.4.min.js" type="text/javascript"></script>
		<script src="js/main.js" type="text/javascript"></script>
	</head>
	
	<body>
		<div id="nav">
			<ul>
				<li id="favoriteBtn">
					<p><a class="expandButton" href="#">Favorites</a></p>
					<div id="favoriteDropdown" class="expandArea">
						<ul>
							<?php
								if(!empty($cookieArray)){
									$favCount = 0;
									foreach($cookieArray as $fav){
										$linkURL = "city.php?city=". urlencode($fav['city'])."&country=". urlencode($fav['country']) ."&lat=". $fav['lat'] ."&long=". $fav['long'];
										
										$deleteURL = "php/deleteFav.php?fav=$favCount&backto=". urlencode($currentURL);
										
										echo "<li><a href=\"$linkURL\">". $fav['city'] ." - <span>". $fav['country'] ."</span></a><a class='closeBtn' href=\"$deleteURL\">&#215;</a></li>\n";
										
										$favCount++;
									}
								}else{
									echo "<li class='noFavs'>You don't have any favorites!</li>\n";
								}	
							?>
						</ul>
					</div><!-- end infoBlock -->
					
				</li>
				
				<li id="newSearchBtn">
					<p><a class="expandButton" href="#">New Search</a></p>
					<div id="newSearchDropdown" class="expandArea">
						<form method="get" action="searchResults.php">
							<p>
								<label for="newSearch">Search by - <span>city, zip</span></label><br />
								<input id="newSearch" type="text" name="newSearch" value="" />
								<input class="orangeButton" type="submit" name="button" value="Search" />
							</p>
						</form>
						<p>Or search by your <a class="orangeButton geoLoc" href="#">Current Location</a></p>
					</div><!-- end newSearchDropdown -->
				</li>
				<li id="logo"><h1><a href="index.php">World Surf</a></h1></li>
			</ul>
		</div><!-- end nav -->