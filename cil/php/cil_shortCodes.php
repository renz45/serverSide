<?php

function list_shortcode_callback( $atts, $content=null ){

	$sampleLists = array('products' => array('meds','pills','shoes'), 'services' => array('backrubs','soak','message'));
	
	// Set a blank return by default
	$ret = "";

	$a = shortcode_atts( array('name' => 'List Name', 'style' => 'default.css'), $atts );

	$ret .= "<ul>";
	
	$arr = $sampleLists[$a['name']];

	foreach($arr as  $item)
	{
		$ret .= "<li><img width=100 height=100 src='' alt='' /><h2>" . $item . "</h2><p> list body text goes here </p></li>";
	}
	
	$ret .= "</ul>";
	
	return $ret;
}


// Finally, add the shortcodes to the system
// So WordPress knows about them
add_shortcode( "list", "list_shortcode_callback" );
?>