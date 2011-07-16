<?php

// add the shortcodes to the system
add_shortcode( "cil", "list_shortcode_callback" );
function list_shortcode_callback( $atts, $content=null ){

	$test = new test();

	$sampleLists = array('products' => array('meds ','pills',true), 'services' => array('backrubs',2.444,2),$test);

	// Set a blank return by default
	$ret = "";

	$a = shortcode_atts( array('name' => 'List Name', 'element' => 'default'), $atts );


	print_r($sampleLists);
	php_dump($test);
	php_dump($sampleLists);

	$ret .= "<ul>";

	$arr = $sampleLists[$a['name']];

	foreach($arr as  $item)
	{
		$ret .= "<li><img width=100 height=100 src='' alt='' /><h2>" . $item . "</h2><p> list body text goes here </p></li>";
	}

	$ret .= "</ul>";

	return $ret;
}

class test {

	public $bam = " helo";
	public $bool = true;
	public $num = 1.213123;
	public $iinntt = 5;
	public $arr = array(123,123,'asd','item'=>'i\'m an item!');

    public function __construct()
    {

    }

}

?>