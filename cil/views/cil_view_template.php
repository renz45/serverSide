<?php
/**
 *
 * echos a list with the specified name
 * @param String $name name of the list to display. This display will adhere to the list template set in the admin panel
 */
function get_cil_list($name)
{
	echo do_shortcode("[cil name='$name']");
}

/**
 *
 * echos a list based on the template specified by the template shortcodes
 * @param String $template
 */
function get_list_by_template($template)
{
	echo do_shortcode($template);
}