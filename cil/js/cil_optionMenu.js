jQuery(document).ready(function() {

	////////////////////////////////////////////////////////////
	//														  //
	//				Page functionality + ajax				  //
	//														  //
	////////////////////////////////////////////////////////////

	////////expand the form when the add new list button is pressed/////////
	jQuery("#cil_create_new_list_header").bind('click',function(){

		var form = jQuery("#cil_edit_List_form");
		if(form.css('height') == "0px")
		{
			expandEditListForm(form);
		}

		//hide item list if its up
		jQuery('#cil_item_wrap').hide();

		//clear form
		clearForm();

		//change submit button label
		changeSubmitLabel("Create a New List");

	});

	///////////list edit button functionality////////////
	jQuery(".cil_list_edit_btn").bind('click',editButtonHandler);

	function editButtonHandler(){
		var name = jQuery(this).parent().find(".cil_list_name span").html();

		var thisId =  jQuery(this).parent().attr('id').split("cil-list_")[1];

		jQuery('#cil_item_wrap').hide();

		//expand the edit menu if it's closed
		var form = jQuery("#cil_edit_List_form");
		if(form.css('height') == "0px")
		{
			expandEditListForm(form);
		}

		//close the edit list item form if open
		jQuery('#cil_item_wrap').hide();

		//show the edit list items button
		jQuery('#cil_edit_list_items').fadeIn(200);

		//change submit button label
		changeSubmitLabel("Edit " + name + " List");

		//take values from the list of item lists and insert them into the form for editing
		jQuery("#cil_listName").attr("value", name);
		jQuery("#cil_listDescription").val(jQuery(this).parent().find('.desc').html());
		jQuery("#cil_iconUrl").attr("value", jQuery(this).parent().find('.cil_icon_url').attr('src')).trigger('change');
		jQuery("#cil_logoUrl").attr("value", jQuery(this).parent().find('.cil_logo_url').attr('src')).trigger('change');
		jQuery('.cil_hidden_list_id').val(thisId);

		//scroll the screen down to the edit form
		jQuery('html').animate({"scrollTop": jQuery("#cil_edit_List_form").scrollTop() + 100});


		//populate the list items in the hidden list edit menu in case the user wants to edit them
		var data = {
				action:'cil_get_items',
				id: jQuery('.cil_hidden_list_id').val()
		};


		jQuery.post(ajaxurl, data,function(r){

			maxChars = 12;

			r = jQuery.parseJSON(r);

			jQuery('.cil_admin_list_items').empty();

			for(index in r)
			{
				var item = r[index];

				item['content'] = item['content'].replace(/>/gi,'&gt;').replace(/</gi,'&lt;');

				var choppedHeading =  (item['heading']).slice(0,maxChars);

				var heading = "";
				var image = "";

				if(item['url'].length > 0)
				{
					heading = "<a class='cil_name_link' href='"+ item['url'] +"' title='"+ item['heading'] +"'><span title='"+ item['heading'] +"'>"+ choppedHeading +"</span></a>";
				}else{
					heading = "<span title='"+ item['heading'] +"'>"+ choppedHeading +"</span>";
				}

				if(item['image_url'].length > 0)
				{
					image = "<img class='cil_item_image' src='"+ jQuery('#cil_item_imageIcon').attr('src') +"' alt='"+ item['image_url'] +"' title='This item has an image' width='15' height='15' />";
				}

				jQuery('.cil_admin_list_items').append(
				"<li id='cil-list_item_"+ item['id'] +"'>"+
						"<a class='cil_hide_btn cil_list_item_btn "+ (item['isHidden']==1?'active':'') +" ' title='Hide this item'>hide</a>"+
						image +
						"<span class='cil_item_heading'> - "+
						heading +
						" - </span>"+
						"<p class='cil_item_content'>"+ item['content'] +"</p>"+
						"<a class='cil_list_item_btn cil_item_edit_btn'>Edit</a>"+
						"<a class='cil_list_item_btn cil_item_delete_btn'>Delete</a>"+
					"</li>");

				//rebind click handlers to the buttons in the new list item, this is done automatically on page reload, but this is for when a list item is
				//initally created so the page doesn't have to reload in order to get functionality
				var newItem = jQuery('#cil-list_item_'+ item['id']);

				newItem.find('.cil_item_edit_btn').bind('click',editItemButtonHandler);
				newItem.find('.cil_hide_btn').bind('click',hideButtonHandler);
				newItem.find('.cil_item_delete_btn').bind('click',deleteItemButtonHandler);
			}
			var h3 = jQuery('#cil_no_items');
			if(h3.length > 0)
			{
				h3.remove();
			}
		});
	}

	///////////////////edit list cancel button////////////////////
	jQuery('#cil_cancel_button').bind('click',function(){
		//close form
		closeEditListForm(jQuery("#cil_edit_List_form"));

		//clear form
		clearForm();


		//change submit button label back to the default value
		changeSubmitLabel("Create a New List");
	});



	///////////////////edit list item button////////////////////
	jQuery('#cil_edit_list_items').bind('click',function(){
		closeEditListForm(jQuery("#cil_edit_List_form"));

		jQuery('#cil_item_wrap').fadeIn(200);

	});

	////////////Ajax pin List////////////////
	jQuery(".cil_pin_btn").bind('click',pinButtonHandler);
	//toggle pinned state
	function pinButtonHandler(){
		var pinned = '1';
		if(jQuery(this).hasClass('active'))//if the item has the class active which means it is pinned
		{
			pinned = '0';
		}else{//no active class and is not pinned
			pinned = '1';
		}

		var data = {
				action:'cil_pin_list',
				isPinned: pinned,
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

		jQuery('#cil_item_wrap').hide();

		var data = {
				action:'cil_delete_list',
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

		jQuery('#cil_item_wrap').hide();

		//create data object for ajax call
		var data = {
				action:'cil_edit_list',
				id: jQuery('.cil_hidden_list_id').val(),
				listName: (jQuery('#cil_listName').val()).slice(0,maxNameLength),//shorten name value to 12 chars to fit the menu
				logoUrl: jQuery("#cil_logoUrl").val(),
				iconUrl: jQuery("#cil_iconUrl").val(),
				listDesc: jQuery("#cil_listDescription").val()
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
			closeEditListForm(jQuery("#cil_edit_List_form"));

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

	//update logo preview image
	jQuery('#cil_logoUrl').bind('change keyup',function(){
		jQuery('#cil_preview_logo').attr('src', jQuery(this).val());
	});

	////////////clear edit list form//////////////
	function clearForm(){
		jQuery("#cil_listName").attr("value", "");
		jQuery("#cil_listDescription").val("");
		jQuery("#cil_iconUrl").attr("value", "");
		jQuery("#cil_logoUrl").attr("value", "");
		jQuery("#cil_edit_List_form .cil_hidden_list_id").val("");
		jQuery('.cil_error').html('');
		jQuery('#cil_preview_logo').attr('src',"");
		jQuery('#cil_preview_icon').attr('src',"");
	}

	//////////////change submit button label///////////////
	function changeSubmitLabel(label){
		jQuery('#cil_newListSubmit').attr('value', label);
	}

	function expandEditListForm(form)
	{

		form.animate({height:'500'},350).css({height:'auto'});
	}

	function closeEditListForm(form)
	{
		jQuery('#cil_edit_list_items').fadeOut(200);
		form.animate({height:'0px'},350).css({height:'auto'});
	}

	////////////////////////////////////////////////////////////
	//														  //
	//					Form Validation						  //
	//														  //
	////////////////////////////////////////////////////////////

	//limit the list name so it's not too big to fit on the menu bar
	jQuery('#cil_listName').bind('keyup', function(e){
		var maxLength = 12;

		var value = jQuery(this).val();
		var length = value.length;

		var error = jQuery(this).parent().find('.cil_error');

		var extraLength = length - maxLength;

		if( extraLength > 0 )
		{
			error.fadeIn(250);
			error.html(' List name is '+ extraLength +' character'+(extraLength == 1?'':'s')+' too long, it will be shortened to: ' + value.slice(0,maxLength));
		}else{
			error.fadeOut(400, function(){
				error.html('');
			});
		}
	});

	/////////////////////////////////////////////////
	///////////////////Item List/////////////////////
	/////////////////////////////////////////////////

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
			clearItemForm();

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
		changeItemSubmitLabel("Edit " + name);

		//take values from the list of item lists and insert them into the form for editing
		jQuery("#cil_item_heading").val(name);
		jQuery("#cil_item_content").val(jQuery(this).parent().find('.cil_item_content').html().replace(/&gt;/gi, '>').replace(/&lt;/gi,'<'));
		jQuery("#cil_item_imageUrl").val(jQuery(this).parent().find('.cil_item_image').attr('alt')).trigger('change');
		jQuery('#cil_item_headingUrl').val(jQuery(this).parent().find('.cil_name_link').attr('href'));
		jQuery("#cil_edit_item_form .cil_hidden_list_item_id").val(jQuery(this).parent().attr('id').split("cil-list_item_")[1]);

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
		clearItemForm();

		//change submit button label back to the default value
		changeItemSubmitLabel("Create a New List");
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
				id: jQuery(this).find('.cil_hidden_list_item_id').val(),
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
			clearItemForm();

			//change submit button label back to the default value
			changeItemSubmitLabel("Create a New Item");

		});
	});

	//update image preview
	jQuery('#cil_item_imageUrl').bind('change keyup',function(){
		jQuery('#cil_preview_item_image').attr('src', jQuery(this).val());
	});


	////////////clear edit list form//////////////
	function clearItemForm(){
		jQuery("#cil_item_heading").val("");
		jQuery("#cil_item_content").val("");
		jQuery("#cil_item_imageUrl").val("");
		jQuery('#cil_item_headingUrl').val("");
		jQuery('.cil_error').html('');
		jQuery('#cil_preview_item_image').attr('src',"");
		jQuery('.cil_hidden_list_item_id').val("");
	}

	//////////////change submit button label///////////////
	function changeItemSubmitLabel(label){
		jQuery('#cil_newItemSubmit').attr('value', label);
	}
});