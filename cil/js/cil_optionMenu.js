jQuery(document).ready(function() {
	////////////////////////////////////////////////////////////
	//														  //
	//				frequently used page Elements			  //
	//														  //
	////////////////////////////////////////////////////////////
	var cilListWrapper = jQuery('#cil_wrap');
	var cilItemWrapper = jQuery('#cil_item_wrap');

	var cilListList = cilListWrapper.find('.cil_admin_list');
	var cilItemList = cilItemWrapper.find('.cil_admin_list_items');

	var createNewListButton = cilListWrapper.find("#cil_create_new_list_header");
	var editListItemButton = cilListWrapper.find('#cil_edit_list_items');
	var editTemplateButton = cilListWrapper.find('#cil_edit_template');

	var editListForm = cilListWrapper.find("#cil_edit_List_form");
	var formListName = editListForm.find("#cil_listName");
	var formListDescription = editListForm.find("#cil_listDescription");
	var formListIconUrl = editListForm.find("#cil_iconUrl");
	var formListLogoUrl = editListForm.find("#cil_logoUrl");
	var formListSubmit = editListForm.find('.#cil_newListSubmit');

	var editListItemTitle = jQuery('#cil_listItemsFor');

	var editItemForm = cilItemWrapper.find("#cil_edit_item_form");
	var formItemHeading = editItemForm.find("#cil_item_heading");
	var formItemContent = editItemForm.find("#cil_item_content");
	var formItemImageUrl = editItemForm.find("#cil_item_imageUrl");
	var formItemHeadingUrl = editItemForm.find('#cil_item_headingUrl');
	var formItemSubmit = editItemForm.find('#cil_newItemSubmit');

	var editTemplateForm = cilListWrapper.find('#cil_edit_list_template');

	var cilItemImageIcon = editItemForm.find('#cil_item_imageIcon');



	////////////////////////////////////////////////////////////
	//														  //
	//						bindings						  //
	//														  //
	////////////////////////////////////////////////////////////

	//////////expand the form when the add new list button is pressed/////////
	createNewListButton.bind('click',function(){

		if(editListForm.css('height') == "0px" || formListSubmit.val() != "Create a New List")
		{
			state_newListForm();
		}else if(formListSubmit.val() == "Create a New List"){
			state_startScreen();
		}
	});

	///////////////////edit list cancel button////////////////////
	editListForm.find('#cil_cancel_button').bind('click',function(){
		state_startScreen();
	});

	///////////////////edit list item button////////////////////
	editListItemButton.bind('click',function(){

		//toggle hide and show of the item edit window
		if(cilItemWrapper.css('display') == 'none')
		{
			state_editListItems();
		}else{
			state_editListForm();
		}
	});

	///////////////////edit list template button////////////////////
	editTemplateButton.bind('click', function(){
		if(editTemplateForm.css('display') == 'none')
		{
			state_editTemplate();
		}else{
			state_editListForm();
		}
	});

	////////////////////////submit for form edit template////////////////
	editTemplateForm.bind('submit',function(event){
		event.preventDefault();
		var data = {action:'cil_edit_list_template',
					id:editListForm.find('.cil_hidden_list_id').val(),
					template:editTemplateForm.find('#cil_templateTextarea').val()};

		//send the information via ajax
		jQuery.post(ajaxurl, data,function(r){
			state_editListForm();
		});
	});

	///////////////////cancel button on the edit template form/////////////////
	editTemplateForm.find('#cil_cancelTemplate_button').bind('click',function(){
		state_editListForm();
	});

	///////////////list edit button functionality////////////
	cilListWrapper.find("ul li .cil_list_edit_btn").bind('click',editButtonHandler);
	// this is a seperate function so it can be rebound to newly created buttons
	function editButtonHandler(){
		var name = jQuery(this).parent().find(".cil_list_name span").html();

		var thisId =  jQuery(this).parent().attr('id').split("cil-list_")[1];

		state_editListForm();

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
				id: editListForm.find('.cil_hidden_list_id').val()
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
			var emptyMsg = cilItemWrapper.find('#cil_no_items');
			if(r.length > 0)
			{
				emptyMsg.remove();
			}
		});//end ajax call for loading list items

		var data = {
				action:'cil_get_template',
				id: thisId
		};

		//make an ajax call to get the template for the selected list
		jQuery.post(ajaxurl, data,function(r){
			//add template text to the template form
			r = jQuery.parseJSON(r);

			editTemplateForm.find('#cil_templateTextarea').val("").val(r['template']);
		});
	}

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

		var c = true;

		console.log(jQuery(this).parent().find('>ul>li').length);

		var nestedCount = jQuery(this).parent().find('>ul>li').length;

		if(nestedCount > 0)
		{
			c = confirm("Deleting this list item will result in the deletion of "+ nestedCount + " other nested\n list"+ (nestedCount > 1?"s":"") +" and items that " + (nestedCount > 1?"they":"it") + " contain"+(nestedCount > 1?"":"s")+", are you sure you want to delete?");
		}

		if(c == true)
		{

			thisId = jQuery(this).parent().attr('id').split("cil-list_")[1];

			var data = {
					action:'cil_delete_list',
					id: thisId
			};

			//close the list edit form if the deleted list is the one being edited

			var currentlyBeingEditedId = editListForm.find('.cil_hidden_list_id').val();

			console.log(jQuery(this).parent().find('>ul #cil-list_' + currentlyBeingEditedId).length);

			if(currentlyBeingEditedId == thisId || jQuery(this).parent().find('>ul #cil-list_' + currentlyBeingEditedId).length > 0)
			{
				state_startScreen();
			}

			//delete list from the database
			jQuery.post(ajaxurl, data,function(r){
				//remove the item from the list
				jQuery("#cil-list_"+r).remove();
			});
		}
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

			//return an error message if that list name is already in use.
			if(r == 0)
			{
				editListForm.find('.cil_error').fadeIn().html('A list with this name already exists, please choose another');
				return ;
			}

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
				"<ul></u>"+
				"</li>\n");

				//rebind click handlers to the buttons in the new list item, this is done automatically on page reload, but this is for when a list item is
				//initally created so the page doesn't have to reload in order to get functionality
				var newItem = cilListWrapper.find('ul #cil-list_'+ data['id']);

				newItem.find('.cil_list_edit_btn').bind('click',editButtonHandler);
				newItem.find('.cil_pin_btn').bind('click',pinButtonHandler);
				newItem.find('.cil_list_delete_btn').bind('click',deleteButtonHandler);

				//add droppable functionality
				makeNestable(newItem);

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

			state_startScreen();

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
	formItemImageUrl.bind('change keyup',function(){
		editItemForm.find('#cil_preview_item_image').attr('src', jQuery(this).val());
	});

	///////////////////limit the list name so it's not too big to fit on the menu bar////////////////
	formListName.bind('change keyup', function(e){
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
	cilItemWrapper.find("#create_new_item_header").bind('click',function(){
			if(editItemForm.css('height') == "0px" || formItemSubmit.val() != "Create a New Item")
			{
				state_newListItemForm();
			}else if(formItemSubmit.val() == "Create a New Item"){
				state_editListItems();
			}
		});

	///////////list edit button functionality////////////
	cilItemWrapper.find(".cil_item_edit_btn").bind('click',editItemButtonHandler);

	function editItemButtonHandler(){
		var name = jQuery(this).parent().find(".cil_item_heading span").attr('title');

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
		state_editListItems();
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

	//////////////Ajax delete item//////////////
	cilItemList.find(".cil_item_delete_btn").bind('click',deleteItemButtonHandler);
	//delete an item
	function deleteItemButtonHandler(){

		var thisId = jQuery(this).parent().attr('id').split("cil-list_item_")[1];

		var data = {
				action:'cil_delete_listItem',
				id: thisId
		};

		//close the edit form if the item being edited is deleted
		if(editItemForm.find('.cil_hidden_list_item_id').val() == thisId)
		{
			state_editListItems();
		}

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

			state_editListItems();

		});
	});

	/////////////////////reorganize item list///////////////////
	cilItemList.sortable().disableSelection().bind('sortupdate',function(){

		var itemIds = jQuery(this).sortable('toArray').join("").split('cil-list_item_');

		var data = {
				action:'cil_set_order_of_items',
				idArray: itemIds.join('%') //basic serialization for the array of item ids
		};

		jQuery.post(ajaxurl, data);

	});

	///////////////////////////Nest lists within each other/////////////////

	//cilListList

	var dropDelay = 1200; //delay before drop is enabled
	var hoverTimer = "";
	var rdyToDrop = false;

	cilListList.sortable().bind('sortupdate',function(){
		//if the item wasn't dropped into another list, update the list order
		if(rdyToDrop == false)
		{
			var listIds = cilListList.sortable('toArray').join("").split('cil-list_');
			updateListIndexs(listIds);
		}
	});



	//////////////////////code to create the nestable list, an item must be held over the ////////////////
	/////////////////////list for the time designated by the hoverTimer variable above////////////////////
	makeNestable(cilListList.find('>li'));

	//adds all the nesting functionality
	function makeNestable(item)
	{


		//setup sortable
		item.find('>ul')
		.sortable()
			.bind('sortupdate',function(e){
				e.stopPropagation();
				var listIds = jQuery(this).sortable('toArray').join("").split('cil-list_');
				updateListIndexs(listIds);
			})
		.find('>li').bind('dblclick',itemDblClick_callback);


		//setup droppable
		item.droppable({
			drop: function( e, ui ) {
				var item = jQuery( this );

				dropDefault(jQuery(this));//set default styles back to normal

				//make sure the item isnt from within another nested list or a list with nested items
				if(jQuery(ui.draggable).parent()[0] != cilListList[0] || jQuery(ui.draggable).find('>ul>li').length > 0)
				{
					//return if the item is already in the list, fixes sortable errors
					return this;
				}else if(rdyToDrop == false)//if the rdyToDrop flag isnt set than return early
				{
					return this;
				}

				var list = jQuery(this).find('>ul');
				var dropped = ui.draggable;

				var data = {
						action:'cil_set_nested_list_id',
						id: jQuery(dropped).attr('id').split("cil-list_")[1],
						nestedId: jQuery(this).attr('id').split("cil-list_")[1],
						index: jQuery(this).find(">ul>li").length + 1
				};
				//ajax call to set the nestIn_id and list_index to the last item in the nested list
				jQuery.post(ajaxurl, data,function(r){
					dropped.hide( "fast", function() {

						jQuery(this)
							.droppable('disable')//disable droppable so we can't drop anything in a nested item
							.prepend("<span class='cil_up_arrow'>&uarr;</span>")//insert the arrow at the beginning of the li
							.find('.cil_pin_btn')//hide the pin button while items are nexted, they will pin with their parent list
								.hide();
						// had to split this up, for some reason there was a bug where lists were following each other back into nested status
						jQuery(this)
							.appendTo(list)//append this li to the nested ul of another list
							.show('fast')
							.bind('dblclick',itemDblClick_callback);

						var listIds = list.sortable('toArray').join("").split('cil-list_');
						updateListIndexs(listIds);
					});
				});//end ajax post
			}
		})

		//mouse down, set the rdyTo Drop flag to false, this starts the drop timer back to 0
		.bind('mousedown',function()
		{
			rdyToDrop = false;
			dropDefault(jQuery(this));
		})

		//mouse down, set the rdyTo Drop flag to false, this starts the drop timer back to 0
		.bind('mouseup',function()
		{
			clearInterval(hoverTimer);
			//reset all list items border and height back to default, fixes a bug where lists were getting stuck in the drop ready state

			dropDefault(jQuery(this));

		})
		.bind('dropover',function(e,ui){//when an item is over a droppable, count to 2 secs and enable insertion, this fixes the glitchiness with sortable and the dropable
				var item = jQuery(this);


				//test to make sure the item isn't nested
				if(ui.draggable.parent()[0] == cilListList[0])
				{
					clearInterval(hoverTimer);//clear interval before a new one is started, fixes a problem where the timer wasn't getting cleared other ways

					hoverTimer = setInterval(function(){
						rdyToDrop = true; //set ready to drop to true, this enables the dropable to take in the sortable
						clearInterval(hoverTimer);//clear the timer after it fires, keeps it from repeating(Although, it should stop automatically, but it doesn't)

						dropReady(item);

					}, dropDelay);//interval in milliseconds
				}

		})
		.bind('dropout',function(){//when an item moves out of a droppable, reset the timer

				rdyToDrop = false;//set the ready to drop flag back to false so the process can start over with the new item

				dropDefault(jQuery(this));
		});
	}//end make droppable

	///////////////////callback for nested item doubleclick/////////////////
	function itemDblClick_callback(e)
	{
		var item = this;
		var data = {
				action:'cil_set_nested_list_id',
				id: jQuery(this).attr('id').split("cil-list_")[1],
				nestedId: null,
				index:cilListList.find('>li').length + 1};

			//ajax call to remove an item from the nested list
			jQuery.post(ajaxurl, data,function(r){

				var listIds = cilListList.sortable('toArray').join("").split('cil-list_');
				updateListIndexs(listIds);

				jQuery(item)
					.unbind('dblclick')//unbind doubleclick since the item has been removed
					.hide('fast',function(){
						jQuery(this)
							.appendTo(cilListList)//append this item back to the main list
							.show('fast',function(){
								jQuery(this).droppable('enable');//enable droppable again since the item isnt nested anymore
							})//show
							.find('.cil_pin_btn')//show the pin button again
								.show()
								.parent()
							.find('.cil_up_arrow')//remove the arrow
								.remove();
					});//hide
			});//end ajax post
	}

	//////////////////////updates list indexes for nested lists or the main list/////////////////
	function updateListIndexs(listIds)
	{
		var data = {
				action:'cil_set_order_of_lists',
				idArray: listIds.join('%') //basic serialization for the array of item ids
		};

		jQuery.post(ajaxurl, data);
	}

	/////////////////////set li css to the drop ready status//////////////////
	function dropReady(item)
	{
		item.height(function(index,height){return height += 25;})
		.css({'border-color':'#faa','border-style':'dashed'});
	}

	/////////////////////revert li css back to normal////////////////////////
	function dropDefault(item)
	{
		item.css({'height':'auto',
			'border-style':'solid',
			'border-top-color':'#fff',
			'border-left-color':'#fff',
			'border-bottom-color':'#ddd',
			'border-right-color':'#ddd'});
	}


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

		form.animate(
				{height:'0px'},
				350);
	}

	///////////////////////show the button that shows the edit item menu///////////////////////
	function showItemEditButton()
	{
		editListItemButton.fadeIn(200);
	}
	///////////////////////hide the button that shows the edit item menu///////////////////////
	function hideItemEditButton()
	{
		editListItemButton.fadeOut(200);
	}

	/////////////////////show button that displays the edit template form///////////////////
	function showTemplateButton()
	{
		editTemplateButton.fadeIn(200);
	}

	/////////////////////hide button that displays the edit template form///////////////////
	function hideTemplateButton()
	{
		editTemplateButton.fadeOut(200);
	}

	//////////////////hide item edit panel///////////////////
	function hideItemEdit()
	{
		cilItemWrapper.hide(200);
		clearItemForm();
		closeEditListForm(editItemForm);
	}

	///////////////show the item edit panel////////////////
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

	////////////////insert text into a textarea at the caret///////////////////
	//I never ended up using this, I might use it in the future to inject tags by clicking a button
	function insertAtCaret(myValue,textArea)
	{//replace textArea with this if it goes into a jquery plugin
		if (document.selection)
		{
			textArea.focus();
			sel = document.selection.createRange();
			sel.text = myValue;
			textArea.focus();
		}
		else if(textArea.selectionStart || textArea.selectionStart == '0') {
		    var startPos = textArea.selectionStart;
		    var endPos = textArea.selectionEnd;
		    var scrollTop = this.scrollTop;
		    textArea.value = textArea.value.substring(0, startPos)+myValue+this.value.substring(endPos,textArea.value.length);
		    textArea.focus();
		    textArea.selectionStart = startPos + myValue.length;
		    textArea.selectionEnd = startPos + myValue.length;
		    textArea.scrollTop = scrollTop;
		}else{
			textArea.value += myValue;
			textArea.focus();
		}
	}

	/////////////////////////////////////////////////
	//											   //
	//				 View States 				   //
	//										       //
	/////////////////////////////////////////////////

	///////////////Start screen, only lists will be shown//////////
	function state_startScreen()
	{
		closeEditListForm(editListForm);

		//hide item list if its up
		hideItemEdit();

		//clear form
		clearForm();

		//fadeout the list edit item title
		editListItemTitle.fadeOut(200);

		hideItemEditButton();
		hideTemplateButton();

		editTemplateForm.fadeOut(200);

		//change submit button label
		changeSubmitLabel("Create a New List");
	}
	///////////////show only the edit list form, clear out all values and set button to 'create new list'/////////////
	function state_newListForm()
	{
		expandEditListForm(editListForm);

		//hide item list if its up
		hideItemEdit();

		//clear form
		clearForm();

		//fadeout the list edit item title
		editListItemTitle.fadeOut(200);

		hideItemEditButton();
		hideTemplateButton();

		editTemplateForm.fadeOut(200);

		//change submit button label
		changeSubmitLabel("Create a New List");
	}

	///////////show the edit list form, but don't clear it///////////////
	function state_editListForm()
	{
		expandEditListForm(editListForm);
		hideItemEdit();
		editListItemTitle.fadeOut(200);
		editTemplateForm.fadeOut(200);
		showItemEditButton();
		showTemplateButton();
	}

	///////////show list items contained in corrently edited list//////////////
	function state_editListItems()
	{
		//close edit list form
		closeEditListForm(editListForm);

		//close editItemForm
		closeEditListForm(editItemForm);

		showItemEdit();

		editTemplateForm.fadeOut(200);

		if(formListName.val() != "")
		{
			editListItemTitle.fadeIn(200).find('span').html(formListName.val());
		}else{
			editListItemTitle.fadeIn(200);
		}
	}

	////////////show form for creating a new list item, clear values///////////
	function state_newListItemForm()
	{
		if(editItemForm.css('height') == "0px")
		{
			expandEditListForm(editItemForm);
		}

		//clear form
		clearItemForm();

		//change submit button label
		changeItemSubmitLabel("Create a New Item");
	}

	////////////show form for editing a list item, don't clear values/////////
	function state_editListItemForm()
	{
		//close edit list form
		closeEditListForm(editListForm);
		//open list edit form
		expandEditListForm(editItemForm);
	}

	//////////////show edit template view/////////////////
	function state_editTemplate()
	{
		closeEditListForm(editListForm);

		hideItemEdit();
		editListItemTitle.fadeOut(200);

		if(formListName.val() != "")
		{
			editTemplateForm.fadeIn(200).find('label span').html(formListName.val());
		}else{
			editTemplateForm.fadeIn(200);
		}

	}
});