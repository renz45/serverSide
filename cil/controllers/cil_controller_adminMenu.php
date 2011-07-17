<?php

if(is_admin())
{
	//import external scripts if on the admin page
	wp_enqueue_style('cil_optionScript', $cilPluginURL.'/css/cil_admin.css');
	//set up menus
	add_action('admin_menu', 'cil_plugin_menus');

}

//adds admin menus
function cil_plugin_menus()
{
	setupSideMenu();

	$page = add_options_page('cil - Custom Item Lists', 'cil', 'manage_options', 'cil_adminOptionsView.php', 'cil_plugin_optionMenu_options', "");
	//add hook to load external files used for the options menu - js/css
	 add_action('admin_print_styles-' . $page , 'cil_optionsMenu_externalFileLoad');
}

//show top level list edit page - pinned lists
function cil_list_options()
{
	if (!current_user_can('manage_options'))  {
		wp_die( __('You do not have sufficient permissions to access this page.') );
	}

	//show list edit view, url will determine which list gets shown
	do_action('show_cil_admin_list_options');
}

//show the options page
function cil_plugin_optionMenu_options()
{
	if (!current_user_can('manage_options'))  {
		wp_die( __('You do not have sufficient permissions to access this page.') );
	}
	//show admin options view, this view exists in cil_adminOptionsView.php
	do_action('show_cil_admin_options_menu');
}

//load external css, js here for the plugin options page
function cil_optionsMenu_externalFileLoad()
{

	//load javascript specific to this option menu.
	global $cilPluginURL;

	//load javascript
	wp_enqueue_script('media-upload');
	wp_enqueue_script('thickbox');
	wp_register_script('imageUpload', $cilPluginURL.'/js/imageUpload.js', array('jquery','media-upload','thickbox'));
	wp_enqueue_script('imageUpload');

	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/js/cil_optionMenu.js');

	//load styles
	wp_enqueue_style('cil_optionStyle', $cilPluginURL.'/css/cil_admin_optionsMenu.css');
	wp_enqueue_style('thickbox');
}

//load external css/js for top level pinned lists
function cil_admin_listOptions_externalFileLoad()
{
	//load javascript specific to this option menu.
	global $cilPluginURL;

	//load javascript
	wp_enqueue_script('media-upload');
	wp_enqueue_script('thickbox');
	wp_register_script('imageUpload', $cilPluginURL.'/js/imageUpload.js', array('jquery','media-upload','thickbox'));
	wp_enqueue_script('imageUpload');

	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/js/cil_listOptionMenu.js');

	//load styles
	wp_enqueue_style('cil_optionStyle', $cilPluginURL.'/css/cil_admin_listOptions.css');
	wp_enqueue_style('thickbox');
}

function setupSideMenu()
{
	global $cil_model;

	$pinned = $cil_model->get_pinned_lists();

	foreach($pinned as $list)
	{
		$page = add_menu_page('Custom Item Lists', $list->name, 'edit_pages', "cil_list-$list->id-$list->name.php", 'cil_list_options', $list->icon_url);
		//add hook to load external files used for the top level pinned list menu - js/css
		 add_action('admin_print_styles-' . $page , 'cil_admin_listOptions_externalFileLoad');
	}


}

?>