$(function(){
		   
	$("#add_cat_js").bind("click", function(){
		
		$("#add_cat_form_js")
		.empty()
		.append("<div class='edit_tag'>"+
		"Add a Category | <a class='delete_author cancel_btn_js' href='##'>Cancel</a>"+
		"<cfform method='post' action='modify_tags_categories.cfm##cat_block'>"+
		"<p><input type='text' name='add_category' value='' />"+
		"<input class='submit_button' type='submit' name='button' value='Add' /></p>"+
		"</cfform></div>");
							
		
		$(".cancel_btn_js").bind("click",function(){
			$("#add_cat_form_js")
			.empty()
			
			return false;
		});
	
	
		return false;
	});
	
	
	
	
/*	$("#loginForm .btn").bind("click",function(){
					
		$.getJSON("xhr/login.php",{login:$("#userName").attr("value") ,passphrase:$("#password").attr("value")},function(response){
			if(response.error){
				//alert("invalid user name or password");
				$(" <p id='errorLogin'>Wrong User Name or Password</p>").insertAfter("#introContent p:first");
					
			}else{
				$("#errorLogin").remove();
				changeToAccount(response.user);
			};
		});
		
		return false;
	}); */
	
	
});//program end