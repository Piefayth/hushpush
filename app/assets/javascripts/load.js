$(document).ready(function(){
	$(".well-content").each(function(){
		ajaxLoad.push($(this).parent().attr("id"));
		ajaxLoad.push($(this).attr("data-widget-name"));
	});
	$(".well-content").each(function(){
		$.getScript($(this).attr("data-widget"), function(){

		});
	});
	return false;
});