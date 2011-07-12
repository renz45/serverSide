<?php
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

    public function get_pinned_lists()
    {
		$tableName = $this->_wpdb->prefix . "cil_listInfo";

    	$sql = "SELECT * FROM " . $tableName . " WHERE isPinned='1'";

		return $this->_wpdb->get_results($sql);
    }

}