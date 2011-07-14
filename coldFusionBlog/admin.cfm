<cfsetting showdebugoutput="false" >



<cfparam name="edit_post_id" type="string" default="">
<cfparam name="error" type="string" default="">

<!---get vars--->
<cfparam name="url.add" type="string" default="">
<cfparam name="url.category" type="string" default="">
<cfparam name="url.tag" type="string" default="">
<cfparam name="url.add_post" type="boolean" default="false">
<cfparam name="url.edit_post" type="string" default="">
<cfparam name="url.sort_by_category" type="string" default="">
<cfparam name="url.sort_by_tag" type="string" default="">
<cfparam name="url.view_post" type="string" default="">
<cfparam name="url.page" type="string" default="1">
<cfparam name="url.login" type="string" default="false">
<cfparam name="url.login_error" type="string" default="false">

<!---post form input--->
<cfparam name="form.title" type="string" default="">
<cfparam name="form.form_content" type="string" default="">
<cfparam name="form.category" type="string" default="">
<cfparam name="form.tags" type="string" default="">
<cfparam name="form.button" type="string" default="">

<!--- constants --->
<cfparam name="posts_per_page" type="numeric"  default="4">

<cfset application.model.protect_page(session)>

<cfset posts_per_page = 8 >



<cfscript>
	//post vars
	title = form.title;
	content = form.form_content;
	category = form.category;
	tags = listToArray(form.tags,",");
	error_message = "";
	
	session.add_post = url.add_post; 
	
</cfscript>


<!---get tags and categories--->

<cfset all_categories = application.model.get_all_categories()>

<cfset all_tags = application.model.get_all_tags().all_tags>
	
<cfset high_tag_count = application.model.get_all_tags().high_tag_count>

<!---get posts--->
<cfset posts = application.model.get_all_posts(url,#url.sort_by_tag#,#url.sort_by_category#,posts_per_page).posts>
<cfset post_count = application.model.get_all_posts(url,#url.sort_by_tag#,#url.sort_by_category#,posts_per_page).count>


<!---edit post variables, placed into form field and button name changed to add if there is a get vale edit_post--->
<cfif url.edit_post neq "">
	
	<cfset edit_post_info = application.model.get_edit_post_info(url.edit_post,posts)>
	
	<cfset edit_post_tags = application.model.get_edit_post_tags(url.edit_post)>
	
	<cfscript>
		title = edit_post_info.post_title;
		content = edit_post_info.post_content;
		category = edit_post_info.post_category_id;
		edit_post_id = edit_post_info.post_id;
	</cfscript>
	
</cfif>

<cfoutput >

		<cfset application.view.show_head(session,"admin")>
				
		<cfset application.view.show_edit_add_nav()>
		
		<cfif url.add_post eq true>
			<cfif url.edit_post eq "">
				<cfset application.view.show_edit_add_form(all_categories,all_tags,title,content,category)>
			<cfelse>
				<cfset application.view.show_edit_add_form(all_categories,all_tags,title,content,category,edit_post_id,edit_post_tags,error)>
			</cfif>
		
		<cfelse> <!---if add_post eq true--->
			<cfset application.view.show_sort_by_menu(all_tags,all_categories,"admin.cfm")>
			<cfset application.view.show_admin_post_list(posts)>
			<cfset application.view.show_blogroll_pagination(post_count,posts_per_page,"admin.cfm")>
		
		</cfif>	<!---if add_post eq true--->	
	
		<cfset application.view.show_admin_category_block(all_categories)>
		
		<cfset application.view.show_admin_tag_block(all_tags,high_tag_count)>
			
		<cfset application.view.show_footer()>
</cfoutput>