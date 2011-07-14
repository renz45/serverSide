
<cfcomponent>


 <!---naming a function init makes this function the constructor of the component--->
<cffunction name="init" returntype="Any" >
	<cfargument name="datasource" type="string" required="true">
	
	<cfset variables.datasource = arguments.datasource>
	
	<!---constructor always has to return itself--->
	<cfreturn this>
</cffunction>


<cffunction name="protect_page" returntype="void" hint="sends the user to the homepage if they try to access a page where a login is required">
	<cfargument name="session" type="struct" required="true">
	
	<cfparam name="session.is_logged_in" type="boolean" default="false">
	
	<cfif session.is_logged_in neq true>
		<cflocation url="index.cfm" addtoken="false" >
	</cfif><!---end log in check--->
	
</cffunction> <!---end protect_page--->




<cffunction name="get_all_categories" returntype="Query" hint="I return all the category names and id's along with the count for each category">
	
	<cftry>
	
		<cfquery datasource="blog" name="local.all_categories" timeout="3">
			SELECT 
				category_name,
				category_id,
				count(p.post_category_id) AS category_count
				
			FROM categories AS c
				LEFT JOIN posts AS p ON(c.category_id = p.post_category_id)
			GROUP BY category_name,category_id
		</cfquery>
	
		<cfcatch type="database" >
			<cfset local.all_categories = queryNew("category_name,category_id,category_count")>
		</cfcatch>
	
	</cftry>
	
	<cfreturn all_categories>
</cffunction> <!---end get_all_categories--->



<cffunction name="get_all_tags" returntype="Struct"  hint="returns an assoc array with the all_tags query and high_tag_count value holding the highest tag count, along with a count of each">

	<cftry>
	
		<cfquery datasource="#variables.datasource#" name="local.all_tags">
			SELECT t.tag_name, 
				   t.tag_id,
				   count(t.tag_id) AS tag_count
			FROM tags AS t
				LEFT JOIN posts_to_tags as p ON(t.tag_id = p.tag_id)
			GROUP BY tag_name,t.tag_name
		</cfquery>
		<cfcatch type="database" >
			<cfset local.all_tags = queryNew("tag_name,tag_id,tag_count")>
		</cfcatch>
	</cftry>
	<cfset local.high_tag_count = arrayMax(listToArray(valueList(local.all_tags.tag_count)))>
	<cfreturn {all_tags = local.all_tags,high_tag_count = local.high_tag_count}>
</cffunction> <!---end get_all_tags--->




<cffunction name="get_all_posts" returntype="Struct"  hint=" returns all posts with optional arguments for sorting by tag id or category id, returns the total count of posts available in assoc array with the query {posts,count} " >
	
	<cfargument name="url_global" required="true">
	
	<cfargument name="sort_by_tag" required="false" default="">
	<cfargument name="sort_by_category" required="false" default="">
	<cfargument name="posts_per_page" required="false" type="numeric"  default=3>
	
	<cftry>
		<cfquery datasource="#variables.datasource#" name="local.all_posts">
			SELECT post_id,
				   post_title,
				   post_content,
				   post_date_posted,
				   post_user_id,
				   post_category_id,
				   u.users_name,
				   c.category_name 
			FROM posts AS p
				INNER JOIN users AS u ON(u.users_id = p.post_user_id)
				INNER JOIN categories AS c ON(c.category_id = p.post_category_id)
			<cfif url.view_post neq "">WHERE post_id = <cfqueryparam value="#url.view_post#" cfsqltype="cf_sql_integer"></cfif>
			ORDER BY post_date_posted DESC
			LIMIT #(url.page-1) * posts_per_page#,#posts_per_page#
		
		</cfquery>
		<cfcatch type="database" >
			<cfset local.all_posts = queryNew("post_id,
											   post_title,
											   post_content,
											   post_date_posted,
											   post_user_id,
											   post_category_id,
											   users_name,
											   category_name 
									")>
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfquery datasource="#variables.datasource#" name="local.posts_count">
			SELECT count(*) AS count_posts
			FROM posts AS p
				INNER JOIN users AS u ON(u.users_id = p.post_user_id)
				INNER JOIN categories AS c ON(c.category_id = p.post_category_id)
		</cfquery>
		<cfcatch type="database" >
			<cfset local.posts_count = queryNew("count_posts")>
		</cfcatch>
	</cftry>
		
	<cfset local.posts=all_posts>
	
	<cfif url.sort_by_category neq "">
		<cftry>
			<cfquery datasource="#variables.datasource#"  name="local.category_posts">
				SELECT 
				   post_id,
				   post_title,
				   post_content,
				   post_date_posted,
				   post_user_id,
				   post_category_id,
				   u.users_name,
				   c.category_name
			FROM posts AS p
				INNER JOIN users AS u ON(u.users_id = p.post_user_id)
				INNER JOIN categories AS c ON(c.category_id = p.post_category_id) AND (c.category_id = <cfqueryparam value="#url.sort_by_category#" cfsqltype="cf_sql_integer">)
			ORDER BY post_date_posted DESC
			LIMIT #(url.page-1) * posts_per_page#,#posts_per_page#
			</cfquery>
			
			<cfcatch type="database" >
				<cfset local.category_posts = queryNew("post_id,
												   post_title,
												   post_content,
												   post_date_posted,
												   post_user_id,
												   post_category_id,
												   users_name,
												   category_name 
										")>
			</cfcatch>
		</cftry>
		
		<cftry>
			<cfquery datasource="#variables.datasource#"  name="local.posts_count">
				SELECT count(*) AS count_posts
				FROM posts AS p
					INNER JOIN users AS u ON(u.users_id = p.post_user_id)
					INNER JOIN categories AS c ON(c.category_id = p.post_category_id) AND (c.category_id = <cfqueryparam value="#url.sort_by_category#" cfsqltype="cf_sql_integer" >)
			</cfquery>
			
			<cfcatch type="database" >
			<cfset local.posts_count = queryNew("count_posts")>
		</cfcatch>
	</cftry>
		
		<cfset local.posts=category_posts>
	</cfif>
	
	<cfif url.sort_by_tag neq "">
		<cftry>
			<cfquery datasource="#variables.datasource#" name="local.tag_posts">
				SELECT post_id,
					   post_title,
					   post_content,
					   post_date_posted,
					   post_user_id,
					   post_category_id,
					   users_name,
					   category_name
				FROM posts AS p
					INNER JOIN users AS u ON(u.users_id = p.post_user_id)
					INNER JOIN categories AS c ON(c.category_id = p.post_category_id)
				WHERE post_id IN(SELECT post_id FROM posts_to_tags WHERE tag_id=<cfqueryparam value="#url.sort_by_tag#" cfsqltype="cf_sql_integer" >)
				ORDER BY post_date_posted 
				DESC
				LIMIT #(url.page-1) * posts_per_page#,#posts_per_page#
			</cfquery>
			<cfcatch type="database" >
			<cfset local.tag_posts = queryNew("post_id,
												   post_title,
												   post_content,
												   post_date_posted,
												   post_user_id,
												   post_category_id,
												   users_name,
												   category_name 
										")>
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfquery datasource="#variables.datasource#" name="local.posts_count">
			SELECT count(*) AS count_posts
			FROM posts AS p
				INNER JOIN users AS u ON(u.users_id = p.post_user_id)
				INNER JOIN categories AS c ON(c.category_id = p.post_category_id)
			WHERE post_id IN(SELECT post_id FROM posts_to_tags WHERE tag_id=<cfqueryparam value="#url.sort_by_tag#" cfsqltype="cf_sql_integer" >)
		</cfquery>
		
		<cfcatch type="database" >
			<cfset local.posts_count = queryNew("count_posts")>
		</cfcatch>
	</cftry>
		
		<cfset local.posts=tag_posts>
</cfif>

<cfreturn {posts = local.posts,count = local.posts_count.count_posts} >

</cffunction> <!---end get_all_posts--->



<cffunction name="get_edit_post_info" returntype="Query" hint="gets query for the post that is currently being edited">
	<cfargument name="edit_post" required="true" type="numeric" >
	<cfargument name="posts" required="true" type="query" >
	
		<cftry>
			<cfquery dbtype="query" name="local.edit_post_info">
				SELECT * 
				FROM posts
				WHERE post_id= <cfqueryparam value="#arguments.edit_post#" cfsqltype="cf_sql_integer"  >
			</cfquery>
			
			<cfcatch type="database" >
				<cfset edit_post_info = queryNew("post_id,
													   post_title,
													   post_content,
													   post_date_posted,
													   post_user_id,
													   post_category_id,
													   users_name,
													   category_name 
											")>
			</cfcatch>
		</cftry>
	
	<cfreturn edit_post_info>
</cffunction> <!---end get_edit_post_info--->



<cffunction name="get_edit_post_tags" returntype="Query" hint="gets query for the tags of the post currently being edited">
	
	<cfargument name="edit_post" required="true" type="numeric" >
	
	<cftry>
		<cfquery datasource="#variables.datasource#"  name="local.edit_post_tags">
			SELECT 
				tag_id 
			FROM posts_to_tags 
			WHERE post_id= <cfqueryparam value="#edit_post#" cfsqltype="cf_sql_integer"  >
		</cfquery>
		<cfcatch type="database" >
			<cfset local.edit_post_tags = queryNew("tag_id")>
		</cfcatch>
	</cftry>
	
	<cfreturn edit_post_tags>
</cffunction> 




<cffunction name="modify_category_tag" returntype="void" hint="modify the tag and category db entries">
	<cfargument name="url" required="true" type="struct" >
	<cfargument name="form" required="true" type="struct" >
	<cfargument name="session" required="true" type="struct" >
	
		<!---if the add_tag field has a value(if the form exists) and the button is set to add--->
		<cfif form.add_tag neq "" and form.button eq "Add">
			<cfquery datasource="blog">
				INSERT INTO tags SET tag_name = <cfqueryparam value="#form.add_tag#" cfsqltype="cf_sql_varchar"  >
			</cfquery>
			
		</cfif>
		
		<!---if the edit_tag field has a value(if the form exists) and the button is set to edit--->
		<cfif form.edit_tag neq "" and form.button eq "Edit">
			<cfquery datasource="blog">
				UPDATE tags SET tag_name=<cfqueryparam value="#form.edit_tag#" cfsqltype="cf_sql_varchar"  > WHERE tag_id='#form.edit_tag_id#'
			</cfquery>
			
		</cfif>
		
		<!---if the delete_tag field has a value(if the form exists), resets page to clear url after query --->
		<cfif url.delete_tag neq "">
			<cfquery datasource="blog">
				DELETE FROM tags WHERE tag_id='#url.delete_tag#'
			</cfquery>
			
			<cfquery datasource="blog">
				DELETE FROM posts_to_tags WHERE tag_id='#url.delete_tag#'
			</cfquery>
			
		</cfif>
		
		<!---if the edit_category field has a value(if the form exists) and the button is set to edit--->
		<cfif form.edit_category neq "" and form.button eq "Edit">
			<cfquery datasource="blog">
				UPDATE categories SET category_name=<cfqueryparam value="#form.edit_category#" cfsqltype="cf_sql_varchar"  > WHERE category_id='#form.edit_category_id#'
			</cfquery>
			
		</cfif>
		
		<!---if the delete_category field has a value(if the form exists), resets page to clear url after query --->
		<cfif url.delete_category neq "">
			<cfquery datasource="blog">
				DELETE FROM categories WHERE category_id='#url.delete_category#'
			</cfquery>
			
		</cfif>
		
		<!---if the add_category field has a value(if the form exists) and the button is set to add--->
		<cfif form.add_category neq "" and form.button eq "Add">
			<cfquery datasource="blog">
				INSERT INTO categories SET category_name = <cfqueryparam value="#form.add_category#" cfsqltype="cf_sql_varchar"  >
			</cfquery>
			
		</cfif>

</cffunction> <!---end modify_category_tag--->



<cffunction name="modify_posts" returntype="void" hint="modify the post db entries">
	<cfargument name="url" required="true" type="struct" >
	<cfargument name="form" required="true" type="struct" >
	<cfargument name="session" required="true" type="struct" >
	
	<cfscript>
		//post vars
		user_id = session.user_id;  /* this will be stored in the session from the user logging in */
		
		title = form.title;
		content = form.form_content;
		category = form.category;
		tags = listToArray(form.tags,",");
	</cfscript>
	
	<!---if the add_tag field has a value(if the form exists) and the button is set to add--->
	<cfif form.button eq "Add Post">
		<cfquery datasource="blog">
			INSERT INTO posts SET post_title='#form.title#', post_content='#form.form_content#', post_date_posted=NOW(), post_user_id='#user_id#',post_category_id='#form.category#'
		</cfquery>
		<cfquery datasource="blog" name="last_insert_id">
			SELECT LAST_INSERT_ID() as last_id
		</cfquery>
		
		<cfset last_id = last_insert_id.last_id>

		<cfloop array="#tags#" index="tag">
			<cfquery datasource="blog">
				INSERT INTO posts_to_tags SET post_id='#last_id#',tag_id='#tag#'
			</cfquery>
		</cfloop>
	</cfif>
	
	<!---if the add_tag field has a value(if the form exists) and the button is set to edit--->
	
	<cfif form.button eq "Edit Post">
		
		<cfquery datasource="blog">
			UPDATE posts 
			SET post_title='#form.title#', 
				post_content='#form.form_content#', 
				post_user_id='#session.user_id#',
				post_category_id='#form.category#'
			WHERE post_id = '#form.id#'
		</cfquery>
		
		<cfquery datasource="blog">
			DELETE FROM posts_to_tags
			WHERE post_id='#form.id#'
		</cfquery>
		
		<cfloop array="#tags#" index="tag">
			<cfquery datasource="blog">
				INSERT INTO posts_to_tags SET post_id='#form.id#',tag_id='#tag#'
			</cfquery>
		</cfloop>
	</cfif>
	
	<!---if the delete_post get value exists, delete post with the id given --->
	<cfif url.delete_post neq "">
		<cfquery datasource="blog">
			DELETE FROM posts WHERE post_id='#url.delete_post#'
		</cfquery>
		
		<cfquery datasource="blog">
			DELETE FROM posts_to_tags WHERE post_id='#url.delete_post#'
		</cfquery>
	</cfif>
	

</cffunction>

<cffunction name="get_login_info" returntype="Query" hint="returns login information query">
	<cfargument name="form" type="struct" required="true"> 
	<cfquery datasource="blog" name="login">
	SELECT users_id,users_name FROM users WHERE users_name = <cfqueryparam value="#form.username#" cfsqltype="cf_sql_varchar" > AND password = <cfqueryparam value="#form.password#" cfsqltype="cf_sql_varchar" >
	</cfquery>
	
	<cfreturn login>
</cffunction>

</cfcomponent>