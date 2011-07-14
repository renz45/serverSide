<cfsetting showdebugoutput="false" >


<cfparam name="edit_post_id" type="string" default="">
<cfparam name="error" type="string" default="">

<!---get vars--->

<cfparam name="url.category" type="string" default="">
<cfparam name="url.tag" type="string" default="">
<cfparam name="url.sort_by_category" type="string" default="">
<cfparam name="url.sort_by_tag" type="string" default="">
<cfparam name="url.view_post" type="string" default="">
<cfparam name="url.page" type="string" default="1">
<cfparam name="url.login" type="string" default="false">
<cfparam  name="url.login_error" type="string" default="false">

<!--- constants --->
<cfparam name="posts_per_page" type="numeric"  default="4">


<!---get tags and categories--->

<cfset all_categories = application.model.get_all_categories()>

<cfset all_tags = application.model.get_all_tags().all_tags>
	
<cfset high_tag_count = application.model.get_all_tags().high_tag_count>

<!---get posts--->
<cfset posts = application.model.get_all_posts(url,#url.sort_by_tag#,#url.sort_by_category#,posts_per_page).posts>
<cfset posts_count = application.model.get_all_posts(#url.sort_by_tag#,#url.sort_by_category#).count>

<cfoutput><!--- beginning of html --->

	<cfset application.view.show_head(session,"index")>
	
	<cfset application.view.show_index_col1(posts,posts_count,posts_per_page,posts,all_tags,all_categories)>

	<cfset application.view.show_index_col2(all_categories,all_tags,high_tag_count)>		
		
	<cfset application.view.show_footer()>
</cfoutput><!--- end of html --->