<?php

//instantiate the model class
$cil_model = new Cil_Models($wpdb);

class Cil_Models {

	private $_wpdb;

	/**
	 *
	 * models for the custom item list plugin
	 * @param $wordpress database($wpdb) $wpdb global database class which is part of the wordpress plugin API
	 */
    public function __construct($wpdb)
    {
		$this->_wpdb = $wpdb;
    }

    /**
     *
     * Returns items lists. If a list id is passed into the constructor than onfo for that list is the only thing returned
     * @param unknown_type $id
     */
    public function get_item_lists($id = null)
    {

    	$tableName = $this->_wpdb->prefix . "cil_listInfo";

    	$sql = "SELECT * FROM " . $tableName;

		if(!is_null($id))
		{
			$sql .= " WHERE id=".$id;
			$arr = $this->_wpdb->get_results($sql);
			return $arr[0];
		}else{
			return $this->_wpdb->get_results($sql);
		}
    }

    /**
     *
     * Returns pinned item lists, this is used to populate the sidemenu with pinned lists
     */
    public function get_pinned_lists()
    {
		$tableName = $this->_wpdb->prefix . "cil_listInfo";

    	$sql = "SELECT * FROM " . $tableName . " WHERE isPinned='1'";

		return $this->_wpdb->get_results($sql);
    }

	/**
	 * Returns all list items, or only the list items from the list id specified
	 * @param int $list_id list id to pull results from
	 */
	public function get_list_items($list_id = null)
    {

    	$tableName = $this->_wpdb->prefix . "cil_listItemInfo";

    	$sql = "SELECT * FROM " . $tableName;

		if(!is_null($list_id))
		{
			$sql .= " WHERE list_id=".$list_id;
			$arr = $this->_wpdb->get_results($sql);
			return $arr;
		}else{
			return $this->_wpdb->get_results($sql);
		}
    }

	/**
	 * Returns all list items, or only the list items from the list id specified
	 * @param int $list_id list id to pull results from
	 */
	public function get_list_items_by_name($list_name)
    {

    	$sql = "SELECT * FROM `wp_cil_listItemInfo` as li
					JOIN `wp_cil_listInfo` as l
						on li.`list_id` = l.id
					WHERE l.name = '$list_name'";

		return $this->_wpdb->get_results($sql);
    }

}