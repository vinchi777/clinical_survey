$(function(){
  $(".surveylink").live("click", function(){
    var id =$(this).attr("id");
    $.get("/user_surveys/" + id,function(data){
      data += "<div class='clear'><button class='btn right' id='view' value='" + id + "'>View</button><button class='btn right' id='edit' value='" + id + "'>Edit</button></div>";
      $("#survey").html(data);
      $("#survey").hide();
      $("#survey").fadeIn(1000);
      return false;
    });
  });

  $(".surveylink").hover(function(){ $(this).css("background-color","#D2D2D2"); $(this).css("cursor", "pointer"); },
                         function(){ $(this).css("background-color","transparent")});
  $(".notice, .info, .alert, .error").fadeOut(5000);
  $("#view").live("click",function(){
    $("#page").load("/user_surveys/"+$(this).val(), function(){
     $('a#back_btn').toggleClass('hide');
    });
  });
  $("#edit").live("click",function(){
    window.location= "/user_surveys/" + $(this).val() + "/edit";
  });
});

