jQuery(document).ready(function() {

	//set up fields and buttons for the image uploader
	var image_upload_params = [{button:'#upload_logo_button', formField:'#cil_logoUrl'},
					           {button:'#upload_icon_button', formField:'#cil_iconUrl'},
					           {button:'#upload_item_image_button', formField:'#cil_item_imageUrl'} ];


	for(i = 0; i < image_upload_params.length; i = i + 1)
	{
		jQuery(image_upload_params[i]['button']).click({form:image_upload_params[i]['formField']},function(e) {

			var form = e.data['form'];
			formfield = jQuery(form).attr('name');
			tb_show('', 'media-upload.php?post_id=ID; ?>&type=image&TB_iframe=1');
			return false;
		});
	}

	// Store original function
	window.original_send_to_editor = window.send_to_editor;
	/**
	* Override send_to_editor function from original script
	* Writes URL into the textbox.
	*
	* Note: If header is not clicked, we use the original function.
	*/
	window.send_to_editor = function(html) {

		if (formfield == '') {
			window.original_send_to_editor(html);
		} else {
			fileurl = jQuery(html).attr('href');

			if (typeof(fileurl)=="undefined") {
				fileurl = jQuery('img',html).attr('src');
			}

			//insert the url into the form field and trigger the change event
			jQuery('#' + formfield).val(fileurl).trigger('change');
			tb_remove();
			formfield = '';
		}
	};



});