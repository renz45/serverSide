<cfsetting showdebugoutput="false" >

<cfimport taglib="/cfspec">

<describe hint="Model for my Blog">
	<before>
		<cfset model = new _model("blog")>
	</before>
	
	<it should="be an object">
		<cfset $(model).shouldBeObject()>
	</it>
	
	<describe hint="get_all_categories">
		<it should="return a query">
			<cfset $(model).get_all_categories().shouldBeQuery()>
		</it>
		
		<it should="have the correct columns">
			<cfset $(model.get_all_categories().columnList).shouldEqual("CATEGORY_COUNT,CATEGORY_ID,CATEGORY_NAME")>
		</it>
			
	</describe> <!---end get_all_categories--->
	
	<describe hint="get_all_tags">
		<it should="return a structure">
			<cfset $(model).get_all_tags().shouldBeStruct()>
		</it>
		
		<it should="have the correct keys '{high_tag_count,all_tags}'">
			<cfset $( structKeyList(model.get_all_tags())).shouldEqual("HIGH_TAG_COUNT,ALL_TAGS")>
		</it>
		<describe hint="returned structure">
			<it should="be numeric for structure.high_tag_count">
				<cfset $(model.get_all_tags().high_tag_count).shouldBeNumeric()>
			</it>
			
			<it should="be query for structure.all_tags">
				<cfset $(model.get_all_tags().all_tags).shouldBeQuery()>
			</it>
			<describe hint="all_tags query">
					<it should="have the correct columns">
						<cfset $(model.get_all_tags().all_tags.columnList).shouldEqual("TAG_COUNT,TAG_ID,TAG_NAME")>
					</it>
			</describe>
		</describe>	
	</describe><!---end get_all_tags--->
	
	<describe hint="get_all_posts">
		<cfset url = structNew()>
		<cfset url.view_post = 1>
		<cfset url.page = 1>
		<cfset url.sort_by_category = "">
		<cfset url.sort_by_tag = "">
		
		<it should="return a structure">
			<cfset $(model).get_all_posts(url).shouldBeStruct()>
		</it>
		
		<it should="have the correct keys '{posts,count}'">
			<cfset $( structKeyList(model.get_all_posts(url))).shouldEqual("POSTS,COUNT")>
		</it>
		<describe hint="returned structure">
			<it should="be numeric for structure.post_count">
				<cfset $(model.get_all_posts(url).count).shouldBeNumeric()>
			</it>
			
			<it should="be query for structure.posts">
				<cfset $(model.get_all_posts(url).posts).shouldBeQuery()>
			</it>
			<describe hint="posts query">
					<it should="have the correct columns">
						<cfset $(model.get_all_posts(url).posts.columnList).shouldEqual("CATEGORY_NAME,POST_CATEGORY_ID,POST_CONTENT,POST_DATE_POSTED,POST_ID,POST_TITLE,POST_USER_ID,USERS_NAME")>
					</it>
			</describe>
		</describe>	
	</describe><!---end get_posts--->
	
	<describe hint="get_edit_post_info">
		<cfset edit_post = 2>
		<cfset url = structNew()>
		<cfset url.view_post = 1>
		<cfset url.page = 1>
		<cfset url.sort_by_category = "">
		<cfset url.sort_by_tag = "">
		<cfset model = new _model('blog')>
		<cfset posts = model.get_all_posts(url).posts >
		<it should="return a query">
			<cfset $(model).get_edit_post_info(2,posts).shouldBeQuery()>
		</it>
		
		<it should="have the correct columns">
			<cfset $(model.get_edit_post_info(2,posts).columnList).shouldEqual("CATEGORY_NAME,POST_CATEGORY_ID,POST_CONTENT,POST_DATE_POSTED,POST_ID,POST_TITLE,POST_USER_ID,USERS_NAME")>
		</it>
			
	</describe> <!---end get_edit_post_info--->
	
	<describe hint="get_edit_post_tags">
		<it should="return a query">
			<cfset $(model).get_edit_post_tags(2).shouldBeQuery()>
		</it>
		
		<it should="have the correct columns">
			<cfset $(model.get_edit_post_tags(2).columnList).shouldEqual("TAG_ID")>
		</it>
	</describe>
	
	
	<describe hint="modify_category_tag">
		<cfset add_test_text = "ADD_model_spec_TEST1283123897123">
		<cfset delete_test_text = "DELETE_model_spec_TEST19877327878">
		<cfset modify_test_text = "MODIFY_model_spec_TEST1178236768123">
		<cfset modify_to_test_text = "MODIFY_TO_model_spec_TEST5123582133">
		
		<cfset form.add_category = "" >
		<cfset url.delete_category = "" >
		<cfset form.edit_category = "" >
		<cfset form.add_tag = "" >
		<cfset url.delete_tag= "" >
		<cfset form.edit_tag = "" >
		<cfset form.button = "Add" >
		<cfset session.add_post = false>
		
		<!--- categories --->
		<before>
		
			<cfset form.add_category = #add_test_text# >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds category --->
			<cfset form.add_category = "" >
		
		</before>
		<it should="add new category">
			<cfquery datasource="asl1009" name="check_for_test_cat_add">
				SELECT category_name FROM rensel_categories WHERE category_name = '#add_test_text#'
			</cfquery>
			<cfset $(check_for_test_cat_add.category_name).shouldEqual(#add_test_text#) >
			
		</it>
		<after>
			
			<cfquery datasource="asl1009">
				DELETE FROM rensel_categories WHERE category_name = '#add_test_text#'
			</cfquery>
			
		</after>
		
		<before>
		
			<cfset form.add_category = #delete_test_text# >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds category(to test for delete) --->
			<cfquery datasource="asl1009" name="category_to_delete_id">
				SELECT category_id FROM rensel_categories WHERE category_name = '#delete_test_text#'
			</cfquery>
			
			<cfset form.add_category = "" >
			<cfset url.delete_category = #category_to_delete_id.category_id# >
			<cfset form.edit_category = "" >
			<cfset form.button = "" >
			
			<cfset $(model).modify_category_tag(url,form,session)><!--- deletes category --->
			<cfset url.delete_category = "" >
			<cfset form.button = "Add" >
		
		</before>
		<it should="delete a category">
			<cfquery datasource="asl1009" name="check_for_test_cat_delete">
				SELECT category_name FROM rensel_categories WHERE category_name = '#delete_test_text#'
			</cfquery>
			<cfset $(check_for_test_cat_delete.category_name).shouldEqual("") >
		</it>
		
		<before>
		
			<cfset form.add_category = #modify_test_text# >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds category(to test for modify) --->
			<cfset form.add_category = "" >
		
		</before>
		<it should="modify a category">
			
			<cfquery datasource="asl1009" name="modify_id">
				SELECT category_id FROM rensel_categories WHERE category_name = '#modify_test_text#'
			</cfquery>
			
			<cfset form.edit_category_id = #modify_id.category_id# >
			<cfset form.edit_category = #modify_to_test_text# >
			<cfset form.button = "Edit" >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds category(to test for modify) --->
			<cfset form.add_category = "" >
		
			<cfquery datasource="asl1009" name="check_for_test_cat_modify">
				SELECT category_name FROM rensel_categories WHERE category_name = '#modify_to_test_text#'
			</cfquery>
			<cfset $(check_for_test_cat_modify.category_name).shouldEqual(#modify_to_test_text#) >
		</it>
		<after>
		
			<cfquery datasource="asl1009">
				DELETE FROM rensel_categories WHERE category_name = '#modify_to_test_text#'
			</cfquery>
		
		</after>
		
		<!--- tags --->
		<before>
		
			<cfset form.add_category = "" >
			<cfset form.add_tag = #add_test_text# >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds tag --->
		
		</before>
		<it should="add new tag">
			<cfquery datasource="asl1009" name="check_for_test_tag_add">
				SELECT tag_name FROM tags WHERE tag_name = '#add_test_text#'
			</cfquery>
			<cfset $(check_for_test_tag_add.tag_name).shouldEqual(#add_test_text#) >
			
		</it>
		<after>
			
			<cfquery datasource="asl1009">
				DELETE FROM tags WHERE tag_name = '#add_test_text#'
			</cfquery>
		
		</after>
		
		
		<before>
		
			<cfset form.button = "" >
			<cfset form.add_tag = #delete_test_text# >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds category(to test for delete) --->
			<cfquery datasource="asl1009" name="tag_to_delete_id">
				SELECT tag_id FROM tags WHERE tag_name = '#delete_test_text#'
			</cfquery>
			
			<cfset form.add_tag = "" >
			<cfset url.delete_tag = #tag_to_delete_id.tag_id# >
			<cfset form.edit_tag= "" >
			<cfset form.button = "" >
			
			<cfset $(model).modify_category_tag(url,form,session)><!--- deletes tag --->
			<cfset url.delete_tag = "" >
			<cfset form.button = "Add" >
		
		</before>
		<it should="delete a tag">
			<cfquery datasource="asl1009" name="check_for_test_tag_delete">
				SELECT tag_name FROM tags WHERE tag_name = '#delete_test_text#'
			</cfquery>
			<cfset $(check_for_test_tag_delete.tag_name).shouldEqual("") >
		</it>
		
		<before>
		
			<cfset form.add_tag = #modify_test_text# >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds tag(to test for modify) --->
		
		</before>
		<it should="modify a tag">
		
			<cfquery datasource="asl1009" name="modify_id">
				SELECT tag_id FROM tags WHERE tag_name = '#modify_test_text#'
			</cfquery>
			
			<cfset form.edit_tag_id = #modify_id.tag_id# >
			<cfset form.edit_tag = #modify_to_test_text# >
			<cfset form.button = "Edit" >
			<cfset $(model).modify_category_tag(url,form,session)><!--- adds category(to test for modify) --->
			<cfset form.add_tag = "" >
		
			<cfquery datasource="asl1009" name="check_for_test_tag_modify">
				SELECT tag_name FROM tags WHERE tag_name = '#modify_to_test_text#'
			</cfquery>
			<cfset $(check_for_test_tag_modify.tag_name).shouldEqual(#modify_to_test_text#) >
		</it>
		<after>
			
			<cfquery datasource="asl1009">
				DELETE FROM tags WHERE tag_name = '#modify_to_test_text#'
			</cfquery>
			
		</after>
		
		<cfquery datasource="asl1009">
			DELETE FROM rensel_categories WHERE category_name = '#modify_test_text#'
		</cfquery>
		
		<cfquery datasource="asl1009">
			DELETE FROM tags WHERE tag_name = '#modify_test_text#'
		</cfquery>
	
	</describe><!---end modify_category_tag--->
	
	
	<describe hint="modify_posts">
		<cfset add_test_text = "ADD_model_spec_TEST1283123897123">
		<cfset delete_test_text = "DELETE_model_spec_TEST19877327878">
		<cfset modify_test_text = "MODIFY_model_spec_TEST1178236768123">
		<cfset modify_to_test_text = "MODIFY_TO_model_spec_TEST5123582133">
		<before>
			<cfset form.button = "Add Post" >
			<cfset form.title = #add_test_text# >
			<cfset form.form_content = "testtest" >
			<cfset form.category = "2" >
			<cfset form.tags = "" >
			
			<cfset url.delete_post = "" >
			<cfset session.user_id = 1>
			
			<!--- checking categories --->
			<cfset $(model).modify_posts(url,form,session)><!--- adds post --->
		
			
			<cfset url.delete_post = "" >
			<cfset form.title = #modify_test_text# >
			<cfset $(model).modify_posts(url,form,session)><!--- adds post(to test for modify) --->
			
			
			<cfset form.title = #delete_test_text# >
			<cfset $(model).modify_posts(url,form,session)><!--- adds posts(to test for delete) --->
			
			<cfquery datasource="asl1009" name="delete_post_id">
				SELECT post_id FROM rensel_posts WHERE post_title = '#delete_test_text#'
			</cfquery>
			<cfset form.button = "" >
			<cfset form.title = "" >
			<cfset form.form_content = "" >
			<cfset form.category = "" >
			<cfset form.tags = "" >
			<cfset url.delete_post = #delete_post_id.post_id# >
			<cfset $(model).modify_posts(url,form,session)><!--- Deletes post --->
			
			
		</before>
		<!--- categories --->
		<it should="add new post">
			<cfquery datasource="asl1009" name="check_for_test_post_add">
				SELECT post_title FROM rensel_posts WHERE post_title = '#add_test_text#'
			</cfquery>
			<cfset $(check_for_test_post_add.post_title).shouldEqual(#add_test_text#) >
			
		</it>
		
		<it should="delete a post">
			<cfquery datasource="asl1009" name="check_for_test_post_delete">
				SELECT post_title FROM rensel_posts WHERE post_title = '#delete_test_text#'
			</cfquery>
			<cfset $(check_for_test_post_delete.post_title).shouldEqual("") >
		</it>
		
		<it should="modify a post">
		
			<cfquery datasource="asl1009">
				UPDATE posts SET post_title = '#modify_to_test_text#' WHERE post_title = '#modify_test_text#'
			</cfquery>
		
			<cfquery datasource="asl1009" name="check_for_test_post_modify">
				SELECT post_title FROM rensel_posts WHERE post_title = '#modify_to_test_text#'
			</cfquery>
			<cfset $(check_for_test_post_modify.post_title).shouldEqual(#modify_to_test_text#) >
		</it>
		
		<after>
			<!--- categories --->
			<cfquery datasource="asl1009">
				DELETE FROM rensel_posts WHERE post_title = '#add_test_text#'
			</cfquery>
			
			<cfquery datasource="asl1009">
				DELETE FROM rensel_posts WHERE post_title = '#modify_to_test_text#'
			</cfquery>
			
		
		</after>
	
	</describe><!---end modify_posts--->
	
	<describe hint="get_login_info">
		<cfset form.password = "admin">
		<cfset form.username = hash("admin","MD5")>
		
		<it should="return a query">
			<cfset $(model).get_login_info(form).shouldBeQuery()>
		</it>
		
		<it should="have the correct columns">
			<cfset $(model.get_login_info(form).columnList).shouldEqual("USERS_ID,USERS_NAME")>
		</it>
			
	</describe> <!---end get_all_categories--->
	
	
</describe><!--- end _model --->
