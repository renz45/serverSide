<?php
/*
    Plugin Name: cil - Custom Item List
    Plugin URI: http://to be determined!
    Description: Create custom lists that can be inserted into posts/pages and manage each list from the admin panel
    Version: 1.0
    Author: Adam Rensel
    Author URI: http://www.adamrensel.com
*/

//TODO add a way to reorganize list items within a list
//TODO add nested lists
//TODO add html template for individual lists in the settings panel
//TODO add the ability to edit list items without pinning them to the side menu
//TODO ajax pagination for the user side

//for development only, remove after development is done.
include 'views/php_dump.php';

global $cilPluginURL;
$cilPluginURL = plugins_url("",__FILE__);

//add hook to import the main css file for this plugin, only load the css if the admin panel is open

//includes code which installs database tables
require("models/cil_model_installDataBase.php");

//run installation methods
register_activation_hook(__FILE__,'cil_install');
register_activation_hook(__FILE__,'cil_install_data');

//require the models class
require 'models/cil_models.php';

global $wpdb;

global $cil_model;
$cil_model = new Cil_Models($wpdb);

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
require("views/cil_view_adminListEdit.php");



?>
