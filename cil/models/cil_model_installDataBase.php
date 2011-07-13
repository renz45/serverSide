<?php

/*
cil_listInfo:
---------------------
	id
	time
	title
	description
	pin_id (id of list to be pinned under. 0 indicates a new main menu item)
	logo_url
	icon_url

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

add_action('plugins_loaded', 'myplugin_update_db_check');

function cil_install () {
   global $wpdb;

   $table_name = $wpdb->prefix . "cil_listInfo";

	$sql = "CREATE TABLE " . $table_name . " (
		  id mediumint(9) NOT NULL AUTO_INCREMENT,
		  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
		  name VARCHAR(128) NOT NULL,
		  description text NOT NULL,
		  logo_url VARCHAR(256) DEFAULT '' NOT NULL,
		  icon_url VARCHAR(256) DEFAULT '' NOT NULL,
		  isPinned tinyint(1) DEFAULT '0' NOT NULL,
		  UNIQUE KEY id (id)
		);";

	require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
	dbDelta($sql);


	$table_name = $wpdb->prefix . "cil_listItemInfo";

		$sql = "CREATE TABLE " . $table_name . " (
			  id mediumint(9) NOT NULL AUTO_INCREMENT,
			  heading VARCHAR(200) NOT NULL,
			  time datetime DEFAULT '0000-00-00 00:00:00' NOT NULL,
			  content text NOT NULL,
			  url VARCHAR(55) DEFAULT '' NOT NULL,
			  image_url VARCHAR(55) DEFAULT '' NOT NULL,
			  list_id int(55) DEFAULT 0 NOT NULL,
			  isHidden tinyint(1) DEFAULT '0' NOT NULL,
			  UNIQUE KEY id (id)
			);";

	dbDelta($sql);

	global $cil_db_version;
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

function cil_install_data() {
	global $wpdb;

	$table_name = $wpdb->prefix . "cil_listInfo";
	$name = "Default List";
	$description = "Description for the default list";
	$logo_url = "jkasd.com";
	$icon_url = "asdasd.jpg";

	$rows_affected = $wpdb->insert($table_name, array('name' => $name,
														'time' => current_time('mysql'),
														'description' => $description,
														'logo_url' => $logo_url,
														'icon_url' => $icon_url ));

	$description = "Sample details paragraph";
	$list_id = 1;
	$table_name = $wpdb->prefix . "cil_listItemInfo";

	$rows_affected = $wpdb->insert( $table_name, array( 'heading'=>'default heading', 'time' => current_time('mysql'), 'description' => $description, 'list_id' => $list_id ) );
}

function myplugin_update_db_check() {
    global $cil_db_version;
    if (get_site_option('cil_db_version') != $cil_db_version) {
        cil_install();
    }
}


?>