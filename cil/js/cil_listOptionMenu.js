jQuery(document).ready(function() {

	////////////////////////////////////////////////////////////
	//														  //
	//				Page functionality + ajax				  //
	//														  //
	////////////////////////////////////////////////////////////

	////////expand the form when the add new list button is pressed/////////
	jQuery("#create_new_list_header").bind('click',function(){
		var form = jQuery("#cil_edit_List_form");

		if(form.css('height') == "0px")
		{
			form.animate({height:'480px'},350).css({height:'auto'});
		}

		//clear form
		clearForm();

		//change submit button label
		changeSubmitLabel("Create a New List");

	});

	///////////list edit button functionality////////////
	jQuery(".cil_list_edit_btn").bind('click',editButtonHandler);

	function editButtonHandler(){
		var name = jQuery(this).parent().find(".cil_list_name span").html();

		//expand the edit menu if it's closed
		var form = jQuery("#cil_edit_List_form");
		if(form.css('height') == "0px")
		{
			form.animate({height:'480'},350).css({height:'auto'});
		}

		//change submit button label
		changeSubmitLabel("Edit " + name + " List");

		//take values from the list of item lists and insert them into the form for editing
		jQuery("#cil_listName").attr("value", name);
		jQuery("#cil_listDescription").attr("value", jQuery(this).parent().find('.desc').html());
		jQuery("#cil_imageUrl").val(jQuery(this).parent().find('.cil_item_image').attr('alt')).trigger('change');
		jQuery('#cil_listNameUrl').val(jQuery(this).parent().find('.cil_name_link').attr('href'));
		jQuery("#cil_edit_List_form").attr('action', jQuery(this).parent().attr('id').split("cil-list_")[1]);

		//scroll the screen down to the edit form
		jQuery('html').animate({"scrollTop": jQuery("#cil_edit_List_form").scrollTop() + 100});

	}

	///////////////////cancel button////////////////////
	jQuery('#cil_cancel_button').bind('click',function(){
		//close form
		jQuery("#cil_edit_List_form").animate({height:'0px'},350).css({height:'auto'});

		//clear form
		clearForm();

		//change submit button label back to the default value
		changeSubmitLabel("Create a New List");
	});

	////////////Ajax hide List////////////////
	jQuery(".cil_pin_btn").bind('click',pinButtonHandler);
	//toggle pinned state
	function pinButtonHandler(){
		var hidden = '1';
		if(jQuery(this).hasClass('active'))//if the item has the class active which means it is pinned
		{
			hidden = '0';
		}else{//no active class and is not pinned
			hidden = '1';
		}

		var data = {
				action:'cil_hide_list',
				isHidden: hidden,
				id: jQuery(this).parent().attr('id').split("cil-list_")[1]
		};

		jQuery.post(ajaxurl, data,function(r){
			var obj = jQuery.parseJSON(r);

			if(obj['isPinned'] == 0)
			{
				jQuery('#cil-list_'+obj['id']+" .cil_pin_btn").removeClass('active');
			}else{
				jQuery('#cil-list_'+obj['id']+" .cil_pin_btn").addClass('active');
			}
		});
	}

	//////////////Ajax delete list//////////////
	jQuery(".cil_list_delete_btn").bind('click',deleteButtonHandler);
	//delete an item
	function deleteButtonHandler(){

		var data = {
				action:'cil_delete_listItem',
				id: jQuery(this).parent().attr('id').split("cil-list_")[1]
		};

		//delete list from the database
		jQuery.post(ajaxurl, data,function(r){
			//remove the item from the list
			jQuery("#cil-list_"+r).remove();
		});
	}

	//////////////Ajax edit list////////////////
	jQuery("#cil_edit_List_form").bind('submit',function(event){
		//prevent the default form submit action
		event.preventDefault();
		var maxNameLength = 12;

		//create data object for ajax call
		var data = {
				action:'cil_edit_list',
				id: jQuery(this).attr('action'),
				listName: jQuery('#cil_listName').val(),
				logoUrl: jQuery("#cil_logoUrl").attr("value"),
				iconUrl: jQuery("#cil_iconUrl").attr("value"),
				listDesc: jQuery("#cil_listDescription").attr("value")
		};
		//update list

		//perform the ajax call
		jQuery.post(ajaxurl, data,function(r){
			//if the upload is successful

			//parse the return JSON object into a javascript object
			var data = jQuery.parseJSON(r);

			if(data['newPost'] == true)
			{//if the ajax call was a new post than create a new list item for the list, use the returned data object to populate values
				jQuery('.cil_admin_list').append(
				"<li id='cil-list_"+ data['id'] +"'>"+
				"<a class='cil_pin_btn cil_list_btn' title='Pin this list to menu'>pin</a>"+
				"<img class='cil_icon_url' src='"+data['iconUrl']+"' alt='"+ data['listName'] +"-"+data['iconUrl']+"' title='"+data['iconUrl']+"' width='20' height='20' />"+
				"<img class='cil_logo_url' src='"+data['logoUrl']+"' alt='"+ data['listName'] +"-"+data['logoUrl']+"' title='"+data['logoUrl']+"' width='0' height='0' />"+
				"<span class='cil_list_name'> - <span>"+ data['listName'] +"</span> - </span>"+
				"<p class='desc'>"+data['listDesc']+"</p>"+
				"<a class='cil_list_btn cil_list_edit_btn'>Edit</a>"+
				"<a class='cil_list_btn cil_list_delete_btn'>Delete</a>"+
				"</li>\n");

				//rebind click handlers to the buttons in the new list item, this is done automatically on page reload, but this is for when a list item is
				//initally created so the page doesn't have to reload in order to get functionality
				var newItem = jQuery('#cil-list_'+ data['id']);

				newItem.find('.cil_list_edit_btn').bind('click',editButtonHandler);
				newItem.find('.cil_pin_btn').bind('click',pinButtonHandler);
				newItem.find('.cil_list_delete_btn').bind('click',deleteButtonHandler);

			}else{//if the list item exists and it's just being edited, change the values in the main list to match the edits
				var list = jQuery("#cil-list_" + data['id']);

				var logo = list.find('.cil_logo_url');
				var icon = list.find('.cil_icon_url');

				logo.attr('alt', data['listName']+"-"+data['logoUrl']);
				icon.attr('alt', data['listName']+"-"+data['iconUrl']);
				list.find('.cil_list_name span').html(data['listName']);
				logo.attr('src', data['logoUrl']);
				logo.attr('title',data['logoUrl']);
				icon.attr('src', data['iconUrl']);
				icon.attr('title',data['iconUrl']);
				list.find('.desc').html(data['listDesc']);
			}
			//close the form
			jQuery("#cil_edit_List_form").animate({height:'0px'},350).css({height:'auto'});

			//clear form
			clearForm();

			//change submit button label back to the default value
			changeSubmitLabel("Create a New List");

		});
	});

	//update icon preview image
	jQuery('#cil_iconUrl').bind('change keyup',function(){
		jQuery('#cil_preview_icon').attr('src', jQuery(this).val());
	});


	////////////clear edit list form//////////////
	function clearForm(){
		jQuery("#cil_listName").attr("value", "");
		jQuery("#cil_listDescription").val("");
		jQuery("#cil_imageUrl").attr("value", "");
		jQuery("#cil_edit_List_form").attr('action', "");
		jQuery('#cil_listNameUrl').val("");
		jQuery('.cil_error').html('');
	}

	//////////////change submit button label///////////////
	function changeSubmitLabel(label){
		jQuery('#cil_newListSubmit').attr('value', label);
	}

	////////////////////////////////////////////////////////////
	//														  //
	//					Form Validation						  //
	//														  //
	////////////////////////////////////////////////////////////

});