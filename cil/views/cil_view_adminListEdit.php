<?php

$cil_view_adminListEdit = new cil_view_adminListEdit($cilPluginURL,$cil_model);

add_action('show_cil_admin_list_options', array($cil_view_adminListEdit,'show_list_options'));
class cil_view_adminListEdit {

	private $_model;
	private $_pluginURL;


    public function __construct($pluginURL, $model)
    {
		$this->_model = $model;
		$this->_pluginURL = $pluginURL;
    }

    /**
     *
     * Show individual list items for a given list
     * @param boolean $skipQuery Skips the query and outputs the view empty of data. This is used on the options page where ajax does the content loading.
     */
	public function show_list_options($skipQuery=false)
	{

		//if skip query is false than go ahead and load the list info and list item info from the database
		if($skipQuery == false || $skipQuery == "" )
		{
			$pageArr = split('-',$_GET['page']);

			$id = $pageArr[1];

			$listData = $this->_model->get_item_lists($id);
			$listItems = $this->_model->get_list_items($id);

		}else{//if skip query is true, load an empty view (ajax loads the content instead)

			$listData = array('name'=>'','logo_url'=>'','description'=>'');
			$listData = (object)$listData;

			$listItems = array();
			$id = "";
		}

		//dynamic background image without using javascript
		$output = "<div id='cil_item_wrap'>

				<h2 id='cil_item_pageTitle' style='background: url(\"". $listData->logo_url ."\") left center no-repeat;'>". $listData->name ."</h2>
				<p id='cil_item_desc'>". $listData->description ."</p>\n";
		$output	.= "<ul class='cil_admin_list_items'>\n";
		if(count($listItems) > 0)
		{
			//max chars allowed in the heading portion of the list
			$maxChars = 12;
			foreach ($listItems as $value)
			{
				//browser is adding slashes into the content shortcodes, this strips those slashes out so shortcodes look and work correctly
				$value->content = stripslashes_deep($value->content);

				//shorten the heading so it fits in the list
				$choppedHeading = substr($value->heading,0, $maxChars);

				$output .= "<li id='cil-list_item_". $value->id ."'>
								<a class='cil_hide_btn cil_list_item_btn ". ($value->isHidden == 1 ? 'active' : "") ."' title='Hide this item'>hide</a>\n";

				//insert image icon if there is an image associated with this item
				if(!empty($value->image_url))
				{
					$output .= "<img class='cil_item_image' src='". $this->_pluginURL ."/assets/image.png' alt='". $value->image_url."' title='This item has an image' width='15' height='15' />\n";
				}

				//wrap the heading in an anchor tag if there is a url associated with this item
				if(!empty($value->url))
				{
					$output .= "<span class='cil_item_heading'> - <a class='cil_name_link' href='". $value->url ."' title='". $value->heading ."'><span title='". $value->heading ."'>" . $choppedHeading . "</span></a> - </span>\n";
				}else{
					$output .= "<span class='cil_item_heading'> - <span title='". $value->heading ."'>" . $choppedHeading . "</span> - </span>\n";
				}


				$output .=	"<p class='cil_item_content'>" . $value->content . "</p>
								<a class='cil_list_item_btn cil_item_edit_btn'>Edit</a>
								<a class='cil_list_item_btn cil_item_delete_btn'>Delete</a>
							</li>\n";
			}
			$output .=	"</ul>\n";

		}else{
			$output .=	"</ul>\n";
			$output .= "<h3 id='cil_no_items'>oops your list is empty, click the button below to start adding new items to your list</h3>\n";
		}
		$output .=	"<p id='create_new_item_header'>Create a new item</p>
				<form id='cil_edit_item_form' action=''>
					<p>
						<label for='cil_item_heading'><span>Item Heading:</span></label><br/>
						<input type='text' name='cil_item_heading' id='cil_item_heading' /><span class='cil_error'></span>
					</p>

					<p>
						<label for='cil_item_headingUrl'><span>Item URL:</span>(If a url is given, the heading will be a link to this url)</label><br/>
						<input type='text' name='cil_item_headingUrl' id='cil_item_headingUrl' /><span class='cil_error'></span>
					</p>

					<p>
						<label for='cil_item_content'><span>List content:</span></label><br/>
						<textarea name='cil_item_content' id='cil_item_content' rows='3' cols='100'></textarea>
					</p>

					<p>
						<img id='cil_item_imageIcon' src='$this->_pluginURL/assets/image.png' alt='image icon' title='This item has an image' width='15' height='15' />
						<label for='cil_item_imageUrl'><span>Image URL:</span>(This is the image attached to this item, it's optional)</label><br/>
						<input type='text' name='cil_item_imageUrl' id='cil_item_imageUrl' /><br/>
						<img id='cil_preview_item_image' src='' alt='preview image' title='preview image' /><br/>
						<input id='upload_item_image_button' type='button' value='Upload Image' title='upload an image for this lists menu icon' />
					</p>

					<p><input type='submit' id='cil_newItemSubmit' name='cil_newItemSubmit' value='Create a New Item' />
					<input id='cil_item_cancel_button' type='button' value='Cancel' title='cancel'/>
					<input class='cil_hidden_list_id' type='hidden' value='$id' />
					<input class='cil_hidden_list_item_id' type='hidden' value='' /></p>
				</form>
			</div>";

		echo $output;

	}
}