<cfparam name="URL.project_id" type="numeric" default=0>
<cfset items=application._model_user.rss(URL.project_id)>

<cfset columns = {
	id            = "link",
	title         = "title",
	content       = "content",
	publishedDate = "created",
	authorEmail   = "name",
	rsslink       = "link",
	idPermaLink   = "true"
}>

<cfset props = {
	title       = "maistre project notes",
	link        = "http://127.0.0.1/ASL/1009/project/maistre/dev/",
	description = "maistre project management",
	version     = "rss_2.0",
	ttl         = 15
}>

<cffeed action="create" properties="#props#" query="#items#" columnmap="#columns#" xmlvar="feed">
<cfcontent type="application/rss+xml" reset="true"><cfoutput>#feed#</cfoutput>