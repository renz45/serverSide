jQuery(document).ready(function() {

	////////////////////////////////////////////////////////////
	//														  //
	//				frequently usedpage Elements			  //
	//														  //
	////////////////////////////////////////////////////////////
	var cilItemWrapper = jQuery('#cil_item_wrap');

	var cilItemList = cilItemWrapper.find('.cil_admin_list_items');

	var editItemForm = cilItemWrapper.find("#cil_edit_item_form");
	var formItemHeading = editItemForm.find("#cil_item_heading");
	var formItemContent = editItemForm.find("#cil_item_content");
	var formItemImageUrl = editItemForm.find("#cil_item_imageUrl");
	var formItemHeadingUrl = editItemForm.find('#cil_item_headingUrl');
	var formItemSubmit = editItemForm.find('#cil_newItemSubmit');

	var cilItemImageIcon = editItemForm.find('#cil_item_imageIcon');

	////////////////////////////////////////////////////////////
	//														  //
	//						  Bindings						  //
	//														  //
	////////////////////////////////////////////////////////////

	////////expand the form when the add new list button is pressed/////////
	cilItemWrapper.find("#create_new_item_header").bind('click',function(){


		if(editItemForm.css('height') == "0px" || formItemSubmit.val() != "Create a New Item")
		{
			state_newListItemForm();
		}else{
			state_startScreen();
		}
	});

	///////////list edit button functionality////////////
	cilItemWrapper.find(".cil_item_edit_btn").bind('click',editItemButtonHandler);

	function editItemButtonHandler(){
		var name = jQuery(this).parent().find(".cil_item_heading span").attr('title');

		//expand the edit menu if it's closed
		state_editListItemForm();

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
		state_startScreen();
	});

	////////////Ajax hide List////////////////
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

			state_startScreen();

		});
	});

	/////////////////update image preview///////////////////
	formItemImageUrl.bind('change keyup',function(){
		editItemForm.find('#cil_preview_item_image').attr('src', jQuery(this).val());
	});

	/////////////////////reorganize item list///////////////////
	cilItemList.sortable().disableSelection().bind('sortupdate',function(){

		var itemIds = jQuery(this).sortable('toArray').join("").split('cil-list_item_');

		var data = {
				action:'cil_set_order_of_items',
				idArray: itemIds.join('%') //basic serialization for the array of item ids
		};

		//send array of list item ids
		jQuery.post(ajaxurl, data);

	});


	/////////////////////////////////////////////////
	//											   //
	//				helper functions			   //
	//										       //
	/////////////////////////////////////////////////

	/////////////clear edit list form//////////////
	function clearItemForm(){
		formItemHeading.val("");
		formItemContent.val("");
		formItemImageUrl.val("");
		formItemHeadingUrl.val("");
		cilItemWrapper.find('.cil_error').html('');
		editItemForm.find('#cil_preview_item_image').attr('src',"");
		editItemForm.find('.cil_hidden_list_item_id').val("");
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
		form.animate(
				{height:'0px'},
				350);
	}

	/////////////////////////////////////////////////
	//											   //
	//				 View States 				   //
	//										       //
	/////////////////////////////////////////////////

	///////////////Start screen, only lists will be shown//////////
	function state_startScreen()
	{
		closeEditListForm(editItemForm);

		//clear form
		clearItemForm();

		//change submit button label
		changeItemSubmitLabel("Create a New Item");
	}

	////////////show form for creating a new list item, clear values///////////
	function state_newListItemForm()
	{
		expandEditListForm(editItemForm);


		//clear form
		clearItemForm();

		//change submit button label
		changeItemSubmitLabel("Create a New Item");
	}

	////////////show form for editing a list item, don't clear values/////////
	function state_editListItemForm()
	{

		//open list edit form
		expandEditListForm(editItemForm);
	}
});