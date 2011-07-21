<?php

$cil_ajax_model = new cil_ajax_model($wpdb);

add_action('wp_ajax_cil_pin_list', array($cil_ajax_model,'cil_pin_list'));
add_action('wp_ajax_cil_delete_list', array($cil_ajax_model,'cil_delete_list'));
add_action('wp_ajax_cil_edit_list', array($cil_ajax_model,'cil_edit_list'));
add_action('wp_ajax_cil_hide_list', array($cil_ajax_model,'cil_hide_list'));
add_action('wp_ajax_cil_delete_listItem', array($cil_ajax_model,'cil_delete_listItem'));
add_action('wp_ajax_cil_edit_item', array($cil_ajax_model,'cil_edit_item'));
add_action('wp_ajax_cil_get_items', array($cil_ajax_model,'cil_get_items'));
//pin or unpin lists from the side menu
class cil_ajax_model {

	private $_wpdb;

    public function __construct($wpdb)
    {
		$this->_wpdb = $wpdb;
    }

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


	//delete a list
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


	//edit a list
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


	//hide or show a list item
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


	//delete a list item
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


	//edit a list item
	public function cil_edit_item()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listItemInfo";

		$id = "";
		$newItem = false;

		//if an id was given as a post variable return just that list
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
		}else{//if there was no id return all lists
			$heading = $_POST['heading'];
			$content = $_POST['content'];
			$image_url = $_POST['imageUrl'];
			$url = $_POST['url'];
			$list_id = $_POST['listId'];

			$wpdb->insert($table_name, array('heading' => $heading,'time' => current_time('mysql'),'content' => htmlentities($content),'image_url' => $image_url,'url' => $url, 'list_id' => $list_id ));
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

	//get list items for a specified list id
	public function cil_get_items()
	{
		global $wpdb;

		$table_name = $wpdb->prefix . "cil_listItemInfo";

		$sql = "SELECT * FROM $table_name WHERE list_id='". $_POST['id'] ."'";

		$result = $wpdb->get_results($sql,OBJECT_K);

		echo json_encode($result);

		die();// this is required to return a proper result
	}

	//TODO write ajax for setting the template, write model so that the short tag will output the template if != ''
}
