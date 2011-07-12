jQuery(document).ready(function() {


	var formfield = '';

	//uload logo button/field
	jQuery('#upload_logo_button').click(function() {
		formfield = jQuery('#cil_logoUrl').attr('name'); // set this to the id field you want to populate with the url
		tb_show('', 'media-upload.php?post_id=ID; ?>&type=image&TB_iframe=1');

		return false;
	});

	//upload icon button/field
	jQuery('#upload_icon_button').click(function() {
		formfield = jQuery('#cil_iconUrl').attr('name'); // set this to the id field you want to populate with the url
		tb_show('', 'media-upload.php?post_id=ID; ?>&type=image&TB_iframe=1');
		return false;
	});

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