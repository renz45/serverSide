<?php
add_action('show_admin_options_menu', 'show_options_menu');
//add hook to load external files used for the options menu - js/css	
//add_action('cil_load_optionsMenuScripts', 'cil_optionsMenu_externalFileLoad');


function show_options_menu()
{
	
	
	echo "
		<div id='cil_wrap'>
			<h2>CIL - Custom Item List Options</h2>
			
			<p>Current Item Lists:</p>
			<ul class='cil_admin_list'>
				<li><a class='cil_pin_btn cil_list_btn' title='Pin this list to menu'>pin</a> - <span class='cil_list_name'>Products</span> - <p class='desc'>This is description number 1 for products</p><a class='cil_list_btn cil_list_edit_btn'>Edit</a><a class='cil_list_btn cil_list_delete_btn'>Delete</a></li>
				
				<li><a class='cil_pin_btn cil_list_btn' title='Pin this list to menu'>pin</a> - <span class='cil_list_name'>Services</span> - <p class='desc'>This is description number 2 for Services</p><a class='cil_list_btn cil_list_edit_btn'>Edit</a><a class='cil_list_btn cil_list_delete_btn'>Delete</a></li>
				
				<li><a class='cil_pin_btn cil_list_btn' title='Pin this list to menu'>pin</a> - <span class='cil_list_name'>People</span> - <p class='desc'>This is description number 3 for people</p><a class='cil_list_btn cil_list_edit_btn'>Edit</a><a class='cil_list_btn cil_list_delete_btn'>Delete</a></li>
				
				<li><a class='cil_pin_btn cil_list_btn' title='Pin this list to menu'>pin</a> - <span class='cil_list_name'>Locations</span> - <p class='desc'>This is description number 3 for locations</p><a class='cil_list_btn cil_list_edit_btn'>Edit</a><a class='cil_list_btn cil_list_delete_btn'>Delete</a></li>
			</ul>
			<p>Create a new item list:</p>
			<form>
				<p>
					<label for='cil_listName'>List Name: (Keep it short, this will be the menu item when pinned)</label><br/>
					<input type=text name='cil_listName' id='cil_listName' />
				</p>
				
				<p>	
					<label for='cil_iconUrl'>Icon Url: (This is the icon in the menu when the list is pinned, keep it at 20 x 20)</label><br/>
					<input type=text name='cil_iconUrl' id='cil_iconUrl' />
				</p>
				
				<p>	
					<label for='cil_listDescription'>List description:</label><br/>
					<input type=text name='cil_listDescription' id='cil_listDescription' />
				</p>
				<p><input type=submit name='cil_newListSubmit' value='Create'></p>
			</form>
		</div>
	";
	
	//do_action('cil_load_optionsMenuScripts');
}

//load external css, js here for the plugin options page
/*function cil_optionsMenu_externalFileLoad(){

	//load javascript specific to this option menu.
	global $cilPluginURL;
	
	print_r($cilPluginURL );
	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/js/cil_optionMenu.js');
	wp_enqueue_script('cil_optionScript', $cilPluginURL.'/css/cil_admin_optionsMenu.css');
}*/

