jQuery(document).ready(function() {

	jQuery('#deleteDb').bind('click',function(){

		//if the checked box is checked
		var isChecked = jQuery(this).is(':checked');
		if(isChecked == true)
		{
			//throw a confirm box to make sure this is what the user wants
			var c = confirm("Checking this option will delete all data in the database from cil when\n" +
							"the plugin is deactivated, are you sure you want to do this?");

			if(!c)//if the confirm comes back as canceled, uncheck the checkbox and set the data to false
			{
				jQuery(this).removeAttr('checked');
				isChecked = false;
			}
		}else{
			isChecked = false;
		}
		//set data
		var data = {
				action:'cil_set_db_uninstall',
				uninstall: isChecked
		};

		//perform the ajax call
		jQuery.post(ajaxurl, data);
	});
});