<?php
	require 'php/header.php';
	
	$searchQuery = "";
	if(!empty($_GET['newSearch'])){
		$searchQuery = $_GET['newSearch'];
	}else{
		header('Location:index.php');
	}
	
	//uses curl to hit the weather api since my host is blocking url_fopen
	function curl_get_contents ($url) {
		$curl = curl_init();
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($curl, CURLOPT_URL, $url);
		$html = curl_exec($curl);
		curl_close($curl);
		return $html;
	}
	
	$apiCall = curl_get_contents("http://www.worldweatheronline.com/feed/search.ashx?key=fb8e512d61032537100912&query=". urlencode($searchQuery) ."&num_of_results=3&format=xml");
	// optional params decode the cdata within the xml
	if(isset($apiCall)){
		try{
			$xml = simplexml_load_string($apiCall,'SimpleXMLElement', LIBXML_NOCDATA);
		}catch (Exception $e) {
		
		}
	}
?>
		<div id="welcomeBlock">
			<h2><span class="orangeSerif">Search</span> results</h2>
			<p>Choose a location</p>
		</div><!-- end welcomeBlock -->
		
		<div class="infoBlock">
			<div class="infoFrame">
				<h3 class="orangeSerif"><?=$searchQuery ?></h3>
				<ul class="infoList">
					<?php
						if($xml->result){
							foreach($xml->result as $result){
								$linkURL = "city.php?country=". urlencode($result->country) ."&city=". urlencode($result->areaName) . "&search=" . urlencode($searchQuery) ."&lat=". urlencode($result->latitude) ."&long=". urlencode($result->longitude);
								echo "<li><a href=\"$linkURL\">". $result->areaName ." - <span>". (($result->region)?$result->region . ", ":"") . $result->country ."</span></a></li>\n";
							}
						}else{
							echo "<p>There are no matches, please try another search.</p>";
						}
					?>
				</ul>
				<div class="blockBottom"><!-- <a class="whiteSerif" id="moreBtn" href="#">More</a> --></div>
			</div>
		</div><!-- end infoBlock -->
		<?php require 'php/footer.php';