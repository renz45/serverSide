<cfset application.model.protect_page(session)>

<cfparam name="form.title" type="string" default="">
<cfparam name="form.form_content" type="string" default="">
<cfparam name="form.category" type="string" default="">
<cfparam name="form.tags" type="string" default="">
<cfparam name="form.button" type="string" default="">
<cfparam name="form.id" type="string" default="">

<cfparam name="url.delete_post" type="string" default="">



<!---if the add_tag field has a value(if the form exists) and the button is set to edit--->
<cfset application.model.modify_posts(url,form,session)>
<cflocation url="admin.cfm?add_post=#session.add_post#" addtoken="false" >
