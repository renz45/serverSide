<?php

if(is_admin())
{
	//import external scripts if on the admin page
	wp_enqueue_style('cil_optionScript', $cilPluginURL.'/css/cil_admin.css'); 
	//set up menus
	add_action('admin_menu', 'cil_plugin_menus');
}

//adds the actual list edit menu
function cil_plugin_menus() { 
	$page = add_menu_page('Custom Item Lists', 'Item Lists', 'manage_options', 'cil_adminListEditView.php', 'cil_plugin_listEdit_options', "",6);
	//add hook to load external files used for the top level pinned list menu - js/css	
	 add_action('admin_print_styles-' . $page , 'cil_topLevelMenu_externalFileLoad');
	
	$page = add_options_page('cil - Custom Item Lists', 'cil', 'manage_options', 'cil_adminOptionsView.php', 'cil_plugin_optionMenu_options', "");
	//add hook to load external files used for the options menu - js/css	
	 add_action('admin_print_styles-' . $page , 'cil_optionsMenu_externalFileLoad');
}

//show top level list edit page - pinned lists
function cil_plugin_listEdit_options() {
	if (!current_user_can('manage_options'))  {
		wp_die( __('You do not have sufficient permissions to access this page.') );
	}
	
	echo '<div class="wrap">';
	echo '<p>Here is where the form would go if I actually had options. <a id="test">TEST!</a></p>';
	echo '</div>';
}

//show the options page
function cil_plugin_optionMenu_options() {
	if (!current_user_can('manage_options'))  {
		wp_die( __('You do not have sufficient permissions to access this page.') );
	}
	
	//show admin options view, this view exists in cil_adminOptionsView.php
	do_action('show_admin_options_menu');
}

//load external css, js here for the plugin options page
function cil_optionsMenu_externalFileLoad(){

	//load javascript specific to this option menu.
	global $cilPluginURL;
	
	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/js/cil_optionMenu.js');
	wp_enqueue_style('cil_optionStyle', $cilPluginURL.'/css/cil_admin_optionsMenu.css');
}

//load external css/js for top level pinned lists
function cil_topLevelMenu_externalFileLoad(){

}

?>