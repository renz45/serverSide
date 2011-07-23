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
		$ret = '<div id="cil_edit_item_help"><p>This menu is used to manage your custom item lists. Lists can be pinned to the side menu to make them more visible and easy to edit for clients or yourself</p>
				<p>You have the ability to use templates to pre-format lists before they are output, this also allows the formating of the basic shortcode <code>[cil name="listName"]</code>
					which will make it easier for users to display a list in their page or post. The wrapper list tags are set by setting the type property on the <code>[cil_list]</code> shortcode,
					but all other html needs to be put inside the <code>[cil_list] [/cil_list]</code> shortcode</p>
				<p>The shortcodes for templating are:</p>
				<ul>
					<li>\'<code>[cil_list name="listName"] [/cil_list]</code>\' - This tag must surround the template and the <code>name</code> attribute is required, and optional <code>type</code> attribute can be used to set the list type - <code>ul, ol, dl</code></li>
					<li>\'<code>[cil_item_heading]</code>\' - Display the item heading</li>
					<li>\'<code>[cil_item_image_url]</code>\' - Display the item\'s image url</li>
					<li>\'<code>[cil_item_image]</code>\' - Display an <code>&lt;img /&gt;</code> tag with the src filled in with the item image url</li>
					<li>\'<code>[cil_item_content]</code>\' - Display the item content</li>
					<li>\'<code>[cil_item_time]</code>\' - Display the time that the item was created</li>
					<li>\'<code>[cil_item_url]</code>\' - Display the item URL, or if this tag is used to wrap and item like, <code>[cil_item_url]my link[cil_item_url]</code>, than the item is wrapped in an <code>&lt;a&gt;my link&lt;/a&gt;</code> html tag</li>

				</ul></div>';


		return $ret;
    }
}
?>