<?php
//list edit menu
add_action('admin_menu', 'cil_plugin_listEdit_menu');
//plugin options menu
add_action('admin_menu', 'cil_plugin_options_menu');

//import external scripts if on the admin page
if(is_admin())
{
	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/css/cil_admin.css');
}

//adds the actual list edit menu
function cil_plugin_listEdit_menu() { 

	add_menu_page('Custom Item Lists', 'Item Lists', 'manage_options', 'cil_adminListEditView.php', 'cil_plugin_listEdit_options', "",8);
	
}

function cil_plugin_listEdit_options() {
	if (!current_user_can('manage_options'))  {
		wp_die( __('You do not have sufficient permissions to access this page.') );
	}
	
	
	echo '<div class="wrap">';
	echo '<p>Here is where the form would go if I actually had options.</p>';
	echo '</div>';
}


//plugin options menu
//adds the actual list edit menu
function cil_plugin_options_menu() { 

	$page = add_options_page('cil - Custom Item Lists', 'cil', 'manage_options', 'cil_adminOptionsView.php', 'cil_plugin_optionMenu_options', "");
	
	//add hook to load external files used for the options menu - js/css	
	 add_action('admin_print_styles-' . $page, 'cil_optionsMenu_externalFileLoad');
}

function cil_plugin_optionMenu_options() {
	if (!current_user_can('manage_options'))  {
		wp_die( __('You do not have sufficient permissions to access this page.') );
	}
	
	//show admin options view
	do_action('show_admin_options_menu');
}

//load external css, js here for the plugin options page
function cil_optionsMenu_externalFileLoad(){

	//load javascript specific to this option menu.
	global $cilPluginURL;
	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/js/cil_optionMenu.js');
	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/css/cil_admin_optionsMenu.css');
}

?>