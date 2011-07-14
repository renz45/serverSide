<cfparam name="form.user_id" type="numeric" default=-1>
<cfparam name="form.password" type="string" default="">
<cfparam name="form.avatar_url" type="string" default="">
<cfparam name="form.email" type="string" default="">
<cfparam name="form.gh_username" type="string" default="">
<cfparam name="form.description" type="string" default="">
<cfparam name="form.page_to_load" type="string" default="home">

<cfset args = {} >
<cfif form.user_id neq -1>
	<cfset args.user_id = form.user_id >
</cfif>
<cfif form.password neq "">
	<cfset args.password = form.password >
</cfif>
<cfif form.avatar_url neq "">
	<!--- set the full path to the images folder --->
	<cfset mediapath = expandpath('images_members/')>
	
	<!--- set the desired image height ---->
	<cfset thumbsize = 80>
	
	<!--- set the desired image width --->
	<cfset imagesize = 80>
	
	<cfif structKeyExists(form,"avatar_url") and len(form.avatar_url)>
	   <cffile action="upload" filefield="avatar_url" destination="#MediaPath#" nameconflict="makeunique">
	   
	   <!--- read the image ---->
	   <cfimage name="uploadedImage" source="#MediaPath#/#file.serverFile#">
	
	   <!--- figure out which way to scale the image --->
	   <cfif uploadedImage.width gt uploadedImage.height>
	      <cfset thmb_percentage = (thumbsize / uploadedImage.width)>
	      <cfset percentage = (imagesize / uploadedImage.width)>
	   <cfelse>
	      <cfset thmb_percentage = (thumbsize / uploadedImage.height)>
	      <cfset percentage = (imagesize / uploadedImage.height)>
	   </cfif>
	   
	   <!--- calculate the new thumbnail and image height/width --->
	   <cfset thumbWidth = round(uploadedImage.width * thmb_percentage)>
	   <cfset thumbHeight = round(uploadedImage.height * thmb_percentage)>
	   <cfset newWidth = round(uploadedImage.width * percentage)>
	   <cfset newHeight = round(uploadedImage.height * percentage)>
	
	   <!--- see if we need to resize the image, maybe it is already smaller than our desired size --->
	   <cfif uploadedImage.width gt imagesize>
	         <cfimage action="resize" height="#newHeight#" width="#newWidth#" source="#uploadedImage#" destination="#MediaPath#/#file.serverFile#" overwrite="true"/>
	   </cfif>
	   <cfset args.avatar_url = "#file.serverFile#">
	</cfif>
</cfif>
<cfif structKeyExists(form, "gravitar")>
	<cfset hashed_email = lcase(hash(form.email,"MD5"))>
	<cfset args.avatar_url = "http://www.gravatar.com/avatar/#hashed_email#">
</cfif>
<cfif form.email neq "">
	<cfset args.email = form.email >
</cfif>
<cfif form.description neq "">
	<cfset args.description = form.description >
</cfif>
<cfif form.gh_username neq "">
	<cfset args.gh_username = form.gh_username >
</cfif>

<cfset application._model_user.edit_user_profile(argumentCollection=args)>

<cflocation url="#form.page_to_load#" addtoken="false" >
