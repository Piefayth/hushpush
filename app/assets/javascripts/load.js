$(document).ready(function(){
	$(".well-content").each(function(){
		//alert($(this).attr("data-widget"));
		ajaxLoad.push($(this).parent().attr("id"));
		ajaxLoad.push($(this).attr("data-widget-name"));
	});
	$(".well-content").each(function(){
		$.getScript($(this).attr("data-widget"));
		return false;
	});
});