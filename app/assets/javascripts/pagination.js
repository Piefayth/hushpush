$(function bind_rss_page_handler(){
	$(".rss .well-content").on("click", '.pagination a', function(){
		ajaxParams = $(this).parent().parent().parent().parent().parent().parent().attr('id');
		var script = this.href;
		$.getScript(script);
		return false;
	});
});