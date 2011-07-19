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

			$contextual_help = "<div id='cil_edit_item_help'>
									<p>This list can be displayed in a post or page copying and pasting following short code into the text area: <code>[cil name=\"$pageName\"]</code></p>

									<p>The tag above is the basic tag that is required, there are optional attributes which can be used, which are:</p>
									<ul>
										<li>'<code>name=\"$pageName\"</code>' - name of the list you want to display - this attribute is required</li>
										<li> '<code>use_item_url=\"true\"</code>' - This defaults to 'true', setting this to false will force the item headings to never be links, even if a url is given</li>
										<li>'<code>show_time=\"false\"</code>' - Shows the time that the item was created, this is set to 'false' by default</li>
										<li>'<code>image_width=\" \"</code>' - Force the images for each list item to be this width (this should be set if all images are one size, sets the height and width in the &lt;img&gt; tag)</li>
										<li>'<code>image_height=\" \"</code>' - Force the images for each list item to be this height (this should be set if all images are one size, sets the height and width in the &lt;img&gt; tag)</li>
										<li>'<code>link_target=\"_blank\"</code>' - Setting this will determine how links open, accepts set to _blank by default: _blank(new window) _top(top frame) _parent(current frame) _self(current window)</li>
									</ul>
								</div>";

			break;
	}

	return $contextual_help;
}
?>