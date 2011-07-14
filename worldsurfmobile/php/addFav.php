<?php
//setcookie ("surfFavs", "", time() - 3600);

if( !empty($_GET['city']) && !empty($_GET['country']) && !empty($_GET['lat']) && !empty($_GET['long']) ){
	$city = $_GET['city'];
	$country = $_GET['country'];
	$lat = $_GET['lat'];
	$long = $_GET['long'];
	$search = $_GET['search'];
}else{
	header('Location:../index.php');
}

if( isset($_COOKIE['surfFavs']) ){
	$cookieArray = unserialize( stripcslashes($_COOKIE['surfFavs']));

	$position = count($cookieArray);
	
	if($position > 10){
		header("Location:../city.php?city=". urlencode($city)."&country=". urlencode($country) ."&lat=$lat&long=$long&search=". urlencode($search) ."&favMax=true");
	}
	
	$cookieArray[$position] = array('city'=>$city, 'country'=>$country, 'lat'=>$lat, 'long'=>$long); 
	
	setcookie('surfFavs',serialize($cookieArray),time()+60*60*24*365*50,'/');
}else{
	$cookieData[0] = array('city'=>$city, 'country'=>$country, 'lat'=>$lat, 'long'=>$long);
	setcookie('surfFavs',serialize($cookieData),time()+60*60*24*365*50,'/');
}

header("Location:../city.php?city=". urlencode($city)."&country=". urlencode($country) ."&lat=$lat&long=$long&search=". urlencode($search));


