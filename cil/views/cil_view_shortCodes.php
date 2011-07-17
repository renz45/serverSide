<?php
//TODO comment this file
//TODO write the help views that go with this on the config page

$cil_shortCode = new cil_shortcode($cil_model);

add_shortcode( "cil", array($cil_shortCode,"cil_shortcode_callback") );
add_shortcode( "cil_list", array($cil_shortCode,"cil_list_shortcode_callback") );
add_shortcode("cil_item_heading",array($cil_shortCode,"show_heading"));
add_shortcode("cil_item_image_url",array($cil_shortCode,"show_image_url"));
add_shortcode("cil_item_content",array($cil_shortCode,"show_content"));
add_shortcode("cil_item_time",array($cil_shortCode,"show_time"));
add_shortcode("cil_item_url",array($cil_shortCode,"show_url"));

class cil_shortcode {

	private $_model;
	private $_listItems = array();

    public function __construct($cil_model)
    {
		$this->_model = $cil_model;
    }


	//shortcode that generates a complete list that is pre formated
	/* [cil ] shortcode has attributes:
	 *
	 * name - list name (required)
	 * use_item_url - defaults to true - If this is set true, then if the item has a url, the heading is turned into a link
	 * show_time - defaults to false - Determines if the time the item was created is shown in the list
	 * image_width - forces the item's image to be a certain width, sets the width property on the <img /> tag
	 * image_height - forces the item's image to be a certain height, sets the height property on the <img /> tag
	 * link_target - target for the link, this is the same target attribute which is on an anchor tag <a></a>
	 *
	 *  */

	public function cil_shortcode_callback( $atts, $content=null ){


		// Set a blank return by default
		$ret = "";

		$a = shortcode_atts( array( 'name' => 'Please add a "name" attribute to the cil shortcode and specify which list you want to display',
									'use_item_url'=>'true',
									'show_time'=>'false',
									'image_width'=>'',
									'image_height'=>'',
									'link_target'=>'_blank'), $atts );

		$listItems = $this->_model->get_list_items_by_name($a['name']);

		$ret .= "<div id='cil_list_-". $a['name'] ."' class='cil_list_container'>\n";
		//logo or list image might go here
		$ret .= "<h2>" . $a['name'] . "</h2>\n";

		if(count($listItems) > 0)
		{
			$ret .= "<ul>\n";

			foreach ($listItems as $item)
			{
				if($item->isHidden == false)
				{
					$ret .= "\t<li>\n";

					if(!empty($item->image_url) )
					{
						if($a['use_item_url'] == 'true' && !empty($item->url) )
						{
							$ret .= "\t\t<a href='$item->url' title='$item->heading' target='". $a['link_target'] ."'><img src='$item->image_url' alt='$item->image_url' title='$item->heading' width='". $a['image_width'] ."' height='". $a['image_height'] ."' /></a>\n";
						}else{
							$ret .= "\t\t<img src='$item->image_url' alt='$item->image_url' title='$item->heading' width='". $a['image_width'] ."' height='". $a['image_height'] ."' />\n";
						}
					}

					$ret .= "\t\t<h3>";
					if($a['use_item_url'] == 'true' && !empty($item->url) )
					{
						$ret .= "<a href='$item->url' title='$item->heading' target='". $a['link_target'] ."'>$item->heading</a>";
					}else{
						$ret .= $item->heading;
					}
					$ret .= "</h3>\n";

					$ret .= "\t\t<p>$item->content</p>\n";

					if($a['show_time'] == true)
					{
						$ret .= "\t\t<span>". date( 'D m.d.Y - g:ia', strtotime($item->time) ) ."</span>\n";
					}

					$ret .= "\t</li>\n";
				}
			}

			$ret .= "</ul>\n";
		}

		$ret .= "</div>\n";

		return $ret;
	}

	public function cil_list_shortcode_callback( $atts, $content=null ){

		// Set a blank return by default
		$ret = "";

		$a = shortcode_atts( array( 'name' => 'Please add a "name" attribute to the cil shortcode and specify which list you want to display'),$atts);

		if(!key_exists($a['name'], $this->_listItems))
		{
			$listItems = $this->_model->get_list_items_by_name($a['name']);
			$this->_listItems[$a['name']] = $listItems;
		}

		$ret .= "<ul class='cil_list_-". $a['name'] ."'>";
		for($i = 0; $i < count($this->_listItems[$a['name']]); $i++)
		{
			$itemText = $this->parseCodes($content, $a['name'], $i);

			$ret .= do_shortcode($itemText);
		}
		$ret .= "</ul>";



		return $ret;
	}

	public function show_heading( $atts, $content=null )
	{

		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_heading short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->heading;
		}

	}

	public function show_image_url( $atts, $content=null )
	{

		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_image_url short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->image_url;
		}
	}

	public function show_content( $atts, $content=null )
	{

		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_content short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->content;
		}
	}

	public function show_time( $atts, $content=null )
	{

		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_time short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->time;
		}
	}

	public function show_url( $atts, $content=null )
	{

		$a = shortcode_atts( array( 'index' => null,'name' => null, 'target'=> '_blank'), $atts );

		if(!empty($content))
		{
			if(!empty($this->_listItems[$a['name']][$a['index']]->url) )
			{
				return "<a href='". $this->_listItems[$a['name']][$a['index']]->url ."' title='". $this->_listItems[$a['name']][$a['index']]->heading ."' target='". $a['target'] ."'>". do_shortcode($content) ."</a>";
			}else{
				return do_shortcode($content);
			}
		}

		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_url short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->url;
		}
	}

	private function parseCodes($string, $list_name, $index)
	{
		$searchFor = array("[cil_item_image_url]" => "[cil_item_image_url name='$list_name' index='$index']",
							"[cil_item_heading]"=>"[cil_item_heading name='$list_name' index='$index']",
							"[cil_item_content]"=>"[cil_item_content name='$list_name' index='$index']",
							"[cil_item_time]"=>"[cil_item_time name='$list_name' index='$index']",
							"[cil_item_url]"=>"[cil_item_url name='$list_name' index='$index']",
							"[cil_item_url target="=>"[cil_item_url name='$list_name' index='$index' target=");

		foreach($searchFor as $term=>$replace)
		{
			$string = str_replace($term , $replace,$string );
		}

		return $string;
	}

}
?>