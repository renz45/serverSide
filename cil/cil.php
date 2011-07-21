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
//TODO add html template for individual lists in the settings panel
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
register_activation_hook(__FILE__,'cil_install_data');

//wordpress database class used in the 2 model instantiations
global $wpdb;

//require the models class
require 'models/cil_models.php';

//ajax models
require 'models/ajaxModel.php';

//admin menu
require("controllers/cil_controller_adminMenu.php");

//view files
require("views/cil_view_adminOptions.php");
require("views/cil_view_adminListEdit.php");

//short code functionality include
require("views/cil_view_shortCodes.php");

//help drop down contents for the various menus
require("views/cil_view_help.php");

?>
