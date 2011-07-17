<?php
	require 'php/header.php';
	$searchQuery = "";
	if(!empty($_GET['long']) && !empty($_GET['lat'])){
		$cityQuery = $_GET['city'];
		$countryQuery = $_GET['country'];
		$long = $_GET['long'];
		$lat = $_GET['lat'];
		$search = $_GET['search'];
	}else{
		header('Location:index.php');
	}
	
	function curl_get_contents ($url) {
		$curl = curl_init();
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl, CURLOPT_URL, $url);
		$html = curl_exec($curl);
		curl_close($curl);
		return $html;
	}
	
	//tap 5 day forecast API using a combination city/country name
	if(empty($cityQuery) && empty($countryQuery)){
		$cityQuery = $lat;
		$countryQuery = $long;
	}
	$forecast = curl_get_contents("http://free.worldweatheronline.com/feed/weather.ashx?q=". urlencode($cityQuery) .",". urlencode($countryQuery) ."&format=xml&num_of_days=5&key=fb8e512d61032537100912");
	// optional params decode the cdata within the xml
	try{
		$forecastXML = simplexml_load_string($forecast,'SimpleXMLElement', LIBXML_NOCDATA);
	}catch(Exception $e){
	
	}
	
	//tap marine weather api using latitude and longitude
	$marineForecast = curl_get_contents("http://free.worldweatheronline.com/feed/marine.ashx?q=". $lat .",". $long ."&format=xml&key=fb8e512d61032537100912");
	// optional params decode the cdata within the xml
	try{
		$marineForecastXML = simplexml_load_string($marineForecast,'SimpleXMLElement', LIBXML_NOCDATA);
	}catch(Exception $e){
	
	}
	
?>
		<div id="welcomeBlock">
			<?php
				if(!empty($_GET['favMax']) && $_GET['favMax']==true){
					echo "<p id='favMax'>You have reached the favorite limit of 10, please delete a favorite before adding a new one.</p>\n";
				}
			?>
			<h2><span class="orangeSerif">Weather</span> Report For <a class="orangeButton" href="php/addFav.php?country=<?=urlencode($countryQuery)?>&city=<?= urlencode($cityQuery)?>&lat=<?=$lat?>&long=<?=$long?>&search=<?=urlencode($search)?>">Favorite <span> + </span></a></h2>		
			<p><?=$cityQuery?>, <?=$countryQuery?></p>
			<div class="leftCol">
				<p><span class="orangeSerif">Temperature:</span> <?=$forecastXML->current_condition->temp_F ?>&#176;F</p>
				<p><span class="orangeSerif">Sky:</span> <?=$forecastXML->current_condition->weatherDesc ?></p>
				<p><span class="orangeSerif">Wind:</span> <?=$forecastXML->current_condition->windspeedMiles ?>mph from the <?=$forecastXML->current_condition->winddir16Point ?></p>
			</div><!-- end rightCol -->		
			<div class="rightCol">
				<p><span class="orangeSerif">Humidity:</span> <?=$forecastXML->current_condition->humidity ?>%</p>
				<p><span class="orangeSerif">Pressure:</span> <?=$forecastXML->current_condition->pressure ?>mb</p>
				<p><span class="orangeSerif">Cloud Cover:</span> <?=$forecastXML->current_condition->cloudcover ?>%</p>
				<p><span class="orangeSerif">Rain:</span> <?=$forecastXML->current_condition->precipMM ?>mm</p>
			</div><!-- end leftCol -->	
		</div><!-- end welcomeBlock -->
		<div class="infoBlock">
			<div class="infoFrame">
				<div class="cardNav">
					<h3 class="card1"><a href="#"><?=count($forecastXML->weather)?> Day Forecast</a></h3>
					<h3 class="card2 active"><a href="#">Near Surf Forecast</a></h3>
				</div><!-- end cardNav -->	
				<ul class="infoList forecastList cardArea1">
					<?php
						foreach($forecastXML->weather as $weather){
							
							$date = date("l", strtotime($weather->date));
							
							echo "	<li class='expandButton'>
										<a href=\"$linkURL\">". $date ." - <span> ". implode(".", explode("-", $weather->date)) ."</span></a>
										<div class='cityDay'>
											<div class='leftCol'>
												<p><span class='orangeSerif'>Temp Max:</span> ". $weather->tempMaxF ."&#176;F</p>
												<p><span class='orangeSerif'>Temp Min:</span> ". $weather->tempMinF ."&#176;F</p>
												<p><span class='orangeSerif'>Sky:</span> ". $weather->weatherDesc ."</p>
												<p><span class='orangeSerif'>Wind:</span> ". $weather->windspeedMiles ."mph from the ". $weather->winddir16Point ."</p>
											</div><!-- end rightCol -->
											<div class='rightCol'>
												<p><span class='orangeSerif'>Humidity:</span> ". $weather->humidity ."%</p>
												<p><span class='orangeSerif'>Pressure:</span> ". $weather->pressure ."mb</p>
												<p><span class='orangeSerif'>Cloud Cover:</span> ". $weather->cloudcover ."%</p>
												<p><span class='orangeSerif'>Rain:</span> ". $weather->precipMM ."mm</p>
											</div><!-- end leftCol -->
										</div>
									</li>\n";
						}
					?>
				</ul>
				<ul class="infoList marineList cardArea2 active">
					<?php
						
						if(!$marineForecastXML->weather->hourly)
						{
							echo "<h2> Woops no data for this location </h2>";
						}else{
							foreach($marineForecastXML->weather->hourly as $hourly){
								
								//converts time into a normal 12 hour format and creates time of day labels
								$timeConvert = $hourly->time / 100;
								
								if($timeConvert <= 5){
									$dayTime = "Night";
									$timeAbr = "am";
								}else if($timeConvert > 5 && $timeConvert < 12){
									$dayTime = "Morning";
									$timeAbr = "am";
								}else if($timeConvert > 11 && $timeConvert < 18){
									$dayTime = "Afternoon";
									$timeAbr = "pm";
								}else if($timeConvert > 17 && $timeConvert < 24 ){
									$dayTime = "Evening";
									$timeAbr = "pm";
								}
								
								//if time is 0
								if($timeConvert == 0){
									$time = "1:00";
								}else{
									if($timeConvert > 12){
										$timeConvert = $timeConvert - 12;
									}
									$time = $timeConvert . ":00";
								}
								
								//swell direction, changes degree value to a letter value
								$swellDir = $hourly->swellDir;
								$swellDirStr = "";
								
								if($swellDir >= 337.5 || $swellDir <=22.5){
									$swellDirStr = "N";
								}elseif($swellDir > 22.5 && $swellDir < 67.5){
									$swellDirStr = "NE";
								}elseif($swellDir >= 67.5 && $swellDir <=112.5){
									$swellDirStr = "W";
								}elseif($swellDir > 112.5 && $swellDir <157.5){
									$swellDirStr = "SE";
								}elseif($swellDir >= 157.5 && $swellDir <=202.5){
									$swellDirStr = "S";
								}elseif($swellDir > 202.5 && $swellDir <=247.5){
									$swellDirStr = "SW";
								}elseif($swellDir >= 247.5 && $swellDir <=295.5){
									$swellDirStr = "W";
								}elseif($swellDir > 295.5 && $swellDir < 337.5){
									$swellDirStr = "NW";
								}
								
								echo "	<li class='expandButton'>
											<a href=\"$linkURL\">". $dayTime ." - <span> ". $time . $timeAbr ."</span></a>
											<div class='cityDay cityMarine'>
												<div class='leftCol'>
													<p><span class='orangeSerif'>Wind Speed:</span> ". $hourly->windspeedMiles ."mph</p>
													<p><span class='orangeSerif'>Wind Direction:</span> ". $hourly->winddir16Point ."</p>
												</div><!-- end rightCol -->
												<div class='rightCol'>
													<p class='normalTemp'>". $hourly->tempF ."&#176;F</p>
												</div><!-- end leftCol -->
												<p class='marineDescription'>". $forecastXML->current_condition->weatherDesc ."</p>	
												<div class='waterInfo'>
													<div class='leftCol swellInfo'>
														<p class='swellHeight'>Swells - ". $hourly->sigHeight_m ."m</p>
														<p>Waves - ". $hourly->swellHeight_m ."m</p>
													</div><!-- leftCol -->
													<div class='leftCol'>
														<p class='swellDir'>". $swellDirStr ."</p>
													</div><!-- leftCol -->
												</div><!-- end waterInfo -->
												<p class='marineFooter'>Water - <span>". $hourly->waterTemp_F ."&#176;F</span> | Swell Period - <span>". $hourly->swellPeriod_secs ."s</span></p>
											</div>
										</li>\n";
							}
						}//end if
					?>
				</ul>
				<div class="blockBottom"></div>
			</div>
		</div><!-- end infoBlock -->
		<?php require 'php/footer.php';