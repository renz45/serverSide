<?php

global $cil_db_version;

function cil_install () {
   global $wpdb;

   add_option('cil_uninstall_db', false);

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

}
//if the option to delete the tables on uninstall is checked then drop the tables used for cil
function cil_uninstall()
{

	if(get_option('cil_uninstall_db') == true)
	{
		global $wpdb;

		$listItemTableName = $wpdb->prefix . "cil_listItemInfo";
	    $listTableName = $wpdb->prefix . "cil_listInfo";

		$wpdb->query("DROP TABLE $listItemTableName");
		$wpdb->query("DROP TABLE $listTableName");

	}

	delete_option('cil_uninstall_db');

}


?>