jQuery(document).ready(function() {
	////////////////////////////////////////////////////////////
	//														  //
	//				frequently usedpage Elements			  //
	//														  //
	////////////////////////////////////////////////////////////
	var cilListWrapper = jQuery('#cil_wrap');
	var cilItemWrapper = jQuery('#cil_item_wrap');

	var cilListList = cilListWrapper.find('.cil_admin_list');
	var cilItemList = cilItemWrapper.find('.cil_admin_list_items');

	var editListItemButton = cilListWrapper.find('#cil_edit_list_items');

	var editListForm = cilListWrapper.find("#cil_edit_List_form");
	var formListName = editListForm.find("#cil_listName");
	var formListDescription = editListForm.find("#cil_listDescription");
	var formListIconUrl = editListForm.find("#cil_iconUrl");
	var formListLogoUrl = editListForm.find("#cil_logoUrl");
	var formListSubmit = editListForm.find('.#cil_newListSubmit');

	var editItemForm = cilItemWrapper.find("#cil_edit_item_form");
	var formItemHeading = editItemForm.find("#cil_item_heading");
	var formItemContent = editItemForm.find("#cil_item_content");
	var formItemImageUrl = editItemForm.find("#cil_item_imageUrl");
	var formItemHeadingUrl = editItemForm.find('#cil_item_headingUrl');
	var formItemSubmit = editItemForm.find('#cil_newItemSubmit');

	var cilItemImageIcon = editItemForm.find('#cil_item_imageIcon');

	var createNewListButton = cilListWrapper.find("#cil_create_new_list_header");

	////////////////////////////////////////////////////////////
	//														  //
	//						bindings						  //
	//														  //
	////////////////////////////////////////////////////////////

	//////////expand the form when the add new list button is pressed/////////
	createNewListButton.bind('click',function(){

		var form = editListForm;
		if(form.css('height') == "0px")
		{
			expandEditListForm(form);
		}

		//hide item list if its up
		hideItemEdit();

		//clear form
		clearForm();

		//change submit button label
		changeSubmitLabel("Create a New List");

	});

	///////////////list edit button functionality////////////
	cilListWrapper.find("ul li .cil_list_edit_btn").bind('click',editButtonHandler);
	// this is a seperate function so it can be rebound to newly created buttons
	function editButtonHandler(){
		var name = jQuery(this).parent().find(".cil_list_name span").html();

		var thisId =  jQuery(this).parent().attr('id').split("cil-list_")[1];

		//expand the edit menu if it's closed
		if(editListForm.css('height') == "0px")
		{
			expandEditListForm(editListForm);
		}

		//close the edit list item form if open
		hideItemEdit();

		//show the edit list items button
		showItemEditButton();

		//change submit button label
		changeSubmitLabel("Edit " + name + " List");

		//take values from the list of item lists and insert them into the form for editing
		formListName.val(name);
		formListDescription.val(jQuery(this).parent().find('.desc').html());
		formListIconUrl.val(jQuery(this).parent().find('.cil_icon_url').attr('src')).trigger('change');
		formListLogoUrl.val(jQuery(this).parent().find('.cil_logo_url').attr('src')).trigger('change');
		editListForm.find('.cil_hidden_list_id').val(thisId);
		editItemForm.find('.cil_hidden_list_id').val(thisId);

		//scroll the screen down to the edit form
		jQuery('html').animate({"scrollTop": jQuery("#cil_edit_List_form").scrollTop() + 100});

		//populate the list items in the hidden list edit menu in case the user wants to edit them
		var data = {
				action:'cil_get_items',
				id: jQuery('.cil_hidden_list_id').val()
		};

		//make an ajax call to get the list items for list we are editing just in case we want to edit the items
		jQuery.post(ajaxurl, data,function(r){

			//max chars for the heading list display
			var maxChars = 12;

			//parse the returning JSON
			r = jQuery.parseJSON(r);

			//clear the list items list before filling it back with the current list's items
			cilItemList.empty();

			//loop through the list items and populate the item list
			for(index in r)
			{
				var item = r[index];

				item['content'] = item['content'].replace(/>/gi,'&gt;').replace(/</gi,'&lt;');

				var choppedHeading = chopHeading(item['heading'],maxChars);

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
					image = "<img class='cil_item_image' src='"+ cilItemImageIcon.attr('src') +"' alt='"+ item['image_url'] +"' title='This item has an image' width='15' height='15' />";
				}

				cilItemList.append(
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
				var newItem = cilItemList.find('#cil-list_item_'+ item['id']);

				newItem.find('.cil_item_edit_btn').bind('click',editItemButtonHandler);
				newItem.find('.cil_hide_btn').bind('click',hideButtonHandler);
				newItem.find('.cil_item_delete_btn').bind('click',deleteItemButtonHandler);
			}
			//remove the no item notifaction message
			var emptyMsg = jQuery('#cil_no_items');
			if(emptyMsg.length > 0)
			{
				emptyMsg.remove();
			}
		});
	}

	///////////////////edit list cancel button////////////////////
	jQuery('#cil_cancel_button').bind('click',function(){
		//close form
		closeEditListForm(editListForm);

		//clear form
		clearForm();

		//change submit button label back to the default value
		changeSubmitLabel("Create a New List");
	});

	///////////////////edit list item button////////////////////
	jQuery('#cil_edit_list_items').bind('click',function(){
		closeEditListForm(editListForm);

		showItemEdit();
	});

	/////////////////Ajax pin List////////////////
	jQuery(".cil_pin_btn").bind('click',pinButtonHandler);
	//toggle pinned state - this is a seperate function so it can be rebound to newly created buttons
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
				cilListWrapper.find('#cil-list_'+obj['id']+" .cil_pin_btn").removeClass('active');
			}else{
				cilListWrapper.find('#cil-list_'+obj['id']+" .cil_pin_btn").addClass('active');
			}
		});
	}

	//////////////Ajax delete list//////////////
	jQuery(".cil_list_delete_btn").bind('click',deleteButtonHandler);
	//delete an item - this is a seperate function so it can be rebound to newly created buttons
	function deleteButtonHandler(){

		hideItemEdit();

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
	editListForm.bind('submit',function(event){
		//prevent the default form submit action
		event.preventDefault();
		var maxNameLength = 12;

		hideItemEdit();

		//create data object for ajax call
		var data = {
				action:'cil_edit_list',
				id: jQuery(this).find('.cil_hidden_list_id').val(),
				listName: (jQuery(this).find('#cil_listName').val()).slice(0,maxNameLength),//shorten name value to 12 chars to fit the menu
				logoUrl: jQuery(this).find("#cil_logoUrl").val(),
				iconUrl: jQuery(this).find("#cil_iconUrl").val(),
				listDesc: jQuery(this).find("#cil_listDescription").val()
		};
		//update list

		//perform the ajax call
		jQuery.post(ajaxurl, data,function(r){
			//if the upload is successful

			//parse the return JSON object into a javascript object
			var data = jQuery.parseJSON(r);

			if(data['newPost'] == true)
			{//if the ajax call was a new post than create a new list item for the list, use the returned data object to populate values
				cilListWrapper.find('.cil_admin_list').append(
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
				var newItem = cilListWrapper.find('ul #cil-list_'+ data['id']);

				newItem.find('.cil_list_edit_btn').bind('click',editButtonHandler);
				newItem.find('.cil_pin_btn').bind('click',pinButtonHandler);
				newItem.find('.cil_list_delete_btn').bind('click',deleteButtonHandler);

			}else{//if the list item exists and it's just being edited, change the values in the main list to match the edits
				var list = cilListWrapper.find("#cil-list_" + data['id']);

				var logo = list.find('.cil_logo_url');
				var icon = list.find('.cil_icon_url');

				logo.attr('alt', data['listName']+"-"+data['logoUrl'])
					.attr('src', data['logoUrl'])
					.attr('title',data['logoUrl']);
				icon.attr('alt', data['listName']+"-"+data['iconUrl'])
					.attr('src', data['iconUrl'])
					.attr('title',data['iconUrl']);
				list.find('.cil_list_name span')
					.html(data['listName']);
				list.find('.desc')
					.html(data['listDesc']);
			}
			//close the form
			closeEditListForm(editListForm);

			//clear form
			clearForm();

			//change submit button label back to the default value
			changeSubmitLabel("Create a New List");

		});
	});

	////////////////////update icon preview image//////////////////////
	formListIconUrl.bind('change keyup',function(){
		editListForm.find('#cil_preview_icon').attr('src', jQuery(this).val());
	});

	//////////////////update logo preview image//////////////////
	formListLogoUrl.bind('change keyup',function(){
		editListForm.find('#cil_preview_logo').attr('src', jQuery(this).val());
	});

	/////////////////update image preview///////////////////
	jQuery('#cil_item_imageUrl').bind('change keyup',function(){
		jQuery('#cil_preview_item_image').attr('src', jQuery(this).val());
	});

	///////////////////limit the list name so it's not too big to fit on the menu bar////////////////
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

	////////expand the form when the add new list button is pressed/////////
	jQuery("#create_new_item_header").bind('click',function(){


			if(editItemForm.css('height') == "0px")
			{
				expandEditListForm(editItemForm);
			}

			//clear form
			clearItemForm();

			//change submit button label
			changeSubmitLabel("Create a New Item");
		});


///////////list edit button functionality////////////
	cilItemWrapper.find(".cil_item_edit_btn").bind('click',editItemButtonHandler);

	function editItemButtonHandler(){
		var name = jQuery(this).parent().find(".cil_item_heading span").attr('title');

		//expand the edit menu if it's closed
		if(editItemForm.css('height') == "0px")
		{
			expandEditListForm(editItemForm);
		}

		//change submit button label
		changeItemSubmitLabel("Edit " + name);

		//take values from the list of item lists and insert them into the form for editing
		formItemHeading.val(name);
		formItemContent.val(jQuery(this).parent().find('.cil_item_content').html().replace(/&gt;/gi, '>').replace(/&lt;/gi,'<'));
		formItemImageUrl.val(jQuery(this).parent().find('.cil_item_image').attr('alt')).trigger('change');
		formItemHeadingUrl.val(jQuery(this).parent().find('.cil_name_link').attr('href'));
		editItemForm.find(".cil_hidden_list_item_id").val(jQuery(this).parent().attr('id').split("cil-list_item_")[1]);

		//scroll the screen down to the edit form
		jQuery('html').animate({"scrollTop": editItemForm.scrollTop() + 100});
	}

	///////////////////cancel button////////////////////
	editItemForm.find('#cil_item_cancel_button').bind('click',function(){

		//close form
		closeEditListForm(editItemForm);

		//clear form
		clearItemForm();

		//change submit button label back to the default value
		changeItemSubmitLabel("Create a New List");
	});

	////////////////Ajax hide List////////////////
	cilItemList.find(".cil_hide_btn").bind('click',hideButtonHandler);
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
				cilItemList.find('#cil-list_item_'+obj['id']+" .cil_hide_btn").removeClass('active');
			}else{
				cilItemList.find('#cil-list_item_'+obj['id']+" .cil_hide_btn").addClass('active');
			}
		});
	}

	//////////////Ajax delete list//////////////
	cilItemList.find(".cil_item_delete_btn").bind('click',deleteItemButtonHandler);
	//delete an item
	function deleteItemButtonHandler(){

		var data = {
				action:'cil_delete_listItem',
				id: jQuery(this).parent().attr('id').split("cil-list_item_")[1]
		};

		//delete list from the database
		jQuery.post(ajaxurl, data,function(r){
			//remove the item from the list
			cilItemList.find("#cil-list_item_"+r).remove();

			if(cilItemList.find('li').length == 0)
			{
				cilItemList.after("<h3 id='cil_no_items'>oops your list is empty, click the button below to start adding new items to your list</h3>");
			}
		});
	}

	//////////////Ajax edit list////////////////
	editItemForm.bind('submit',function(event){
		//prevent the default form submit action
		event.preventDefault();

		//create data object for ajax call
		var data = {
				action:'cil_edit_item',
				id: jQuery(this).find('.cil_hidden_list_item_id').val(),
				heading: jQuery(this).find('#cil_item_heading').val(),
				imageUrl: jQuery(this).find("#cil_item_imageUrl").val(),
				url: jQuery(this).find("#cil_item_headingUrl").val(),
				listId: jQuery(this).find('.cil_hidden_list_id').val(),
				content: jQuery(this).find("#cil_item_content").val()
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
					image = "<img class='cil_item_image' src='"+ cilItemImageIcon.attr('src') +"' alt='"+ data['imageUrl'] +"' title='This item has an image' width='15' height='15' />";
				}

				cilItemList.append(
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
				var newItem = cilItemWrapper.find('#cil-list_item_'+ data['id']);

				newItem.find('.cil_item_edit_btn').bind('click',editItemButtonHandler);
				newItem.find('.cil_hide_btn').bind('click',hideButtonHandler);
				newItem.find('.cil_item_delete_btn').bind('click',deleteItemButtonHandler);

				var h3 = cilItemWrapper.find('#cil_no_items');
				if(h3.length > 0)
				{
					h3.remove();
				}

			}else{//if the list item exists and it's just being edited, change the values in the main list to match the edits
				var list = cilItemList.find("#cil-list_item_" + data['id']);

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
						list.find('.cil_hide_btn').after("<img class='cil_item_image' src='"+ cilItemImageIcon.attr('src') +"' alt='"+ data['imageUrl'] +"' title='This item has an image' width='15' height='15' />");
					}else{//if the icon already exists, just change the alt attribute to match the new values
						list.find('.cil_item_image').attr('alt', data['imageUrl']);
					}
				}else{//if there is no image url in the return go ahead and remove the image icon
					list.find('.cil_item_image').remove();
				}

				list.find('.cil_item_heading span')
					.html(choppedHeading)
					.attr('title',data['heading']);

				list.find('.cil_item_content')
					.html(data['content']);
			}

			//close the form
			closeEditListForm(editItemForm);

			//clear form
			clearItemForm();

			//change submit button label back to the default value
			changeItemSubmitLabel("Create a New Item");

		});
	});

	/////////////////////////////////////////////////
	//											   //
	//				helper functions			   //
	//										       //
	/////////////////////////////////////////////////

	//////////////change submit button label///////////////
	function changeSubmitLabel(label){
		formListSubmit.val(label);
	}

	//////////////change submit button label///////////////
	function changeItemSubmitLabel(label){
		formItemSubmit.val(label);
	}

	///////////////expand the given form/////////////////
	function expandEditListForm(form)
	{
		form.animate(
				{height:'500px'},
				350,
				function(){
					jQuery(this).css({height:'auto'});
				});
	}

	/////////////////close the given form////////////////////
	function closeEditListForm(form)
	{
		editListItemButton.fadeOut(200);
		form.animate(
				{height:'0px'},
				350);
	}

	//hide the button that shows the edit item menu
	function showItemEditButton()
	{
		editListItemButton.fadeIn(200);
	}

	//////////////////hide item edit panel///////////////////
	function hideItemEdit()
	{
		cilItemWrapper.hide();
		clearItemForm();
	}

	//show the item edit panel
	function showItemEdit()
	{
		cilItemWrapper.fadeIn(200);
	}

	////////////clear edit list form//////////////
	function clearItemForm(){
		formItemHeading.val("");
		formItemContent.val("");
		formItemImageUrl.val("");
		formItemHeadingUrl.val("");
		editListForm.find('.cil_error').html('');
		editItemForm.find('#cil_preview_item_image').attr('src',"");
		editItemForm.find('.cil_hidden_list_item_id').val("");
	}

	////////////clear edit list form//////////////
	function clearForm(){
		formListName.attr("value", "");
		formListDescription.val("");
		formListIconUrl.attr("value", "");
		formListLogoUrl.attr("value", "");
		editListForm.find(".cil_hidden_list_id").val("");
		editListForm.find('.cil_error').html('');
		editListForm.find('#cil_preview_logo').attr('src',"");
		editListForm.find('#cil_preview_icon').attr('src',"");
	}

	/////////////////chops heading to fit in the list nicely///////////////////
	function chopHeading(item,maxChars)
	{
		return item.slice(0,maxChars);
	}
});