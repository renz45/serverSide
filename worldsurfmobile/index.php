<?php
	require 'php/header.php';
	//load favs from a cookie
	$cookieArray = unserialize( stripcslashes($_COOKIE['surfFavs']));
?>
		<div id="welcomeBlock">
			<h2><span class="orangeSerif">Welcome</span> to World Surf Mobile</h2>
			
			<p>Search or choose a favorite location to <br />
			view weather and surf conditions.</p>
			
			<p><a class="orangeButton geoLoc" href="#">Current Location</a></p>
		</div><!-- end welcomeBlock -->
		<div class="infoBlock">
			<div class="infoFrame">
				<h3 class="orangeSerif">Favorites</h3>
				<ul class="infoList">
				<?php
					if(!empty($cookieArray)){
						$favCount = 0;
						foreach($cookieArray as $fav){
							$linkURL = "city.php?city=". urlencode($fav['city'])."&country=". urlencode($fav['country']) ."&lat=". $fav['lat'] ."&long=". $fav['long'];
							
							$deleteURL = "php/deleteFav.php?fav=$favCount&backto=". urlencode($currentURL);
							
							echo "<li><a href=\"$linkURL\">". $fav['city'] ." - <span>". $fav['country'] ."</span></a></li>\n";
							
							$favCount++;
						}
					}else{
						echo "<li class='noFavs'>You don't have any favorites!</li>\n";
					}	
				?>
				</ul>
				<div class="blockBottom"><!-- <a class="whiteSerif" id="moreBtn" href="#">More</a> --></div>
			</div>
		</div><!-- end infoBlock -->
		<?php require 'php/footer.php';