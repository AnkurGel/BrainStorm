//=require jquery
$(document).ready(function(){
  wave_left();
  $("#left_dial img").click(function(){
    $(this).addClass('rotate');
    $(this).add("#right_dial").parent().delay(2000).fadeOut();
    link = $("input#_home").attr('name')
    window.location.href = link
  });
});
function wave_left(){
  $("img#wave_left").animate({left:"-=30px"}, 400);
  $("img#wave_right").animate({left:"+=30px"}, 400);
  setTimeout("wave_right()", 1000);
}
function wave_right() {
  $("img#wave_left").animate({left:"+=30px"}, 400);
  $("img#wave_right").animate({left:"-=30px"}, 400);
  setTimeout("wave_left()", 1000);
}
