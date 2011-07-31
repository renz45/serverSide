<?php
/*
    Plugin Name: cil - Custom Item List
    Plugin URI: http://to be determined!
    Description: Create custom lists that can be inserted into posts/pages and manage each list from the admin panel
    Version: 1.0
    Author: Adam Rensel
    Author URI: http://www.adamrensel.com
*/

/*
Copyright (C) 2011  Adam Rensel

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

//TODO ajax pagination for the user side

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
register_deactivation_hook( __FILE__, 'cil_uninstall' );

//wordpress database class used in the 2 model instantiations
global $wpdb;
$wpdb->hide_errors(); //this must be hidden for error feedback messages to show.

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
