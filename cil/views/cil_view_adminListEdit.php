<?php
//show individual list options
add_action('show_cil_admin_list_options', 'show_list_options');
function show_list_options()
{
	global $cilPluginURL;

	$pageArr = split('cil_list_',$_GET['page']);
	$id = $pageArr[1];

	global $cil_model;

	$listData = $cil_model->get_item_lists($id);

	$listItems = $cil_model->get_list_items($id);

	//dynamic background image without using javascript
	$output = "<div id='cil_wrap'>

			<h2 id='cil_list_pageTitle' style='background: url(\"". $listData->logo_url ."\") left center no-repeat;'>". $listData->name ."</h2>
			<p id='cil_list_desc'>". $listData->description ."</p>\n";
	$output	.= "<ul class='cil_admin_list'>\n";
	if(count($listItems) > 0)
	{
		foreach ($listItems as $value)
		{
			$maxChars = 12;
			//shorten the heading so it fits in the list
			$choppedHeading = substr($value->heading,0, $maxChars);

			$output .= "<li id='cil-list_". $value->id ."'>
							<a class='cil_pin_btn cil_list_btn ". ($value->isHidden == 1 ? 'active' : "") ."' title='Hide this item'>hide</a>\n";

			//insert image icon if there is an image associated with this item
			if(!empty($value->image_url))
			{
				$output .= "<img class='cil_item_image' src='". $cilPluginURL ."/assets/image.png' alt='". $value->image_url."' title='This item has an image' width='15' height='15' />\n";
			}

			//wrap the heading in an anchor tag if there is a url associated with this item
			if(!empty($value->url))
			{
				$output .= "<span class='cil_list_name'> - <a class='cil_name_link' href='". $value->url ."' title='". $value->heading ."'><span title='". $value->heading ."'>" . $choppedHeading . "</span></a> - </span>\n";
			}else{
				$output .= "<span class='cil_list_name'> - <span title='". $value->heading ."'>" . $choppedHeading . "</span> - </span>\n";
			}


			$output .=	"<p class='desc'>" . $value->content . "</p>
							<a class='cil_list_btn cil_list_edit_btn'>Edit</a>
							<a class='cil_list_btn cil_list_delete_btn'>Delete</a>
						</li>\n";
		}
		$output .=	"</ul>\n";

	}else{
		$output .=	"</ul>\n";
		$output .= "<h3 id='cil_no_items'>oops your list is empty, click the button below to start adding new items to your list</h3>\n";
	}
	$output .=	"<p id='create_new_list_header'>Create a new item:</p>
			<form id='cil_edit_List_form' action=''>
				<p>
					<label for='cil_listName'><span>Item Heading:</span></label><br/>
					<input type='text' name='cil_listName' id='cil_listName' /><span class='cil_error'></span>
				</p>

				<p>
					<label for='cil_listNameUrl'><span>Item URL:</span>(If a url is given, the heading will be a link to this url)</label><br/>
					<input type='text' name='cil_listNameUrl' id='cil_listNameUrl' /><span class='cil_error'></span>
				</p>

				<p>
					<label for='cil_listDescription'><span>List content:</span></label><br/>
					<textarea name='cil_listDescription' id='cil_listDescription' rows='3' cols='100'></textarea>
				</p>

				<p>
					<img id='cil_item_imageIcon' src='http://localhost:8888/wordpress/wp-content/plugins/cil/assets/image.png' alt='http://localhost:8888/wordpress/wp-content/uploads/2011' title='This item has an image' width='15' height='15' />
					<label for='cil_imageUrl'><span>Image URL:</span>(This is the image attached to this item, it's optional)</label><br/>
					<input type='text' name='cil_imageUrl' id='cil_imageUrl' /><br/>
					<img id='cil_preview_image' src='' alt='preview image' title='preview image' /><br/>
					<input id='upload_image_button' type='button' value='Upload Image' title='upload an image for this lists menu icon' />
				</p>

				<p><input type='submit' id='cil_newListSubmit' name='cil_newListSubmit' value='Create a New Item' /><input id='cil_cancel_button' type='button' value='Cancel' title='cancel'/></p>
			</form>
		</div>";

	echo $output;
}