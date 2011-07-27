<?php

$cil_view_optionsMenu = new view_optionsMenu($cil_model);


add_action('show_cil_admin_options_menu', array($cil_view_optionsMenu,'show_options_menu'));

class view_optionsMenu {

	private $_model;

    public function __construct($model)
    {
		$this->_model = $model;
    }

    /**
     *
     * show the view for the options menu
     */
	public function show_options_menu()
	{

		$output = "";

		//$results = $this->_model->get_item_lists();
		$results = $this->_model->get_unested_item_lists();




		$output = "
			<div id='cil_wrap'>
				<h2><span>CIL - </span>Custom Item List | Manage Lists</h2>

					<p class='cil_list_label'>Current Item Lists:</p>
					<ul class='cil_admin_list'>\n" ;
		if(count($results) == 0)
		{
			//if there are 0 results
		}else{
			foreach ($results as $value)
			{
				$nestedResult = $this->_model->get_nested_lists_for($value->id);

				$output .= "<li id='cil-list_". $value->id ."'>
								<a class='cil_pin_btn cil_list_btn ". ($value->isPinned == 1 ? 'active' : "") ."' title='Pin this list to menu'>pin</a>
								<img class='cil_icon_url' src='". $value->icon_url ."' alt='". $value->name . "-" . $value->icon_url ."' title='". $value->icon_url ."' width='20' height='20' />
								<img class='cil_logo_url' src='". $value->logo_url ."' alt='". $value->name . "-" . $value->logo_url ."' title='". $value->logo_url ."' width='0' height='0' />
								<span class='cil_list_name'> - <span>" . $value->name . "</span> - </span>
								<p class='desc'>" . $value->description . "</p>
								<a class='cil_list_btn cil_list_edit_btn'>Edit</a>
								<a class='cil_list_btn cil_list_delete_btn'>Delete</a>

								<ul>\n";

										foreach($nestedResult as $nestValue)
										{
											$output .=	"<li id='cil-list_". $nestValue->id ."'>
															<span class='cil_up_arrow'>&uarr;</span>
															<a style='display:none' class='cil_pin_btn cil_list_btn ". ($nestValue->isPinned == 1 ? 'active' : "") ."' title='Pin this list to menu'>pin</a>
															<img class='cil_icon_url' src='". $nestValue->icon_url ."' alt='". $nestValue->name . "-" . $nestValue->icon_url ."' title='". $nestValue->icon_url ."' width='20' height='20' />
															<img class='cil_logo_url' src='". $nestValue->logo_url ."' alt='". $nestValue->name . "-" . $nestValue->logo_url ."' title='". $nestValue->logo_url ."' width='0' height='0' />
															<span class='cil_list_name'> - <span>" . $nestValue->name . "</span> - </span>
															<p class='desc'>" . $nestValue->description . "</p>
															<a class='cil_list_btn cil_list_edit_btn'>Edit</a>
															<a class='cil_list_btn cil_list_delete_btn'>Delete</a>
															<ul>
															</ul>
															<div class='cil_list_edit_area'>

															</div>
														</li>\n";
										}

				$output .= 	"</ul>
								<div class='cil_list_edit_area'>

								</div>
							</li>\n";
			}//end forach

		}//end if

		$output .=	"</ul>
					<div id='cil_edit_area'>
						<ul class='cil_list_option_button'>
							<li id='cil_create_new_list_header'>Create a new list</li>
							<li id='cil_edit_list_items'>Edit List Items</li>
							<li id='cil_edit_template'>Edit Template</li>
						</ul>
						<form id='cil_edit_List_form' action=''>
							<p>
								<label for='cil_listName'><span>List Name:</span> (Keep it short, this will be the menu item when pinned)</label><br/>
								<input type='text' name='cil_listName' id='cil_listName' /><span class='cil_error'></span>
							</p>

							<p>
								<label for='cil_listDescription'><span>List description:</span></label><br/>
								<textarea name='cil_listDescription' id='cil_listDescription' rows='200' cols='30'></textarea>
							</p>

							<p>
								<label for='cil_iconUrl'><span>Icon Url:</span> (This is the icon in the menu when the list is pinned, it will be resized to 20 x 20)</label><br/>
								<input type='text' name='cil_iconUrl' id='cil_iconUrl' /><img id='cil_preview_icon' src='' alt='Preview icon' title='Preview Icon' width='20' height='20' /><br/>
								<input id='upload_icon_button' type='button' value='Upload Icon Image' title='upload an image for this lists menu icon' />
							</p>

							<p>
								<label for='cil_iconUrl'><span>List Logo Url:</span>(optional, will show on the list edit page, it will be resized to 45x45) </label><br/>
								<input type='text' name='cil_logoUrl' id='cil_logoUrl' /><img id='cil_preview_logo' src='' alt='Preview logo' title='Preview Logo' width='45' height='45' /><br/>
								<input id='upload_logo_button' type='button' value='Upload Logo Image' title='upload an image for this lists logo'/>
							</p>
							<p><input type='submit' id='cil_newListSubmit' name='cil_newListSubmit' value='Create a New List' />
							<input id='cil_cancel_button' type='button' value='Cancel' title='cancel'/>
							<input class='cil_hidden_list_id' type='hidden' value='$value->id' /></p>
						</form>

						<form id='cil_edit_list_template' action=''>
							<p>
								<label for='cil_templateTextarea'>Template for: <span></span></label><br />
							 	<textarea name='cil_templateTextarea' id='cil_templateTextarea' rows='200' cols='100'></textarea>
							</p>
							<p>
								<input type='submit' id='cil_listTemplateSubmit' name='cil_listTemplateSubmit' value='Edit Template' />
								<input id='cil_cancelTemplate_button' type='button' value='Cancel' title='cancel'/>
							</p>
						</form>
					</div><!-- end cil_edit_area -->
				</div>
				<h3 id='cil_listItemsFor'>List items for: <span></span></h3>\n
		";

		// echo the output to work with the wordpress method do_action()
		echo $output;

		//display the view for editing list items for a given list
		do_action('show_cil_admin_list_options',true);

	}
}

