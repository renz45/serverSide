jQuery(document).ready(function() {

	////////////////////////////////////////////////////////////
	//														  //
	//				Page functionality + ajax				  //
	//														  //
	////////////////////////////////////////////////////////////

	////////expand the form when the add new list button is pressed/////////
	jQuery("#create_new_item_header")
		.bind('click',function(){
			var form = jQuery("#cil_edit_item_form");

			if(form.css('height') == "0px")
			{
				form.animate({height:'480px'},350,function(){
													jQuery(this).css({height:'auto'});
												  });
			}

			//clear form
			clearForm();

			//change submit button label
			changeSubmitLabel("Create a New Item");

		});

	///////////list edit button functionality////////////
	jQuery(".cil_item_edit_btn").bind('click',editItemButtonHandler);

	function editItemButtonHandler(){
		var name = jQuery(this).parent().find(".cil_item_heading span").attr('title');

		//expand the edit menu if it's closed
		var form = jQuery("#cil_edit_item_form");
		if(form.css('height') == "0px")
		{
			form.animate({height:'480'},350,function(){
												jQuery(this).css({height:'auto'});
											});
		}

		//change submit button label
		changeSubmitLabel("Edit " + name);

		//take values from the list of item lists and insert them into the form for editing
		jQuery("#cil_item_heading").attr("value", name);
		jQuery("#cil_item_content").attr("value", jQuery(this).parent().find('.cil_item_content').html().replace(/&gt;/gi, '>').replace(/&lt;/gi,'<'));
		jQuery("#cil_item_imageUrl").val(jQuery(this).parent().find('.cil_item_image').attr('alt')).trigger('change');
		jQuery('#cil_item_headingUrl').val(jQuery(this).parent().find('.cil_name_link').attr('href'));
		jQuery("#cil_edit_item_form").attr('action', jQuery(this).parent().attr('id').split("cil-list_item_")[1]);

		//scroll the screen down to the edit form
		jQuery('html').animate({"scrollTop": jQuery("#cil_edit_item_form").scrollTop() + 100});

	}

	///////////////////cancel button////////////////////
	jQuery('#cil_item_cancel_button').bind('click',function(){
		//close form
		jQuery("#cil_edit_item_form")
			.animate({height:'0px'},350)
			.css({height:'auto'});

		//clear form
		clearForm();

		//change submit button label back to the default value
		changeSubmitLabel("Create a New List");
	});

	////////////Ajax hide List////////////////
	jQuery(".cil_hide_btn").bind('click',hideButtonHandler);
	//toggle pinned state
	function hideButtonHandler(){
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
				id: jQuery(this).parent().attr('id').split("cil-list_item_")[1]
		};

		jQuery.post(ajaxurl, data,function(r){
			var obj = jQuery.parseJSON(r);

			if(obj['isHidden'] == 0)
			{
				jQuery('#cil-list_item_'+obj['id']+" .cil_hide_btn").removeClass('active');
			}else{
				jQuery('#cil-list_item_'+obj['id']+" .cil_hide_btn").addClass('active');
			}
		});
	}

	//////////////Ajax delete list//////////////
	jQuery(".cil_item_delete_btn").bind('click',deleteItemButtonHandler);
	//delete an item
	function deleteItemButtonHandler(){

		var data = {
				action:'cil_delete_listItem',
				id: jQuery(this).parent().attr('id').split("cil-list_item_")[1]
		};

		//delete list from the database
		jQuery.post(ajaxurl, data,function(r){
			//remove the item from the list
			jQuery("#cil-list_item_"+r).remove();

			if(jQuery('.cil_admin_list_items li').length == 0)
			{
				jQuery('.cil_admin_list_items').after("<h3 id='cil_no_items'>oops your list is empty, click the button below to start adding new items to your list</h3>");
			}
		});
	}

	//////////////Ajax edit list////////////////
	jQuery("#cil_edit_item_form").bind('submit',function(event){
		//prevent the default form submit action
		event.preventDefault();

		//create data object for ajax call
		var data = {
				action:'cil_edit_item',
				id: jQuery(this).attr('action'),
				heading: jQuery('#cil_item_heading').val(),
				imageUrl: jQuery("#cil_item_imageUrl").val(),
				url: jQuery("#cil_item_headingUrl").val(),
				listId: jQuery('.cil_hidden_list_id').val(),
				content: jQuery("#cil_item_content").val()
		};
		//update list

		//perform the ajax call
		jQuery.post(ajaxurl, data,function(r){
			//if the upload is successful

			var maxChars = 12;

			//parse the return JSON object into a javascript object
			var data = jQuery.parseJSON(r);

			data['content'] = data['content'].replace(/>/gi,'&gt;').replace(/</gi,'&lt;');


			var choppedHeading =  (data['heading']).slice(0,maxChars);

			if(data['newItem'] == true)
			{//if the ajax call was a new post than create a new list item for the list, use the returned data object to populate values
				var heading = "";
				var image = "";

				if(data['url'].length > 0)
				{
					heading = "<a class='cil_name_link' href='"+ data['url'] +"' title='"+ data['heading'] +"'><span title='"+ data['heading'] +"'>"+ choppedHeading +"</span></a>";
				}else{
					heading = "<span title='"+ data['heading'] +"'>"+ choppedHeading +"</span>";
				}

				if(data['imageUrl'].length > 0)
				{
					image = "<img class='cil_item_image' src='"+ jQuery('#cil_item_imageIcon').attr('src') +"' alt='"+ data['imageUrl'] +"' title='This item has an image' width='15' height='15' />";
				}

				jQuery('.cil_admin_list_items').append(
				"<li id='cil-list_item_"+ data['id'] +"'>"+
						"<a class='cil_hide_btn cil_list_item_btn ' title='Hide this item'>hide</a>"+
						image +
						"<span class='cil_item_heading'> - "+
						heading +
						" - </span>"+
						"<p class='cil_item_content'>"+ data['content'] +"</p>"+
						"<a class='cil_list_item_btn cil_item_edit_btn'>Edit</a>"+
						"<a class='cil_list_item_btn cil_item_delete_btn'>Delete</a>"+
					"</li>");

				//rebind click handlers to the buttons in the new list item, this is done automatically on page reload, but this is for when a list item is
				//initally created so the page doesn't have to reload in order to get functionality
				var newItem = jQuery('#cil-list_item_'+ data['id']);

				newItem.find('.cil_item_edit_btn').bind('click',editItemButtonHandler);
				newItem.find('.cil_hide_btn').bind('click',hideButtonHandler);
				newItem.find('.cil_item_delete_btn').bind('click',deleteItemButtonHandler);

				var h3 = jQuery('#cil_no_items');
				if(h3.length > 0)
				{
					h3.remove();
				}

			}else{//if the list item exists and it's just being edited, change the values in the main list to match the edits
				var list = jQuery("#cil-list_item_" + data['id']);

				//if there is an item url
				if(data['url'].length > 0)
				{

					if(list.find('.cil_name_link').length == 0 )//if there is not an anchor tag around the heading already, than wrap one around it
					{
						list.find('.cil_item_heading span').wrap("<a class='cil_name_link' href='"+ data['url'] +"' title='"+ data['heading'] +"'></a>");
					}else{//if the anchor exists, just change the src and title attributes to match the new settings
						list.find('.cil_name_link').attr('href',data['url']).attr('title', data['heading']);
					}
				}else if(list.find('.cil_name_link').length == 1){//if the anchor tag exists and there is nothing for the item url, remove the anchor tag surrounding the heading
					list.find('.cil_item_heading span').unwrap('a');
				}

				//if there is an image url
				if(data['imageUrl'].length > 0)
				{
					//if the image icon doesn't already exist, than add a new one
					if(list.find('.cil_item_image').length == 0)
					{
						list.find('.cil_hide_btn').after("<img class='cil_item_image' src='"+ jQuery('#cil_item_imageIcon').attr('src') +"' alt='"+ data['imageUrl'] +"' title='This item has an image' width='15' height='15' />");
					}else{//if the icon already exists, just change the alt attribute to match the new values
						list.find('.cil_item_image').attr('alt', data['imageUrl']);
					}
				}else{//if there is no image url in the return go ahead and remove the image icon
					list.find('.cil_item_image').remove();
				}

				list.find('.cil_item_heading span')
					.html(choppedHeading)
					.attr('title',data['heading']);

				list.find('.desc')
					.html(data['content']);
			}
			//close the form
			jQuery("#cil_edit_item_form")
				.animate({height:'0px'},350)
				.css({height:'auto'});

			//clear form
			clearForm();

			//change submit button label back to the default value
			changeSubmitLabel("Create a New Item");

		});
	});

	//update image preview
	jQuery('#cil_item_imageUrl').bind('change keyup',function(){
		jQuery('#cil_preview_item_image').attr('src', jQuery(this).val());
	});


	////////////clear edit list form//////////////
	function clearForm(){
		jQuery("#cil_item_heading").attr("value", "");
		jQuery("#cil_item_content").val("");
		jQuery("#cil_item_imageUrl").val("");
		jQuery("#cil_hidden_list_id").val("");
		jQuery('#cil_item_headingUrl').val("");
		jQuery('.cil_error').html('');
		jQuery('#cil_preview_item_image').attr('src',"");
	}

	//////////////change submit button label///////////////
	function changeSubmitLabel(label){
		jQuery('#cil_newItemSubmit').attr('value', label);
	}


});