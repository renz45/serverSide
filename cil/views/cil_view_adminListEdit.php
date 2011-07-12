<?php
//show individual list options
add_action('show_cil_admin_list_options', 'show_list_options');
function show_list_options()
{
	$pageArr = split('cil_list_',$_GET['page']);
	$id = $pageArr[1];

	global $cil_model;
	$listData = $cil_model->get_item_lists($id);


	echo "<div id='cil_wrap'>

			<style type='text/css'>
				h2 {
					background: url('". $listData->logo_url ."') left center no-repeat;
				}
			</style>

			<h2>". $listData->name ."</h2>

			<p class='cil_list_label'>Current Item Lists:</p>";
}