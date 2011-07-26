<?php

/*
cil_listInfo:
---------------------
	id
	time
	name
	description
	isPinned (id of list to be pinned under. 0 indicates a new main menu item)
	logo_url
	icon_url
	template

cil_listItemInfo:
---------------------
	id
	time
	heading
	content
	url
	image_url
	list_id
	isHidden
	index
*/

global $cil_db_version;
$cil_db_version = "1.0";

add_action('plugins_loaded', 'myplugin_update_db_check');

function cil_install () {
   global $wpdb;

   $table_name = $wpdb->prefix . "cil_listInfo";

	$sql = "CREATE TABLE " . $table_name . " (
		  id mediumint(9) NOT NULL AUTO_INCREMENT,
		  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
		  name VARCHAR(128) DEFAULT '' NOT NULL,
		  description text DEFAULT '' NOT NULL,
		  logo_url VARCHAR(256) DEFAULT '' NOT NULL,
		  icon_url VARCHAR(256) DEFAULT '' NOT NULL,
		  isPinned tinyint(1) DEFAULT '0' NOT NULL,
		  template text DEFAULT '' NOT NULL,
		  list_index mediumint(9) NOT NULL,
		  nestedIn_id mediumint(9) DEFAULT NULL,
		  UNIQUE KEY id (id),
		  UNIQUE KEY name (name)
		);";

	require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
	dbDelta($sql);


	$table_name = $wpdb->prefix . "cil_listItemInfo";

		$sql = "CREATE TABLE " . $table_name . " (
			  id mediumint(9) NOT NULL AUTO_INCREMENT,
			  heading VARCHAR(200) DEFAULT '' NOT NULL,
			  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
			  content text DEFAULT '' NOT NULL,
			  url VARCHAR(256) DEFAULT '' NOT NULL,
			  image_url VARCHAR(256) DEFAULT '' NOT NULL,
			  list_id int(55) DEFAULT 0 NOT NULL,
			  isHidden tinyint(1) DEFAULT '0' NOT NULL,
			  item_index mediumint(9) NOT NULL,
			  UNIQUE KEY id (id)
			);";

	dbDelta($sql);

	//global $cil_db_version;
	//add_option("cil_db_version", $cil_db_version);
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
/*
$table_name = $wpdb->prefix . "cil_listInfo";

	$sql = "CREATE TABLE " . $table_name . " (
		  id mediumint(9) NOT NULL AUTO_INCREMENT,
		  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
		  title VARCHAR(128) NOT NULL,
		  description text NOT NULL,
		  url VARCHAR(55) DEFAULT '' NOT NULL,
		  icon_url VARCHAR(55) DEFAULT '' NOT NULL,
		  pin_id int(55) DEFAULT 0 NOT NULL,
		  UNIQUE KEY id (id)
		);";*/

function myplugin_update_db_check() {
    global $cil_db_version;
    if (get_site_option('cil_db_version') != $cil_db_version) {
        cil_install();
    }
}


?>