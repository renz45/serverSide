<cfparam name="url.sort_by_category" type="string" default="">
<cfparam name="url.sort_by_tag" type="string" default="">
<cfparam name="url.view_post" type="string" default="">
<cfparam name="url.page" type="string" default="1">
<cfparam name="url.login" type="string" default="false">
<cfparam name="url.login_error" type="string" default="false">

<cfset posts_per_page = 4 >



<!---get tags and categories--->
<cfquery datasource="blog" name="all_categories">
	SELECT 
		category_name,
		category_id,
		count(p.post_category_id) AS category_count
		
	FROM categories AS c
		LEFT JOIN posts AS p ON(c.category_id = p.post_category_id)
	GROUP BY category_name,category_id
</cfquery>

<cfquery datasource="blog" name="all_tags">
	SELECT t.tag_name, 
		   t.tag_id,
		   p.post_id,
		   count(*) AS tag_count
	FROM tags AS t
		LEFT JOIN posts_to_tags as p ON(t.tag_id = p.tag_id)
	GROUP BY tag_name
</cfquery>

<!---code gets the highest count for any one tag--->
	<cfset high_tag_count=0>
	<cfloop query="all_tags" >
		<cfif INT(#tag_count#) gt #high_tag_count# >
			<cfset high_tag_count = INT(#tag_count#)>	
		</cfif>
	</cfloop>

<!---get posts--->
<cfquery datasource="blog" name="all_posts">
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
	<cfif url.view_post neq "">WHERE post_id = #url.view_post#</cfif>
	ORDER BY post_date_posted DESC
	LIMIT #(url.page-1) * posts_per_page#,#posts_per_page#

</cfquery>

<cfquery datasource="blog" name="posts_count">
	SELECT count(*) AS count_posts
	FROM posts AS p
		INNER JOIN users AS u ON(u.users_id = p.post_user_id)
		INNER JOIN categories AS c ON(c.category_id = p.post_category_id)
</cfquery>

<cfset posts=all_posts>

<cfif url.sort_by_category neq "">
	<cfquery datasource="blog"  name="category_posts">
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
		INNER JOIN categories AS c ON(c.category_id = p.post_category_id) AND (c.category_id = #url.sort_by_category#)
	ORDER BY post_date_posted DESC
	LIMIT #(url.page-1) * posts_per_page#,#posts_per_page#
	</cfquery>
	
	<cfquery datasource="blog"  name="posts_count">
		SELECT count(*) AS count_posts
		FROM posts AS p
			INNER JOIN users AS u ON(u.users_id = p.post_user_id)
			INNER JOIN categories AS c ON(c.category_id = p.post_category_id) AND (c.category_id = #url.sort_by_category#)
	</cfquery>
	
	<cfset posts=category_posts>
</cfif>

<cfif url.sort_by_tag neq "">
	<cfquery datasource="blog" name="tag_posts">
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
		WHERE post_id IN(SELECT post_id FROM posts_to_tags WHERE tag_id='#url.sort_by_tag#')
		ORDER BY post_date_posted 
		DESC
		LIMIT #(url.page-1) * posts_per_page#,#posts_per_page#
	</cfquery>
	
	<cfquery datasource="blog" name="posts_count">
		SELECT count(*) AS count_posts
		FROM posts AS p
			INNER JOIN users AS u ON(u.users_id = p.post_user_id)
			INNER JOIN categories AS c ON(c.category_id = p.post_category_id)
		WHERE post_id IN(SELECT post_id FROM posts_to_tags WHERE tag_id='#url.sort_by_tag#')
	</cfquery>
	
	<cfset posts=tag_posts>
</cfif>

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
		
	</head>
	
	<body>
		<div id="header">
			<div id="nav">
				<h1><a href="##">Intentional Health Products</a></h1>	
			</div><!-- end nav -->		
		</div><!-- end header -->
		<div id="nav_bottom">
		
			<cfif url.login eq false >
				<a id="login_button" href="index.cfm?login=true">Log In</a>
			<cfelse>
				
				<form method="post" action="login.cfm">
					<cfif url.login_error eq true><p id="error">Wrong password or username</p></cfif>
					<p><label for="username">User Name: </label><input type="text" name="username" value=""/></p>
					<p><label for="username">Password: </label><input type="password" name="password" value=""/></p>
					<p><input class="submit_button" type="submit" name="button" value="Log In" /><a class="submit_button" href="index.cfm">Cancel</a></p>
				</form>
			</cfif>
			
		</div><!-- end nav_bottom -->
		
		<div id="banner">
			<h2>Helping you help yourself naturally.</h2>				
		</div><!-- end banner -->
		
		<div id="wrapper">
			
						
			<div id="content">
				<div id="col1">
				
					<h3>HEY, GUESS WHAT!</h3>
					
					<form method="post" action="index.cfm" id="search_form">
						<p><input class="input_text" type="text" name="search" value="Search" /><input class="submit_button" type="submit" name="button" value="Search" /></p>
					</form>
					
					<cfif url.sort_by_tag neq "">
						<cfquery dbtype="query" name="current_tag">
							SELECT tag_name FROM all_tags WHERE tag_id = #url.sort_by_tag#
						</cfquery>
						<f3 id="sort_pointer">Sorted by Tag: #current_tag.tag_name# | <a href="index.cfm##col1">All Posts</a></f3>
					</cfif>
					
					<cfif url.sort_by_category neq "">
						<cfquery dbtype="query" name="current_category">
							SELECT category_name FROM all_categories WHERE category_id = #url.sort_by_category#
						</cfquery>
						
						<f3 id="sort_pointer">Sorted by category: #current_category.category_name# | <a href="index.cfm##col1">All Posts</a></f3>
					</cfif>
					
					<cfif url.view_post neq "">
						
						<f3 id="sort_pointer"><a href="index.cfm##col1">All Posts</a></f3>
					</cfif>
					
					<ul id="blog_roll">
					
						<cfloop query="posts">
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
								SELECT DISTINCT t.tag_name,
									   t.tag_id,
									   p.post_id
								FROM tags AS t
									INNER JOIN posts_to_tags AS p ON(p.post_id = #posts.post_id#)
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
					<cfif url.view_post eq "">
						<div id="blog_pagination">
							<cfset total=#ceiling((posts_count.count_posts) / INT(posts_per_page))#>
							<cfif url.page lt total><p id="prev"><a href="index.cfm?page=#total###col1"> Last</a> &nbsp;|&nbsp; <a href="index.cfm?page=<cfif url.page lt total>#url.page + 1#<cfelse>#total#</cfif>##col1">Previous &gt;&gt;</a></p></cfif>
							<cfif url.page gt 1><p id="next"><a href="index.cfm?page=<cfif url.page gt 1>#url.page - 1#<cfelse>1</cfif>##col1">&lt;&lt; Next</a> &nbsp;|&nbsp; <a href="index.cfm?page=1##col1"> First</a></p></cfif>
							<p>#url.page# of #total#</p>
						</div><!-- end blog_pagination -->
					</cfif>
					
				</div><!-- end col1 -->
				
				<div id="col2">
					<!-- <a id="rss" href="##">RSS</a> -->
					
					<div class="category_block" id="cat_block">
							<h3>Categories</h3>
							
							<ul class="category_list">
								<cfloop query="all_categories">
										<li><a <cfif url.sort_by_category eq #all_categories.category_id#>class="active"</cfif> href="index.cfm?sort_by_category=#all_categories.category_id###col1">#all_categories.category_name#(#category_count#<!---<cfif #all_categories.post_category_id# eq "">0<cfelse>#category_count#</cfif>--->)</a></li>
								</cfloop>
								
							</ul>
						</div><!-- end category_block -->
						
						<div id="tag_block">
							<h3>Tags</h3>
							
							<ul id="tag_list">
								<cfloop query="all_tags">
										<cfif #post_id# eq "">
											<cfset tc = 0>
										<cfelse>
											<cfset tc = #tag_count#>
										</cfif>
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
						</div><!-- end tag_block -->					
					
					
				</div><!-- end col2 -->
				
			</div><!-- end content -->

		</div><!-- end wrapper -->
		
		<div id="footer">
			<h1><a href="##"> Intentional Health Products</a></h1>
		</div><!-- end footer -->
	</body>
</html>
</cfoutput>