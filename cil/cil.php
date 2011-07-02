<?php
/*
    Plugin Name: cil - Custom Item List
    Plugin URI: http://to be determined!
    Description: Create custom lists that can be inserted into posts/pages and manage each list from the admin panel
    Version: 1.0
    Author: Adam Rensel
    Author URI: http://www.adamrensel.com
*/


$cilPluginURL = plugins_url("",__FILE__);


//add hook to import the main css file for this plugin, only load the css if the admin panel is open

//includes code which installs database tables
include("php/cil_installDataBase.php");

//register_activation_hook(__FILE__,'cil_install_data'); //enable this when debugging is done.

//short code functionality include
include("php/cil_shortCodes.php");


//admin menu
include("php/cil_adminMenu.php");


//view files
include("views/cil_adminOptionsView.php");

?>
