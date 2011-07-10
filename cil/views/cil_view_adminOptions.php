<?php
add_action('show_admin_options_menu', 'show_options_menu');

function show_options_menu()
{
	$output = "";

	global $model;
	$results = $model->get_item_lists();

	$output = "
		<div id='cil_wrap'>
			<h2><span>CIL - </span>Custom Item List | Options</h2>

			<p class='cil_list_label'>Current Item Lists:</p>
			<ul class='cil_admin_list'>\n" ;

	foreach ($results as $value)
	{
		//cl_logo_url='". $value->logo_url ."'

		$output .= "<li id='cil-list_". $value->id ."'>
						<a class='cil_pin_btn cil_list_btn ". ($value->isPinned == 1 ? 'active' : "") ."' title='Pin this list to menu'>pin</a>
						<img class='cil_icon_url' src='". $value->icon_url ."' alt='". $value->name . "-" . $value->icon_url ."' title='". $value->icon_url ."' width='20' height='20' />
						<img class='cil_logo_url' src='". $value->logo_url ."' alt='". $value->name . "-" . $value->logo_url ."' title='". $value->logo_url ."' width='0' height='0' />
						<span class='cil_list_name'> - <span>" . $value->name . "</span> - </span>
						<p class='desc'>" . $value->description . "</p>
						<a class='cil_list_btn cil_list_edit_btn'>Edit</a>
						<a class='cil_list_btn cil_list_delete_btn'>Delete</a>
					</li>\n";
	}
	$output .=	"</ul>

			<p id='create_new_list_header'>Create a new item list:</p>
			<form id='cil_edit_List_form' action=''>
				<p>
					<label for='cil_listName'><span>List Name:</span> (Keep it short, this will be the menu item when pinned)</label><br/>
					<input type='text' name='cil_listName' id='cil_listName' />
				</p>

				<p>
					<label for='cil_listDescription'><span>List description:</span></label><br/>
					<input type='text' name='cil_listDescription' id='cil_listDescription' />
				</p>

				<p>
					<label for='cil_iconUrl'><span>Icon Url:</span> (This is the icon in the menu when the list is pinned, it will be resized to 20 x 20)</label><br/>
					<input type='text' name='cil_iconUrl' id='cil_iconUrl' /><br/>
					<input id='upload_icon_button' type='button' value='Upload Icon Image' title='upload an image for this lists menu icon' />
				</p>

				<p>
					<label for='cil_iconUrl'><span>List Logo Url:</span> (If set this picture will show up in the side bar edit menu next to the list name)</label><br/>
					<input type='text' name='cil_logoUrl' id='cil_logoUrl' /><br/>
					<input id='upload_logo_button' type='button' value='Upload Logo Image' title='upload an image for this lists logo'/>
				</p>
				<p><input type='submit' id='cil_newListSubmit' name='cil_newListSubmit' value='Create a New List' /><input id='cil_cancel_button' type='button' value='Cancel' title='cancel'/></p>
			</form>
		</div>
	";

	// echo the output to work with the wordpress method do_action()
	echo $output;

	//return this output so it can be used to update the menu when a new list is added
	return $output;
}


