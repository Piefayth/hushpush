$(document).ready(function(){
	$(".well-content").each(function(){
		ajaxLoad.push($(this).parent().attr("id"));
		ajaxLoad.push($(this).attr("data-widget-name"));
	});
	var loadedObject = [];
	var requests = [];
	$(".well-content").each(function(){
		loadedObject.push($(this))
		requests.push($.getScript($(this).attr("data-widget"), function(){
		}));
	});
	var defer = $.when.apply($, requests);
	defer.done(function(){
		$.each(loadedObject, function(index, value){
			bindNote(value);
		})
	});

	return false;
});

function bindNote(this_note){
    this_note.find('.notes-text').change(function(){
		this_note.find('.notes-form').trigger("submit.rails");
	});
}