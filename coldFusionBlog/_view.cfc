<cfcomponent >
<cfsetting showdebugoutput="false" >


<cffunction name="show_head" returntype="void" hint="returns html for head portion of the site includes navigation and banner">
	<cfargument name="session" required="true" hint="session global - required">
	<cfargument name="page_type" type="string" default="index" hint="accepts either 'index' or 'admin_index' ">
	
	<cfparam name="session.is_logged_in" default="false">
	

	<cfoutput>
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Intentional Health</title>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<link rel="shortcut icon" href="img/logo_favicon.ico" type="image/x-icon" />
				<!-- <meta name="Keywords" content="keywords go here seperated by comas" />
				<meta name="Description" content="description here" /> -->
		
				
				<link rel="stylesheet" type="text/css" href="css/main.css" />
				
				<cfif page_type eq "admin">
					<link rel="stylesheet" type="text/css" href="css/admin.css" />
					<!---<script type="text/javascript" src="js/jquery-1.4.2.min.js"></script>
					<script type="text/javascript" src="js/blog.js"></script>--->

				</cfif>
				
			</head>
			
			<body>
				<div id="header">
					<div id="nav">
						<h1><a href="##">Intentional Health Products</a></h1>	
					</div><!-- end nav -->		
				</div><!-- end header -->
				<div id="nav_bottom"> 
			
					<cfif page_type eq "index" and session.is_logged_in eq false>
						<cfif url.login eq false >
							<a class="login_button" href="index.cfm?login=true">Log In</a>
						<cfelse>
							
							<form method="post" action="login.cfm">
								<cfif url.login_error eq true><p id="error">Wrong password or username</p></cfif>
								<p><label for="username">User Name: </label><input type="text" name="username" value=""/></p>
								<p><label for="username">Password: </label><input type="password" name="password" value=""/></p>
								<p><input class="submit_button" type="submit" name="button" value="Log In" /><a class="submit_button" href="index.cfm">Cancel</a></p>
							</form>
						</cfif>
					<cfelse>
						<cfif page_type eq "admin" and session.is_logged_in eq true>
							<a class='login_button' href='index.cfm'>Home</a>
						<cfelse>
							<a class='login_button' href='admin.cfm'>Admin</a>
						</cfif>
					
						<a class="login_button" href="logout.cfm">Welcome, #session.user_name# | Log Out</a>
					</cfif>
					
				</div><!-- end nav_bottom -->
				
				<cfif page_type eq "index">
					<div id="banner">
						<h2>Helping you help yourself naturally.</h2>				
					</div><!-- end banner -->
				</cfif>
				<div id="wrapper">				
					<div id="content">
						<div id="col1">	
			
	</cfoutput>			
	

</cffunction> <!---end show_head--->




<cffunction name="show_index_col1" returntype="void" hint="returns html for col1 on the index page">
	<cfargument name="posts_query" required="true" type="query" hint="posts query">
	<cfargument name="posts_count" required="true" type="numeric"  hint="total count post - used for pagination">
	<cfargument name="posts_per_page" required="true" type="numeric"  hint="posts per page, used for pagination">
	<cfargument name="posts" required="true" type="query">
	
	<cfargument name="all_tags" type="query" required="true" hint="all_tags query">
	<cfargument name="all_categories" type="query" required="true" hint="all_categories query">
	
	
	
	<cfoutput >
		<h3>HEY, GUESS WHAT!</h3>
			
			<form method="post" action="index.cfm" id="search_form">
				<p><input class="input_text" type="text" name="search" value="Search" /><input class="submit_button" type="submit" name="button" value="Search" /></p>
			</form>
			
			
			<cfset show_sort_by_menu(all_tags,all_categories,"index.cfm","col1")>
			
			<cfset name="show_sort_by_menu">
			
			<ul id="blog_roll">
			
				<cfloop query="arguments.posts_query">
					<li class="post">
					<h2><a href="index.cfm?view_post=#posts.post_id###col1">#post_title#</a></h2>
					<p class="post_date">#dateFormat(post_date_posted,"full")# at #timeFormat(post_date_posted,"short")#</p>
					<p class="post_author">Written by <a href="##">#users_name#</a></p>
					<p class="post_content">#post_content#</p>
					
					<!---<p class="view_comments"><a href="##">View Comments(0)</a></p>--->
					
					<ul class="post_categories">
						<li><a href="##">#posts.category_name#</a></li>
					</ul><!-- end post_categories -->
					
					<cfquery datasource="blog" name="post_tag_list">
						SELECT DISTINCT 
							t.tag_name,
							t.tag_id,
							p.post_id
						FROM rensel_tags AS t
							INNER JOIN rensel_posts_to_tags AS p ON(p.post_id = #arguments.posts_query.post_id#) AND (t.tag_id = p.tag_id)
						ORDER BY  tag_name
					</cfquery>
					
					<ul class="post_tags">
						<cfloop query="post_tag_list">
							<cfif post_tag_list.post_id eq posts.post_id>
								<li><a href="index.cfm?sort_by_tag=#tag_id###col1">#tag_name#</a></li>
							</cfif>
						</cfloop>
					</ul><!-- end post_tags -->
					
					
					</li><!-- end post -->
				</cfloop>
				
				
			</ul>
			
			<cfset show_blogroll_pagination(arguments.posts_count,arguments.posts_per_page,"index.cfm","col1")>
		</div><!-- end col1 -->
	</cfoutput>
</cffunction><!--- end show_index_col1  --->




<cffunction name="show_sort_by_menu" returntype="void" hint="display html for the sort by menu which indicates what the posts are sorted by and gives a link back to all posts">

<cfargument name="all_tags" type="query" required="true" hint="all_tags query">
<cfargument name="all_categories" type="query" required="true" hint="all_categories query">
<cfargument name="page_to_load" required="true" type="string" hint="page to load when show all is clicked or sort is applied">
<cfargument name="anchor" required="false" default="" type="string" hint="anchor to skip to" >


	<cfif anchor neq "">
		<cfset anchor = "##" & anchor>
	</cfif>

	<cfoutput>
		<cfif url.sort_by_tag neq "">
				<cfquery dbtype="query" name="current_tag">
					SELECT tag_name FROM all_tags WHERE tag_id = #url.sort_by_tag#
				</cfquery>
				<f3 id="sort_pointer">Sorted by Tag: #current_tag.tag_name# | <a href="#page_to_load##anchor#">All Posts</a></f3>
			</cfif>
			
			<cfif url.sort_by_category neq "">
				<cfquery dbtype="query" name="current_category">
					SELECT category_name FROM all_categories WHERE category_id = #url.sort_by_category#
				</cfquery>
				
				<f3 id="sort_pointer">Sorted by category: #current_category.category_name# | <a href="#page_to_load##anchor#">All Posts</a></f3>
			</cfif>
			
			<cfif url.view_post neq "">
				
				<f3 id="sort_pointer"><a href="index.cfm##col1">All Posts</a></f3>
			</cfif>
	</cfoutput>

</cffunction><!--- end show_sort_by_menu --->




<cffunction name="show_blogroll_pagination" returntype="void" hint="outputs html for blog roll pagination - changes the page url variable accordingly">
	<cfargument name="posts_count" required="true" type="numeric" hint="total number of posts">
	<cfargument name="posts_per_page" required="true" type="numeric" hint="total posts per page">
	<cfargument name="page_to_load" required="true" type="string"  hint="page to reload">
	<cfargument name="anchor" required="false" default="" type="string" hint="Anchor to skip to(optional) defailts to empty string">
	
	<cfif anchor neq "">
		<cfset anchor = "##" & anchor>
	</cfif>
	
	<cfoutput>
		<cfif url.view_post eq "">
			<div id="blog_pagination">
				<cfset total=#ceiling(posts_count / INT(posts_per_page))#>
				<cfif url.page lt total><p id="prev"><a href="#page_to_load#?page=#total##anchor#"> Last</a> &nbsp;|&nbsp; <a href="#page_to_load#?page=<cfif url.page lt total>#url.page + 1#<cfelse>#total#</cfif>#anchor#">Previous &gt;&gt;</a></p></cfif>
				<cfif url.page gt 1><p id="next"><a href="#page_to_load#?page=<cfif url.page gt 1>#url.page - 1#<cfelse>1</cfif>#anchor#">&lt;&lt; Next</a> &nbsp;|&nbsp; <a href="#page_to_load#?page=1#anchor#"> First</a></p></cfif>
				<p>#url.page# of #total#</p>
			</div><!-- end blog_pagination -->
		</cfif>
	</cfoutput>

</cffunction> <!---end show_blogroll_pagination--->




<cffunction name="show_index_col2" returntype="void" hint="returns html for col2 on the index page">
	<cfargument name="all_categories" type="query" required="true" >
	<cfargument name="all_tags" type="query" required="true">
	<cfargument name="high_tag_count" type="numeric"  required="true"> 
	
	<cfoutput>
	<div id="col2">
		<div class="category_block" id="cat_block">
			<h3>Categories</h3>
			<cfset show_category_list(all_categories)>
			
		</div><!-- end category_block -->
		
		<div id="tag_block">
			<h3>Tags</h3>					
			<cfset show_tag_list(all_tags,high_tag_count)>
		</div><!-- end tag_block -->		
	</cfoutput>

</cffunction><!--- end show_index_col2 --->




<cffunction name="show_category_list" returntype="void" hint="returns html for category list in side menu" >
	<cfargument name="all_categories" type="query" required="true" >
	
	<cfoutput>
		<ul class="category_list">
			<cfloop query="all_categories">
					<li><a <cfif url.sort_by_category eq #all_categories.category_id#>class="active"</cfif> href="index.cfm?sort_by_category=#all_categories.category_id###col1">#all_categories.category_name#(#category_count#)</a></li>
			</cfloop>
				
		</ul>
	</cfoutput>

</cffunction><!--- end show category_list --->




<cffunction name="show_tag_list" returntype="void" hint="returns html for the tag list">
	<cfargument name="all_tags" type="query" required="true">
	<cfargument name="high_tag_count" type="numeric"  required="true">  

	<cfoutput>
		<ul id="tag_list">
		
			<cfloop query="arguments.all_tags">
			
					<cfset tc = #tag_count#>
					<!---tag cloud takes the highest tag count calculated near the query, and uses it to create a percent, which is used to divide the total count
					the percent has 1 added to it to keep the size at 1 em or above.
					
					The same percent is multiplied against a 17px line height to decrease the line height when the font size gets smaller so the tags snug up--->
					<cfif tc neq 0>
						<li>
							<a 
								<cfif url.sort_by_tag eq #all_tags.tag_id#>
								class="active" 
								</cfif>
								style="
								 	font-size: #((tc/INT(high_tag_count))*1.5)+.7#em; 
							  	 	line-height: #18*(tc/INT(high_tag_count))#px;
									padding:2px;" 
								href="index.cfm?sort_by_tag=#all_tags.tag_id###col1"
							><!-- end of anchor -->
								#all_tags.tag_name#
							</a> 
							<!---<cfif all_tags.CurrentRow neq all_tags.RecordCount>,</cfif>--->
						</li>
					</cfif>
		
			</cfloop>
		</ul>
	</cfoutput>
	
</cffunction><!--- end show_tag_list --->




<!--- ******************************** Admin ****************************************** --->





<cffunction name="show_edit_add_nav" returntype="void" hint="returns html for edit/add nav on admin page" >

	<cfoutput>
		<cfif url.add_post eq true>
			<p id="admin_post_state"><a class="active" href="admin.cfm?add_post=true">Add Post</a> &nbsp;|&nbsp; <a href="admin.cfm">Edit Posts</a></p>
		<cfelse>
			<p id="admin_post_state"><a href="admin.cfm?add_post=true">Add Post</a> &nbsp;|&nbsp; <a class="active" href="admin.cfm">Edit Posts</a></p>
		</cfif>
	</cfoutput>
</cffunction><!--- end show_edit_add_nav --->




<cffunction name="show_edit_add_form" returntype="void" hint="returns html for the form which enables the user to edit/add a post" >

	<cfargument name="all_categories" required="true" type="query" >
	<cfargument name="all_tags" required="true" type="query" >	

	<cfargument name="title" required="false" default="" type="string">
	<cfargument name="content" required="false" default="" type="string">
	<cfargument name="category" required="false" default="" type="string">
	<cfargument name="edit_post_id" required="false" default="" type="string">
	
	<cfargument name="edit_post_tags" required="false" type="query" >
	
	<cfargument name="error_message" required="false" default="" type="string" hint="error message">

	<cfoutput>
		<cfif error_message neq "">
			<p id="error">#error_message#</p>
		</cfif>
		
		<cfform id="post_form" method="post" action="modify_posts.cfm">
		
			<p id="form_title"><label for="title">Title: </label><br /><cfinput required="true" maxlength="65" message="Please Enter a title" type="text" id="title" name="title" value="#title#" ></p>
			
			<p id="form_content"><label for="form_content">Content: </label><br /><cftextarea required="true" message="Please Enter Content" name="form_content" rows="7" cols="35">#content#</cftextarea></p>
			
			<div class="form_list_block">
				<p class="form_label">Choose a Category</p>
				<ul class="form_list">
					<cfloop query="all_categories">
						<li><input type='radio' name='category' value="#all_categories.category_id#" <cfif edit_post_id neq "" and category eq all_categories.category_id>checked="checked"</cfif>/ > #all_categories.category_name#</li>
					</cfloop>
				</ul>
			</div><!-- end form_list_block -->
			
			<div class="form_list_block">
				<p class="form_label">Choose Tags</p>
				<ul class="form_list">
				
					<cfloop query="all_tags">
					<cfset tag_checked_text = "">
						<cfif edit_post_id neq "">
							<cfloop query="edit_post_tags">
								<cfif edit_post_tags.tag_id eq all_tags.tag_id>
									<cfset tag_checked_text = " checked='checked' ">
								</cfif>
							</cfloop>
						</cfif>
						
						<li><input  type='checkbox' name='tags' value="#all_tags.tag_id#" #tag_checked_text# /> #all_tags.tag_name#</li>
					</cfloop>
				</ul>
			</div><!-- end form_list_block -->
			<cfif edit_post_id neq ""><input type="hidden" name="id" value="#edit_post_id#"/></cfif>
			<p id="form_submit"><input class="submit_button" type="submit" name="button" value="<cfif edit_post_id neq "">Edit<cfelse>Add</cfif> Post" /> <a class="submit_button" href="admin.cfm?add_post=false">Cancel</a></p>
			
		</cfform>
	</cfoutput>

</cffunction> <!---end show_edit_add_form--->



<cffunction name="show_admin_post_list" returntype="void" hint="returns the admin post list html">
	<cfargument name="posts" required="true" type="query" >

	<cfoutput>
	
		<ul id="admin_post_list">
			<cfloop query="posts" >
				<li><a class="large_post_button" href="admin.cfm?add_post=true&amp;edit_post=#post_id#"><span class="title">#post_title#</span> Posted by <span class="author">#users_name#</span> on <br />#dateFormat(post_date_posted,"full")# at # timeFormat(post_date_posted,"short")#</a><a class="delete_post" title="delete post" href="modify_posts.cfm?delete_post=#post_id#">Delete Post</a></li>
			</cfloop>
		</ul>
		
	
	</cfoutput>

</cffunction><!--- end show_admin_post_list --->




<cffunction name="show_admin_category_block" returntype="void" hint="returns html for admin category menu block">

	<cfargument name="all_categories" required="true" type="query"  >
	<cfargument name="edit_post" required="false" default="" type="string" >

	<cfoutput >
	</div><!-- end col1 -->
	<div id="col2">
		<div class="category_block" id="cat_block">
			<h3>Edit Categories 
			
				<cfif url.add neq "category">
					<a id="add_cat_js" href="admin.cfm?add_post=#url.add_post#&amp;add=category##cat_block">Add</a>
				<cfelse>
					<a href="admin.cfm?add_post=#url.add_post###cat_block">Cancel</a>
				</cfif>
			</h3>
			
			<cfif edit_post neq "">
				<cfset local.edit_post_html = "&amp;edit_post=#edit_post#">
			<cfelse>
				<cfset local.edit_post_html = "">
			</cfif>
			
			<div id="add_cat_form_js"
				<!--- adds form in when add is clicked --->
				<cfif url.add eq "category">
					<div class="edit_tag">
						Add a Category | <a class="delete_author" href="admin.cfm?add_post=#url.add_post###cat_block">Cancel</a>
						<cfform method="post" action="modify_tags_categories.cfm##cat_block">
							<p><cfinput required="true" message="Please cancel or enter a category" type="text" name="add_category" value="" /><input class="submit_button" type="submit" name="button" value="Add" /></p>
						</cfform>
					</div>
				</cfif>
			</div>
			
			<ul class="category_list">
				<cfloop query="all_categories">
				<!--- insert edit category form --->
					<cfif all_categories.category_id eq url.category>
						<li><a class="delete_author" href="modify_tags_categories.cfm?delete_category=#url.category#">Delete</a> | <a class="delete_author" href="admin.cfm?add_post=#url.add_post###col2">Cancel</a>
						<cfform method="post" action="modify_tags_categories.cfm">
							<p><cfinput required="true" message="Please cancel or enter a category" type="text" name="edit_category" value="#all_categories.category_name#" />
							<input type="hidden" name="edit_category_id" value="#url.category#"/>
							<input class="submit_button" type="submit" name="button" value="Edit" /></p>
						</cfform></li>
					<cfelse>
						
						<li><a href="admin.cfm?add_post=false&amp;sort_by_category=#all_categories.category_id#">#all_categories.category_name#(#category_count#)</a> | <a class="edit_link" href="admin.cfm?add_post=#url.add_post#&amp;category=#all_categories.category_id###cat_block"> Edit </a></li>
					</cfif>
				</cfloop>
				
			</ul>
		</div><!-- end category_block -->
	
	</cfoutput>

</cffunction><!--- end show_admin_category_block --->




<cffunction name="show_admin_tag_block" returntype="void" hint="return html for tag menu" >

	<cfargument name="all_tags" required="true" type="query"  >
	<cfargument name="high_tag_count" required="true" type="numeric"  >
	<cfargument name="edit_post" required="false" default="" type="string" >

	<cfoutput>
	
		<div id="tag_block">
			<h3>Edit Tags
				 <cfif url.add neq "tag">
					<a href="admin.cfm?add_post=#url.add_post#&amp;add=tag##tag_block">Add</a>
				<cfelse>
					<a href="admin.cfm?add_post=#url.add_post###tag_block">Cancel</a>
				</cfif>
			 </h3>
			
			<!--- adds form in when add is clicked --->
			<cfif url.add eq "tag" and url.tag eq "">
				<div class="edit_tag">
					Add a Tag | <a class="delete_author" href="admin.cfm?add_post=#url.add_post###tag_block">Cancel</a>
					<cfform method="post" action="modify_tags_categories.cfm##tag_block">
						<p><cfinput required="true" message="Please cancel or enter a tag" type="text" name="add_tag" value="" /><input class="submit_button" type="submit" name="button" value="Add" /></p>
					</cfform>
				</div>
			</cfif>
			
			<!---edit tag--->
			<cfif url.tag neq "">
			<!-- edit tag -->
				<cfloop query="all_tags">
					<cfif all_tags.tag_id eq url.tag>
						<div class="edit_tag">
							<a class="delete_author" href="modify_tags_categories.cfm?delete_tag=#url.tag#">Delete</a> | <a class="delete_author" href="admin.cfm?add_post=#url.add_post###tag_block">Cancel</a>
							<cfform method="post" action="modify_tags_categories.cfm##tag_block">
								<p><cfinput required="true" message="Please cancel or enter a tag" type="text" name="edit_tag" value="#all_tags.tag_name#" />
								<input type="hidden" name="edit_tag_id" value="#url.tag#"/>
								<input class="submit_button" type="submit" name="button" value="Edit" /></p>
							</cfform>
						</div>
					</cfif>
				</cfloop>	
			</cfif>
			
			<ul id="tag_list">
				<cfloop query="all_tags">
					<cfif all_tags.tag_id eq url.tag>
						<li><span class="active">#all_tags.tag_name#</span><cfif all_tags.CurrentRow neq all_tags.RecordCount>,</cfif></li>
					<cfelse>
						
						<cfset tc = #tag_count#>
						
						<!---tag cloud takes the highest tag count calculated near the query, and uses it to create a percent, which is used to divide the total count
						the percent has 1 added to it to keep the size at 1 em or above.
						
						The same percent is multiplied against a 17px line height to decrease the line height when the font size gets smaller so the tags snug up--->
						<li>
							<a 
								style="
								 	font-size: #((tc/INT(high_tag_count)))+1#em; 
							  	 	line-height: #17*(tc/INT(high_tag_count))#px;
							     		<cfif tc eq 0>color:##999;</cfif>" 
								href="admin.cfm?add_post=false&amp;sort_by_tag=#all_tags.tag_id#"
							><!-- end of anchor -->
								#all_tags.tag_name#
							</a> | 
							<a class="edit_link" href="admin.cfm?add_post=#url.add_post#&amp;tag=#all_tags.tag_id###tag_block"> Edit </a>
							<cfif all_tags.CurrentRow neq all_tags.RecordCount>,</cfif>
						</li>
					</cfif>
				</cfloop>
			</ul>
		</div><!-- end tag_block -->
	
	</cfoutput>

</cffunction> <!--- end show_admin_tag_block --->




<cffunction name="show_admin_wrapper" returntype="void" hint="html for wrapper">
	
	
	
	<cfoutput>
		<div id="wrapper">				
				<div id="content">
					<div id="col1">
						
						
						<cfset show_edit_add_nav()>
						
						<cfif url.add_post eq true>
							<cfif url.edit_post eq "">
								<cfset show_edit_add_form(all_categories,all_tags,title,content,category)>
							<cfelse>
								<cfset show_edit_add_form(all_categories,all_tags,title,content,category,edit_post_id,edit_post_tags,error)>
							</cfif>
						
						<cfelse> <!---if add_post eq true--->

							<cfset show_admin_post_list(posts)>
						
						</cfif>	<!---if add_post eq true--->	
					</div><!-- end col1 -->
					
					<div id="col2">
						
						<cfset show_admin_category_block(all_categories)>
						
						<cfset show_admin_tag_block(all_tags)>
						
					</div><!-- end col2 -->
					
				</div><!-- end content -->
	
			</div><!-- end wrapper -->
	</cfoutput>

</cffunction>




<cffunction name="show_footer" returntype="void" hint="output footer html">
	<cdoutput>
					</div><!-- end col2 -->
					
				</div><!-- end content -->
	
			</div><!-- end wrapper -->
		<div id="footer">
			<h1><a href="##"> Intentional Health Products</a></h1>
		</div><!-- end footer -->
	</body>
</html>
	</cdoutput>
</cffunction><!--- end show_footer --->

</cfcomponent>