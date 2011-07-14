<?php

if( isset($_GET['backto']) && isset($_GET['fav'])){
	$fav = $_GET['fav'];
	$backTo = $_GET['backto'];
}else{
	header('Location:../index.php');
	print_r("trying to go back!");
}

$cookieArray = unserialize( stripcslashes($_COOKIE['surfFavs']));

unset($cookieArray[$fav]);
$cookieArray = array_values($cookieArray);


setcookie('surfFavs',serialize($cookieArray),time()+60*60*24*365*50,'/');

header("Location:$backTo");


