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
add_action('wp_ajax_cil_set_order_of_lists', array($cil_ajax_model,'cil_set_order_of_lists'));
add_action('wp_ajax_cil_set_nested_list_id', array($cil_ajax_model,'cil_set_nested_list_id'));


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
		$tableName = $this->_wpdb->prefix . "cil_listInfo";

		$sql = "UPDATE ". $tableName ."
					SET isPinned='". $_POST['isPinned'] ."'
					WHERE id = '". $_POST['id'] ."'";

	   	$this->_wpdb->query($sql);

	   	$return = json_encode(array('id'=>$_POST['id'],'isPinned'=>$_POST['isPinned']));

	   	echo $return;

		die(); // this is required to return a proper result
	}


	/**
	 * delete a list with the specified id
	 */
	public function cil_delete_list()
	{
		//delete the list items within specified list
	   	$itemTableName = $this->_wpdb->prefix . "cil_listItemInfo";
	   	$listTableName = $this->_wpdb->prefix . "cil_listInfo";

	   	//delete all list items within the primary list and all the nested lists
		$sql =   "DELETE lio.*
				  FROM $itemTableName AS lio
					JOIN $listTableName AS lo
						ON (lo.id = lio.list_id)
					WHERE
						lo.nestedIn_id = '". $_POST['id'] ."'
						OR
						lo.id = '". $_POST['id'] ."';";

		$this->_wpdb->query($sql);

		//delete list with specified id and any nested lists within it
		$sql = "DELETE FROM ". $listTableName ."
				WHERE
					id='". $_POST['id'] ."'
					OR
					nestedIn_id='". $_POST['id']."';";

	   	$this->_wpdb->query($sql);

	   	echo $_POST['id'];

		die(); // this is required to return a proper result
	}


	/**
	 *
	 * Edit a list, if an id was not given than create a new list
	 */
	public function cil_edit_list()
	{
		$table_name = $this->_wpdb->prefix . "cil_listInfo";

		$id = "";
		$newPost = false;

		//if an id was given as a post variable edit just that list
		if(!empty($_POST['id'] ))
		{
			$id = $_POST['id'];
			$sql = "UPDATE " . $table_name . "
						SET name='%s',
							time=NOW(),
							description='%s',
							logo_url='%s',
							icon_url='%s'
						WHERE id='". $id ."'";

			//security measures, stripping slashes and such with wp built in prepare method
			$this->_wpdb->query($this->_wpdb->prepare($sql,array($_POST['listName'], $_POST['listDesc'], $_POST['logoUrl'],$_POST['iconUrl'])));
		}else{//if there was no id create a new list
			$name = $_POST['listName'];
			$description = $_POST['listDesc'];
			$logo_url = $_POST['logoUrl'];
			$icon_url = $_POST['iconUrl'];

			//$this->_wpdb->insert($table_name, array('name' => $name,'time' => current_time('mysql'),'description' => $description,'logo_url' => $logo_url,'icon_url' => $icon_url ));

			$table_name = $this->_wpdb->prefix . "cil_listInfo";

			$sql="INSERT INTO $table_name (name, time, description, logo_url, icon_url,list_index)
				 	 SELECT '%s',NOW(),'%s', '%s', '%s',  COUNT(*)+1
				 	 FROM $table_name;";


			$this->_wpdb->query($this->_wpdb->prepare($sql,array($name,$description,$logo_url,$icon_url)));

			$id = $this->_wpdb->insert_id;
			$newPost = true;

			if($this->_wpdb->last_error)
			{
				return "false";
				die();
			}
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
	//					List Items					//
	//////////////////////////////////////////////////


	/**
	 * toggle isHidden, which hides the item from view
	 */
	public function cil_hide_list()
	{


		$tableName = $this->_wpdb->prefix . "cil_listItemInfo";

		$sql = "UPDATE ". $tableName ." SET isHidden='". $_POST['isHidden'] ."' WHERE id = '". $_POST['id'] ."'";

		$this->_wpdb->prepare($sql);
	   	$this->_wpdb->query($sql);

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


		//delete list item with specified id
		$tableName = $this->_wpdb->prefix . "cil_listItemInfo";
		$sql = "DELETE FROM ". $tableName ." WHERE id='". $_POST['id'] ."'";

		$this->_wpdb->prepare($sql);
	   	$this->_wpdb->query($sql);

	   	echo $_POST['id'];

		die(); // this is required to return a proper result
	}


	/**
	 *
	 * Edit a list item, if an id is given than edit that list item, if there is no id create a new item
	 */
	public function cil_edit_item()
	{


		$table_name = $this->_wpdb->prefix . "cil_listItemInfo";

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

			$this->_wpdb->query($sql);
		}else{//if there was no id create a new items and return the new info for that item
			$heading = $_POST['heading'];
			$content = $_POST['content'];
			$image_url = $_POST['imageUrl'];
			$url = $_POST['url'];
			$list_id = $_POST['listId'];

			$table_name = $this->_wpdb->prefix . "cil_listItemInfo";

			$sql="INSERT INTO $table_name  (heading, time, content, url, image_url, list_id, item_index)
				 	 SELECT '%s',NOW(),'%s', '%s', '%s', '%d',  COUNT(*)+1
				 	 FROM $table_name
				 	 	WHERE list_id='$list_id';";
			$this->_wpdb->query($this->_wpdb->prepare($sql,array($heading,$content,$url,$image_url,$list_id)));
			$id = $this->_wpdb->insert_id;//get recently created id
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


		$table_name = $this->_wpdb->prefix . "cil_listItemInfo";

		$sql = "SELECT * FROM $table_name WHERE list_id='". $_POST['id'] ."' ORDER BY item_index";

		$result = $this->_wpdb->get_results($sql);

		echo json_encode($result);

		die();// this is required to return a proper result
	}

	/**
	 *
	 * Get the template for a list
	 */
	public function cil_get_template()
	{


		$table_name = $this->_wpdb->prefix . "cil_listInfo";

		$sql = "SELECT template FROM $table_name WHERE id='". $_POST['id'] ."'";

		$result = $this->_wpdb->get_results($sql);

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


		$table_name = $this->_wpdb->prefix . "cil_listInfo";

		$sql = "UPDATE $table_name SET template='%s' WHERE id='%d'";

		$this->_wpdb->query($this->_wpdb->prepare($sql,array($_POST['template'],$_POST['id'])));

		echo $sql;
		die();
	}

	/**
	 * re-order items according to an array passed from jQuery sortable
	 */
	public function cil_set_order_of_items()
	{


		$table_name = $this->_wpdb->prefix . "cil_listItemInfo";
		$itemIds = split("%", $_POST['idArray']);

		for($i = 1; $i < count($itemIds); $i++)
		{
			$sql = "UPDATE $table_name
						SET
							item_index='$i'
						WHERE id='". $itemIds[$i] ."';";

			$this->_wpdb->query($sql);//doesn't need to be prepared since it's drawing ids from html ids
		}

		die();
	}

	/**
	 * re-order lists according to an array passed from jQuery sortable
	 */
	public function cil_set_order_of_lists()
	{


		$table_name = $this->_wpdb->prefix . "cil_listInfo";
		$itemIds = split("%", $_POST['idArray']);

		for($i = 1; $i < count($itemIds); $i++)
		{
			$sql = "UPDATE $table_name
						SET
							list_index='$i'
						WHERE id='". $itemIds[$i] ."';";

			$this->_wpdb->query($sql);//doesn't need to be prepared since it's drawing ids from html ids
		}

		die();
	}

	public function cil_set_nested_list_id()
	{
		$table_name = $this->_wpdb->prefix . "cil_listInfo";

		$id = $_POST['id'];
		$nestedId = $_POST['nestedId'];
		$index = $_POST['index'];

		$sql = "UPDATE $table_name
					SET
						nestedIn_id=". ($nestedId == "null"?"NULL":"'$nestedId'") .",
						list_index='$index'
					WHERE
						id='$id'";

		$this->_wpdb->query($sql);

		die();
	}

}
