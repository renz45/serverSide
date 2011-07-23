<?php
//adds help menu for the cil plugin

//instantiate help view class
$helpView = new cil_view_contextualHelp();
add_filter('contextual_help', array($helpView,'cil_help'), 10, 3);

//displays custom contextual help menus


/**
 *
 * Class that contains views used to output various help menus
 * @author adamrensel
 *
 */
class cil_view_contextualHelp {

    public function __construct()
    {

    }

    public function cil_help($contextual_help, $screen_id, $screen)
	{
		$page = split('-',$_GET['page']);
		$page = $page[0];

		switch($page)
		{
			//if the current page is the cil options menu, display this help.
			case "cil_adminOptionsView.php":
				$contextual_help = $this->show_optionsHelp();
				break;
			case "cil_list":
				$contextual_help = $this->show_editListHelp();
				break;
		}
		return $contextual_help;
	}

    public function show_editListHelp()
    {
		$pageName = split('-',$_GET['page']);
		$pageName = split('.php',$pageName[2]);
		$pageName = $pageName[0];

		$ret = "<div id='cil_edit_item_help'>
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
					<p>Items can be re-organized by dragging and dropping</p>
				</div>";
		return $ret;
    }

    public function show_optionsHelp()
    {
		$ret = 'This is options menu help for the plugin CIL';

		return $ret;
    }
}
?>