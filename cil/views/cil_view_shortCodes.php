<?php
//TODO write the help views that go with this on the config page

$cil_shortCode = new cil_shortcode($cil_model);

add_shortcode( "cil", array($cil_shortCode,"cil_shortcode_callback") );
add_shortcode( "cil_list", array($cil_shortCode,"cil_list_shortcode_callback") );
add_shortcode("cil_item_heading",array($cil_shortCode,"show_heading"));
add_shortcode("cil_item_image_url",array($cil_shortCode,"show_image_url"));
add_shortcode("cil_item_image",array($cil_shortCode,"show_image"));
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

		//set shortcode attribute defaults
		$a = shortcode_atts( array( 'name' => 'Please add a "name" attribute to the cil shortcode and specify which list you want to display',
									'use_item_url'=>'true',
									'show_time'=>'false',
									'image_width'=>'',
									'image_height'=>'',
									'link_target'=>'_blank'), $atts );

		//use the model to get a list of items according to a list name
		$listItems = $this->_model->get_list_items_by_name($a['name']);

		//build container div and add a custom id to the list container for styling purposes
		$ret .= "<div id='cil_list_-". $a['name'] ."' class='cil_list_container'>\n";
		//logo or list image might go here
		$ret .= "<h2>" . $a['name'] . "</h2>\n";

		//if there are more than 0 list items go ahead and create the unordered list
		if(count($listItems) > 0)
		{
			$ret .= "<ul>\n";

			//loop through the list items and create html <li></li>
			foreach ($listItems as $item)
			{
				$item->content = html_entity_decode($item->content);

				if($item->isHidden == false)
				{
					$ret .= "\t<li>\n";

					//if there is an image url, insert an html <img />
					if(!empty($item->image_url) )
					{
						//if there is a url wrap the image in an anchor tag
						if($a['use_item_url'] == 'true' && !empty($item->url) )
						{
							$ret .= "\t\t<a href='$item->url' title='$item->heading' target='". $a['link_target'] ."'><img src='$item->image_url' alt='$item->image_url' title='$item->heading' width='". $a['image_width'] ."' height='". $a['image_height'] ."' /></a>\n";
						}else{
							$ret .= "\t\t<img src='$item->image_url' alt='$item->image_url' title='$item->heading' width='". $a['image_width'] ."' height='". $a['image_height'] ."' />\n";
						}
					}

					$ret .= "\t\t<h3>";
					//if there is an item url and the attribute use_item_url is set to true, wrap the heading in an anchor tag
					if($a['use_item_url'] == 'true' && !empty($item->url) )
					{
						$ret .= "<a href='$item->url' title='$item->heading' target='". $a['link_target'] ."'>$item->heading</a>";
					}else{
						$ret .= $item->heading;
					}
					$ret .= "</h3>\n";

					//output content in a <p>
					$ret .= "\t\t<p>". do_shortcode($item->content) ."</p>\n";

					//if the show_time attribute is true, than output time in a <span></span>
					if($a['show_time'] == "true")
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

	/**
	 *
	 * callback for the cil_list shortCode, this is for creating a custom layout for list items of the given list specified in the name attribute
	 *
	 * @param array $atts
	 * @param string $content
	 */
	public function cil_list_shortcode_callback( $atts, $content=null ){

		// Set a blank return by default
		$ret = "";

		$content = $this->trimLineBreaks($content);
		$content = stripslashes( html_entity_decode($content) );
		//set attribute defaults
		$a = shortcode_atts( array( 'name' => 'Please add a "name" attribute to the cil shortcode and specify which list you want to display',
									'type'=>'ul',
									'class'=>'',
									'id'=>''),$atts);

		//if the name doesn't exists within $this->_listItems, then query the database and get the information and insert it into the array
		if(!key_exists($a['name'], $this->_listItems))
		{
			$listItems = $this->_model->get_list_items_by_name($a['name']);
			$this->_listItems[$a['name']] = $listItems;
		}
		//create the <ul> with a custom class name
		$ret .= "<". $a['type'] ." class='cil_list-". $a['name'] ." ". $a['class'] ."' id='". $a['id'] ."'>";

		//loop through the list items, change the name and index attributes on any short tags to math the correct index
		for($i = 0; $i < count($this->_listItems[$a['name']]); $i++)
		{
			//add a name and index to each short tag
			$itemText = $this->parseCodes($content, $a['name'], $i);

			//parse short tags to get desired output
			$ret .= do_shortcode($itemText);
		}
		$ret .= "</".$a['type'].">";

		return $ret;
	}

	/**
	 *
	 * callback for the  cil_item_heading shortCode
	 * @param array $atts
	 * @param string $content
	 */
	public function show_heading( $atts, $content=null )
	{
		//set attribute defaults
		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		//if either name or index is null, than output error message
		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_heading short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->heading;
		}
	}

	/**
	 *
	 * callback for the cil_item_image_url shortCode
	 * @param array $atts
	 * @param string $content
	 */
	public function show_image_url( $atts, $content=null )
	{
		//set attribute defaults
		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		//if either name or index is null, than output error message
		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_image_url short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->image_url;
		}
	}

	/**
	 *
	 * callback for the cil_item_image shortCode
	 * @param array $atts
	 * @param string $content
	 */
	public function show_image( $atts, $content=null )
	{
		//set attribute defaults
		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		//if either name or index is null, than output error message
		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_image_url short code";
		}else{
			return "<img src='". $this->_listItems[$a['name']][$a['index']]->image_url ."' alt='". $this->_listItems[$a['name']][$a['index']]->image_url ."' title='". $this->_listItems[$a['name']][$a['index']]->heading ."'/>";
		}
	}

	/**
	 *
	 * callback for the cil_item_content shortCode
	 * @param array $atts
	 * @param string $content
	 */
	public function show_content( $atts, $content=null )
	{
		//set attribute defaults
		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		//if either name or index is null, than output error message
		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_content short code";
		}else{
			return do_shortcode($this->_listItems[$a['name']][$a['index']]->content);
		}
	}

	/**
	 *
	 * callback for the cil_item_time shortCode
	 * @param array $atts
	 * @param string $content
	 */
	public function show_time( $atts, $content=null )
	{
		//set attribute defaults
		$a = shortcode_atts( array( 'index' => null,'name' => null), $atts );

		//if either name or index is null, than output error message
		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_time short code";
		}else{
			return $this->_listItems[$a['name']][$a['index']]->time;
		}
	}

	/**
	 *
	 * callback for the cil_item_url shortCode
	 * @param array $atts
	 * @param string $content
	 */
	public function show_url( $atts, $content=null )
	{
		//set attribute defaults
		$a = shortcode_atts( array( 'index' => null,'name' => null, 'target'=> '_blank'), $atts );

		//if either name or index is null, than output error message
		if(is_null($a['name']) || is_null($a['index']))
		{
			return "There was a problem with the cil_item_url short code";
		}else{

			//if there is content than wrap the contant in an anchor tag
			if(!empty($content))
			{
				//if the url  is empty, just display the content
				if(!empty($this->_listItems[$a['name']][$a['index']]->url) )
				{
					return "<a href='". $this->_listItems[$a['name']][$a['index']]->url ."' title='". $this->_listItems[$a['name']][$a['index']]->heading ."' target='". $a['target'] ."'>". do_shortcode($content) ."</a>";
				}else{
					return do_shortcode($content);
				}
			}
			//if there is no content just output the url
			return $this->_listItems[$a['name']][$a['index']]->url;
		}

	}

	/**
	 *
	 * This parses shortcodes in a string and adds the given list name and item list index to each short code
	 * @param string $string
	 * @param string $list_name
	 * @param int $index
	 */
	private function parseCodes($string, $list_name, $index)
	{
		//array of shortcodes to search for and what to replace them with
		$searchFor = array("[cil_item_image_url]" => "[cil_item_image_url name='$list_name' index='$index']",
							"[cil_item_image]" => "[cil_item_image name='$list_name' index='$index']",
							"[cil_item_heading]"=>"[cil_item_heading name='$list_name' index='$index']",
							"[cil_item_content]"=>"[cil_item_content name='$list_name' index='$index']",
							"[cil_item_time]"=>"[cil_item_time name='$list_name' index='$index']",
							"[cil_item_url]"=>"[cil_item_url name='$list_name' index='$index']",
							"[cil_item_url target="=>"[cil_item_url name='$list_name' index='$index' target=");

		//replace the found strings
		foreach($searchFor as $term=>$replace)
		{
			$string = str_replace($term , $replace,$string );
		}

		return $string;
	}

	/**
	 *
	 * Trim function that trims out all the extra <p></p> tags that the wordpress html editor inserts into your shortcode
	 * @param String $string
	 */
	private function trimLineBreaks($string)
	{

		//cut out the </p> at the beginning and the <p> at the end if the </p> exists in the beginning
		if(substr($string, 0, 4) == '</p>')
		{
			$string = substr($string, 4, strlen($string) - 7);
		}

		//cut out all the <p></p> (empty paragraph tags)
		$string = join("",split('<p></p>', $string));

		return $string;

	}

}
?>