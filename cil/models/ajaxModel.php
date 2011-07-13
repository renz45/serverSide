<?php

add_action('wp_ajax_cil_pin_list', 'cil_pin_list');
//pin or unpin lists from the side menu
function cil_pin_list() {
	global $wpdb;

	$tableName = $wpdb->prefix . "cil_listInfo";

	$sql = "UPDATE ". $tableName ." SET isPinned='". $_POST['isPinned'] ."' WHERE id = '". $_POST['id'] ."'";

	$wpdb->prepare($sql);
   	$wpdb->query($sql);

   	$return = json_encode(array('id'=>$_POST['id'],'isPinned'=>$_POST['isPinned']));

   	echo $return;

	die(); // this is required to return a proper result
}

add_action('wp_ajax_cil_delete_list', 'cil_delete_list');
//delete a list
function cil_delete_list() {
	global $wpdb;

	//delete list with specified id
	$tableName = $wpdb->prefix . "cil_listInfo";
	$sql = "DELETE FROM ". $tableName ." WHERE id='". $_POST['id'] ."'";

	$wpdb->prepare($sql);
   	$wpdb->query($sql);

   	//delete the list items within specified list
   	$tableName = $wpdb->prefix . "cil_listItemInfo";
   	$sql = "DELETE FROM ". $tableName ." WHERE list_id='". $_POST['id'] ."'";

   	$wpdb->prepare($sql);
   	$wpdb->query($sql);

   	echo $_POST['id'];

	die(); // this is required to return a proper result
}

add_action('wp_ajax_cil_edit_list', 'cil_edit_list');
//edit a list
function cil_edit_list() {
	global $wpdb;

	$table_name = $wpdb->prefix . "cil_listInfo";

	$id = "";
	$newPost = false;

	//if an id was given as a post variable return just that list
	if(!empty($_POST['id'] ))
	{
		$id = $_POST['id'];
		$sql = "UPDATE " . $table_name . " SET name='". $_POST['listName'] ."', time=NOW(), description='". $_POST['listDesc'] ."', logo_url='". $_POST['logoUrl'] ."', icon_url='". $_POST['iconUrl'] ."' WHERE id='". $id ."'";

		$wpdb->prepare($sql);//security measures, stripping slashes and such with wp built in prepare method
		$wpdb->query($sql);
	}else{//if there was no id return all lists
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

add_action('wp_ajax_cil_hide_list', 'cil_hide_list');
//hide or show a list item
function cil_hide_list() {
	global $wpdb;

	$tableName = $wpdb->prefix . "cil_listItemInfo";

	$sql = "UPDATE ". $tableName ." SET isHidden='". $_POST['isHidden'] ."' WHERE id = '". $_POST['id'] ."'";

	$wpdb->prepare($sql);
   	$wpdb->query($sql);

   	$return = json_encode(array('id'=>$_POST['id'],'isHidden'=>$_POST['isHidden']));

   	echo $return;

	die(); // this is required to return a proper result
}

add_action('wp_ajax_cil_delete_listItem', 'cil_delete_listItem');
//delete a list item
function cil_delete_listItem() {
	global $wpdb;

	//delete list item with specified id
	$tableName = $wpdb->prefix . "cil_listItemInfo";
	$sql = "DELETE FROM ". $tableName ." WHERE id='". $_POST['id'] ."'";

	$wpdb->prepare($sql);
   	$wpdb->query($sql);

   	echo $_POST['id'];

	die(); // this is required to return a proper result
}

add_action('wp_ajax_cil_edit_item', 'cil_edit_item');
//edit a list item
function cil_edit_item() {
	global $wpdb;

	$table_name = $wpdb->prefix . "cil_listItemInfo";

	$id = "";
	$newItem = false;

	//if an id was given as a post variable return just that list
	if(!empty($_POST['id'] ))
	{
		$id = $_POST['id'];
		$sql = "UPDATE " . $table_name . "
				SET
					heading='". $_POST['heading'] ."',
				    time=NOW(),
				    content='". $_POST['content'] ."',
				    image_url='". $_POST['imageUrl'] ."',
				    url='". $_POST['url'] ."',
				    list_id='". $_POST['listId'] ."'
				WHERE id='". $id ."'";

		$wpdb->prepare($sql);//security measures, stripping slashes and such with wp built in prepare method
		$wpdb->query($sql);
	}else{//if there was no id return all lists
		$heading = $_POST['heading'];
		$content = $_POST['content'];
		$image_url = $_POST['imageUrl'];
		$url = $_POST['url'];
		$list_id = $_POST['listId'];

		$wpdb->insert($table_name, array('heading' => $heading,'time' => current_time('mysql'),'content' => $content,'image_url' => $image_url,'url' => $url, 'list_id' => $list_id ));
		$id = $wpdb->insert_id;//get recently created id
		$newItem = true;
	}

	$return = json_encode(array('id'=>$id,
								'heading'=>$_POST['heading'],
								'content'=>$_POST['content'],
								'imageUrl'=>$_POST['imageUrl'],
								'url'=>$_POST['url'],
								'listId'=>$_POST['listId'],
								'newItem'=>$newItem));

	echo $return;
	die(); // this is required to return a proper result
}