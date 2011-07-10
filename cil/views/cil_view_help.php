<?php
//adds help menu for the cil plugin
add_filter('contextual_help', 'cil_help', 10, 3);

//displays custom contextual help menus
function cil_help($contextual_help, $screen_id, $screen) 
{	
	switch($_GET['page'])
	{
		//if the current page is the cil options menu, display this help.
		case "cil_adminOptionsView.php":
			$contextual_help = 'This is options menu help for the plugin CIL';
		
			break;
		case "cil_adminListEditView.php":
			$contextual_help = "This is a list item help menu for the plugin CIL";
			break;
	}
	
	return $contextual_help;
}
?>