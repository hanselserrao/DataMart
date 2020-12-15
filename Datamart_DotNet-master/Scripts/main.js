//$(function() {
//$(".tab1")
//$("a").click(function(){
//	var tabs=$(this).attr("href");
//	$(tabs).show();
//	$(tabs).sibling().hide();
// });
//});


$('a').on('click', function(){
   var target = $(this).attr('rel');
   $("#"+target).show().siblings("div").hide();
});

$(document).ready(function(){
  $('ul li').click(function(){
    $('li').removeClass("active");
    $(this).addClass("active");
});
});

$(".input").focus(function() {
	 		$(this).parent().addClass("focus");
	 	})