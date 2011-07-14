jQuery(function(){
  // Hashes out user's email address and tries to find their gravatar image.
  $("#email").bind("keyup", function(){
    if($("#gravitar").attr("checked")){
      $("#profile_image img").attr("src", ("http://www.gravatar.com/avatar/" + $.md5($(this).attr("value"))));
    }
  });
  
  // Handles row striping of any list items within a div with a class of list.
  $(".list li").each(function(i){
    if(i % 2 == 0 && !$(this).hasClass("current")){
      $(this).css({backgroundColor: "#333333"});
    }
  });
  
  // Handles hiding and showing of view tasks links on personal homepage.
  $("#projects a.view_more").hide();
  $("#projects li.current a.view_more").html("viewing tasks &rarr;").show();
  $("#projects ul li").bind("mouseenter", function(){
    $(this).children("a.view_more").show();
  });
  $("#projects ul li").bind("mouseleave", function(){
    if(!$(this).hasClass("current")){
      $(this).children("a.view_more").hide();
    }
  });
  
  // Handles the width the background tab on any div with a class of list.
  $(".list").each(function(){
    var $this = $(this);
    var total = $this.width() - $this.children("h2:eq(0)").width() - 71;
    $this.children("h2:eq(1)").css({width: total});
  });
  
  // Handles inline editing on project page.
  $(".information form").hide();
  $(".information a.edit").bind("click", function(){
    $(".information a.edit").hide();
    $(this).parent().hide().next("form").show();
    return false;
  });
  
  // Handles the hiding and showing of all modal panels.
  $(".modal_link").bind("click", function(){
    $(".modal." + $(this).attr("href")).show();
    $("#darknessification").show();
    return false;
  });
  $("#darknessification, .cancel").bind("click", function(){
    $("#darknessification").hide();
    $(".modal").hide();
    return false;
  });
  
  // Handles clicking on the stars to set priority when creating a task.
  $("#priority a").bind("click", function(){
    var index = $(this).attr("href");
    $("#priority a").html("&#9734;").css({fontSize: "14px"});
    for(var i = 0; i < index; i++){
      $("#priority a:eq("+i+")").html("&#9733;").css({fontSize: "16px"});
    }
    $(this).parent("p").next("input[type=hidden]").attr("value", $(this).attr("href"));
    return false;
  });
  
  // Handles the portfolio page accordian style list.
  $(".portfolio ul li p.title").css({cursor: "pointer"});
});