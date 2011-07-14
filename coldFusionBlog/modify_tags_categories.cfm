

<cfset application.model.protect_page(session)>

<!---add cat, tag form inputs--->
<cfparam name="form.add_tag" type="string" default="">
<cfparam name="form.add_category" type="string" default="">

<cfparam name="form.edit_tag" type="string" default="">
<cfparam name="form.edit_tag_id" type="string" default="">
<cfparam name="form.edit_category" type="string" default="">
<cfparam name="form.edit_category_id" type="string" default="">


<!---get vars--->
<cfparam name="url.add" type="string" default="">
<cfparam name="url.category" type="string" default="">
<cfparam name="url.tag" type="string" default="">

<cfparam name="url.delete_tag" type="string" default="">
<cfparam name="url.delete_category" type="string" default="">

<!---<cfdump var="#form#">--->
<cfset application.model.modify_category_tag(url,form,session)>

<cfif form.edit_tag neq "" or form.add_tag neq "" or url.delete_tag neq "">
	<cflocation url="admin.cfm?add_post=#session.add_post###tag_block" addtoken="false" >
</cfif>

<cfif form.edit_category neq "" or form.add_category neq "" or url.delete_category neq "">
	<cflocation url="admin.cfm?add_post=#session.add_post###cat_block" addtoken="false" >
</cfif>