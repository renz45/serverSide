<?php
//adds help menu for the cil plugin
add_filter('contextual_help', 'cil_help', 10, 3);

//displays custom contextual help menus
function cil_help($contextual_help, $screen_id, $screen)
{
	$page = split('-',$_GET['page']);
	$page = $page[0];

	switch($page)
	{
		//if the current page is the cil options menu, display this help.
		case "cil_adminOptionsView.php":
			$contextual_help = 'This is options menu help for the plugin CIL';
			break;
		case "cil_list":
			$pageName = split('-',$_GET['page']);
			$pageName = split('.php',$pageName[2]);
			$pageName = $pageName[0];

			$contextual_help = "<p>This list can be displayed in a post or page by using the following short code:</p>
								<p>[cil name='$pageName']</p>
								<p>This is the basic tag that is required, there are optional attributes which can be used, they are:</p>
								<ul>
									<li>'name' name of the list you want to display - this attribute is required</li>
									<li> 'use_item_url' This defaults to 'true', setting this to false will force the item headings to never be links, even if a url is given</li>
									<li>'show_time' Shows the time that the item was created, this is set to 'false' by default</li>
									<li>'image_width' Force the images for each list item to be this width (this should be set if all images are one size, sets the height and width in the &lt;img&gt; tag)</li>
									<li>'image_height' Force the images for each list item to be this height (this should be set if all images are one size, sets the height and width in the &lt;img&gt; tag)</li>
									<li>'link_target' Setting this will determine how links open, accepts set to _blank by default: _blank(new window) _top(top frame) _parent(current frame) _self(current window)</li>
								</ul>";

			break;
	}

	return $contextual_help;
}
?>