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
//delete a list
function cil_edit_list() {
	global $wpdb;

	$table_name = $wpdb->prefix . "cil_listInfo";

	$id = "";
	$newPost = false;

	if(!empty($_POST['id'] ))
	{
		$id = $_POST['id'];
		$sql = "UPDATE " . $table_name . " SET name='". $_POST['listName'] ."', time=NOW(), description='". $_POST['listDesc'] ."', logo_url='". $_POST['logoUrl'] ."', icon_url='". $_POST['iconUrl'] ."' WHERE id='". $id ."'";

		$wpdb->prepare($sql);
		$wpdb->query($sql);
	}else{
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