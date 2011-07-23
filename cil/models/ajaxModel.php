<?php

$cil_ajax_model = new cil_ajax_model($wpdb);

//register all the ajax methods into the wp system
add_action('wp_ajax_cil_pin_list', array($cil_ajax_model,'cil_pin_list'));
add_action('wp_ajax_cil_delete_list', array($cil_ajax_model,'cil_delete_list'));
add_action('wp_ajax_cil_edit_list', array($cil_ajax_model,'cil_edit_list'));
add_action('wp_ajax_cil_hide_list', array($cil_ajax_model,'cil_hide_list'));
add_action('wp_ajax_cil_delete_listItem', array($cil_ajax_model,'cil_delete_listItem'));
add_action('wp_ajax_cil_edit_item', array($cil_ajax_model,'cil_edit_item'));
add_action('wp_ajax_cil_get_items', array($cil_ajax_model,'cil_get_items'));
add_action('wp_ajax_cil_get_template', array($cil_ajax_model,'cil_get_template'));
add_action('wp_ajax_cil_edit_list_template', array($cil_ajax_model,'cil_edit_list_template'));
add_action('wp_ajax_cil_set_order_of_items', array($cil_ajax_model,'cil_set_order_of_items'));


class cil_ajax_model {

	private $_wpdb;

    public function __construct($wpdb)
    {
		$this->_wpdb = $wpdb;
    }

    /**
     *
     * Pin a list to the side menu
     */
	public function cil_pin_list()
	{
		global $wpdb;

		$tableName = $wpdb->prefix . "cil_listInfo";

		$sql = "UPDATE ". $tableName ." SET isPinned='". $_POST['isPinned'] ."' WHERE id = '". $_POST['id'] ."'";

	   	$wpdb->query($sql);

	   	$return = json_encode(array('id'=>$_POST['id'],'isPinned'=>$_POST['isPinned']));

	   	echo $return;

		die(); // this is required to return a proper result
	}


	/**
	 * delete a list with the specified id
	 */
	public function cil_delete_list()
	{
		global $wpdb;

		//delete list with specified id
		$tableName = $wpdb->prefix . "cil_listInfo";
		$sql = "DELETE FROM ". $tableName ." WHERE id='". $_POST['id'] ."'";

	   	$wpdb->query($sql);

	   	//delete the list items within specified list
	   	$tableName = $wpdb->prefix . "cil_listItemInfo";
	   	$sql = "DELETE FROM ". $tableName ." WHERE list_id='". $_POST['id'] ."'";

	   	$wpdb->query($sql);

	   	echo $_POST['id'];

		die(); // this is required to return a proper result
	}


	/**
	 *
	 * Edit a list, if an id was not given than create a new list
	 */
	public function cil_edit_list()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listInfo";

		$id = "";
		$newPost = false;

		//if an id was given as a post variable edit just that list
		if(!empty($_POST['id'] ))
		{
			$id = $_POST['id'];
			$sql = "UPDATE " . $table_name . " SET name='%s', time=NOW(), description='%s', logo_url='%s', icon_url='%s' WHERE id='". $id ."'";

			//security measures, stripping slashes and such with wp built in prepare method
			$wpdb->query($wpdb->prepare($sql,array($_POST['listName'], $_POST['listDesc'], $_POST['logoUrl'],$_POST['iconUrl'])));
		}else{//if there was no id create a new list
			$name = $_POST['listName'];
			$description = $_POST['listDesc'];
			$logo_url = $_POST['logoUrl'];
			$icon_url = $_POST['iconUrl'];

			$wpdb->insert($table_name, array('name' => $name,'time' => current_time('mysql'),'description' => $description,'logo_url' => $logo_url,'icon_url' => $icon_url ));
			$id = $wpdb->insert_id;
			$newPost = true;
		}

		$return = json_encode(array('id'=>$id,
									'listName'=>$_POST['listName'],
									'listDesc'=>$_POST['listDesc'],
									'logoUrl'=>$_POST['logoUrl'],
									'iconUrl'=>$_POST['iconUrl'],
									'newPost'=>$newPost));

		echo $return;
		die(); // this is required to return a proper result
	}

	//////////////////////////////////////////////////
	//////////////////List Items//////////////////////
	//////////////////////////////////////////////////


	/**
	 * toggle isHidden, which hides the item from view
	 */
	public function cil_hide_list()
	{
		global $wpdb;

		$tableName = $wpdb->prefix . "cil_listItemInfo";

		$sql = "UPDATE ". $tableName ." SET isHidden='". $_POST['isHidden'] ."' WHERE id = '". $_POST['id'] ."'";

		$wpdb->prepare($sql);
	   	$wpdb->query($sql);

	   	$return = json_encode(array('id'=>$_POST['id'],'isHidden'=>$_POST['isHidden']));

	   	echo $return;

		die(); // this is required to return a proper result
	}


	/**
	 *
	 * Delete a list item with the specified id
	 */
	public function cil_delete_listItem()
	{
		global $wpdb;

		//delete list item with specified id
		$tableName = $wpdb->prefix . "cil_listItemInfo";
		$sql = "DELETE FROM ". $tableName ." WHERE id='". $_POST['id'] ."'";

		$wpdb->prepare($sql);
	   	$wpdb->query($sql);

	   	echo $_POST['id'];

		die(); // this is required to return a proper result
	}


	/**
	 *
	 * Edit a list item, if an id is given than edit that list item, if there is no id create a new item
	 */
	public function cil_edit_item()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listItemInfo";

		$id = "";
		$newItem = false;

		//if there was an id, edit that particular post
		if(!empty($_POST['id'] ))
		{
			$id = $_POST['id'];
			$sql = "UPDATE $table_name
					SET
						heading='".$_POST['heading']."',
					    time=NOW(),
					    content='".htmlentities($_POST['content'])."',
					    image_url='".$_POST['imageUrl']."',
					    url='".$_POST['url']."',
					    list_id='".$_POST['listId']."'
					WHERE id='$id'";

			$wpdb->query($sql);
		}else{//if there was no id create a new items and return the new info for that item
			$heading = $_POST['heading'];
			$content = $_POST['content'];
			$image_url = $_POST['imageUrl'];
			$url = $_POST['url'];
			$list_id = $_POST['listId'];

			$sql="INSERT INTO wp_cil_listItemInfo  (heading, time, content, url, image_url, list_id, item_index)
				 	 SELECT '%s',NOW(),'%s', '%s', '%s', '%d',  COUNT(*)+1
				 	 FROM wp_cil_listItemInfo
				 	 	WHERE list_id='$list_id';";
			$wpdb->query($wpdb->prepare($sql,array($heading,$content,$url,$image_url,$list_id)));
			$id = $wpdb->insert_id;//get recently created id
			$newItem = true;
		}

		$return = json_encode(array('id'=>$id,
									'heading'=>$_POST['heading'],
									'content'=>stripslashes($_POST['content']),
									'imageUrl'=>$_POST['imageUrl'],
									'url'=>$_POST['url'],
									'listId'=>$_POST['listId'],
									'newItem'=>$newItem));

		echo $return;
		die(); // this is required to return a proper result
	}

	/**
	 *
	 * Get list items that match the POST var id where id is the id of the list
	 */
	public function cil_get_items()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listItemInfo";

		$sql = "SELECT * FROM $table_name WHERE list_id='". $_POST['id'] ."' ORDER BY item_index";

		$result = $wpdb->get_results($sql);

		echo json_encode($result);

		die();// this is required to return a proper result
	}

	/**
	 *
	 * Get the template for a list
	 */
	public function cil_get_template()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listInfo";

		$sql = "SELECT template FROM $table_name WHERE id='". $_POST['id'] ."'";

		$result = $wpdb->get_results($sql);

		$result[0]->template = stripcslashes(html_entity_decode($result[0]->template));

		echo json_encode($result[0]);

		die();
	}

	/**
	 *
	 * Edit the template for a specified list
	 */
	public function cil_edit_list_template()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listInfo";

		$sql = "UPDATE $table_name SET template='%s' WHERE id='%d'";

		$wpdb->query($wpdb->prepare($sql,array($_POST['template'],$_POST['id'])));

		echo $sql;
		die();
	}

	/**
	 * re-order items according to an array passed from jQuery sortable
	 */
	public function cil_set_order_of_items()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listItemInfo";
		$itemIds = split("%", $_POST['idArray']);

		for($i = 1; $i < count($itemIds); $i++)
		{
			echo ":".$itemIds[$i] ." ";
			$sql = "UPDATE $table_name
						SET
							item_index='$i'
						WHERE id='". $itemIds[$i] ."';";

			$wpdb->query($sql);//doesn't need to be prepared since it's drawing ids from html ids
		}

		die();
	}

}
