<?php

/*

cil_listNames:
---------------------
	id
	listName

cil_listInfo:
---------------------
	id
	time
	title
	description
	pin_id (id of list to be pinned under. 0 indicates a new main menu item)
	url
	icon_url
	list_id
	
cil_listInfo:
---------------------
	id
	time
	description
	url
	image_url
	list_id
*/

global $cil_db_version;
$cil_db_version = "1.0";

register_activation_hook(__FILE__,'cil_install');

function cil_install () {
   global $wpdb;

   $table_name = $wpdb->prefix . "cil_listInfo"; 

	$sql = "CREATE TABLE " . $table_name . " (
		  id mediumint(9) NOT NULL AUTO_INCREMENT,
		  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
		  title VARCHAR(128) NOT NULL,
		  description text NOT NULL,
		  url VARCHAR(55) DEFAULT '' NOT NULL,
		  icon_url VARCHAR(55) DEFAULT '' NOT NULL,
		  list_id int(55) DEFAULT 0 NOT NULL,
		  pin_id int(55) DEFAULT 0 NOT NULL,
		  UNIQUE KEY id (id)
		);";
	
	require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
	dbDelta($sql);
	
	 $table_name = $wpdb->prefix . "cil_listNames"; 
	
		$sql = "CREATE TABLE " . $table_name . " (
			  id mediumint(9) NOT NULL AUTO_INCREMENT,
			  listName VARCHAR(55) NOT NULL,
			  UNIQUE KEY id (id)
			);";
		
	dbDelta($sql);
	
	$table_name = $wpdb->prefix . "cil_listItemInfo"; 
	
		$sql = "CREATE TABLE " . $table_name . " (
			  id mediumint(9) NOT NULL AUTO_INCREMENT,
			  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
			  description text NOT NULL,
			  url VARCHAR(55) DEFAULT '' NOT NULL,
			  image_url VARCHAR(55) DEFAULT '' NOT NULL,
			  list_id int(55) DEFAULT 0 NOT NULL,
			  UNIQUE KEY id (id)
			);";

	add_option("cil_db_version", $cil_db_version);
	
	/* // update database on version change example code
	$installed_ver = get_option( "cil_db_version" );
	
	   if( $installed_ver != $cil_db_version ) {
	
	      $sql = "CREATE TABLE " . $table_name . " (
		  id mediumint(9) NOT NULL AUTO_INCREMENT,
		  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
		  name tinytext NOT NULL,
		  text text NOT NULL,
		  url VARCHAR(100) DEFAULT '' NOT NULL,
		  UNIQUE KEY id (id)
		);";
	
	      require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
	      dbDelta($sql);
	
	      update_option( "jal_db_version", $jal_db_version );
	  }
	  */
}

function cil_install_data() {
   global $wpdb;
   
   $listName = "default";
   $table_name = $wpdb->prefix . "cil_listNames";
   
   $rows_affected = $wpdb->insert( $table_name, array('listName' => $listName ) );
   
   
   $title = "Sample List";
   $details = "Sample details paragraph";
   $list_id = 1;
   $table_name = $wpdb->prefix . "cil_listInfo";

   $rows_affected = $wpdb->insert( $table_name, array( 'time' => current_time('mysql'), 'title' => $title, 'description' => $details, 'list_id' => $list_id ) );
}

function myplugin_update_db_check() {
    global $cil_db_version;
    if (get_site_option('cil_db_version') != $cil_db_version) {
        cil_install();
    }
}
add_action('plugins_loaded', 'myplugin_update_db_check');

?>