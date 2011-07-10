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
require("models/cil_model_installDataBase.php");

//run installation methods
register_activation_hook(__FILE__,'cil_install');
register_activation_hook(__FILE__,'cil_install_data');

//require the models class
require 'models/cil_models.php';
global $model;
$model = new Cil_Models($wpdb);

//ajax models
require 'models/ajaxModel.php';

//short code functionality include
require("views/cil_view_shortCodes.php");

//admin menu
require("controllers/cil_controller_adminMenu.php");

//help drop down contents for the various menus
require("views/cil_view_help.php");

//view files
require("views/cil_view_adminOptions.php");


?>
