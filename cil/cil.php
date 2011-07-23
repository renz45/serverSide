<?php
/*
    Plugin Name: cil - Custom Item List
    Plugin URI: http://to be determined!
    Description: Create custom lists that can be inserted into posts/pages and manage each list from the admin panel
    Version: 1.0
    Author: Adam Rensel
    Author URI: http://www.adamrensel.com
*/

//TODO ajax pagination for the user side
//TODO option to remove the database

//////////////dev aids//////////////////
include 'dev_aids/php_dump.php';
/////////////Remove after dev//////////////////

//define the plugin url
global $cilPluginURL;
$cilPluginURL = plugins_url("",__FILE__);

//includes code which installs database tables
require("models/cil_model_installDataBase.php");

//run installation methods
register_activation_hook(__FILE__,'cil_install');

//wordpress database class used in the 2 model instantiations
global $wpdb;

//require the models class
require 'models/cil_models.php';

//ajax models
require 'models/ajaxModel.php';

//admin menu
require("controllers/cil_controller_adminMenu.php");

if(is_admin())
{//load admin files if on admin side
	//view files
	require "views/cil_view_adminOptions.php";
	require "views/cil_view_adminListEdit.php";

	//help drop down contents for the various menus
	require "views/cil_view_help.php";
}else{//load the client side files
	require "views/cil_view_template.php";
}

//short code functionality include
require "views/cil_view_shortCodes.php";



?>
