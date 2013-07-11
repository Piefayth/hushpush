$(document).ready(function(){
	var loadedObject = [];
	var requests = [];
	$(".well-content").each(function(){
		loadedObject.push($(this))
		requests.push($.getScript($(this).attr("data-widget")));
	});
	var defer = $.when.apply($, requests);
	defer.done(function(){
		$.each(loadedObject, function(index, value){
			bindNote(value);
			//Add additional things that need bound here.
			//bindNote() only binds events to the Notes widget.
		})
	});

	return false;
});

function bindNote(this_note){
    this_note.find('.notes-text').change(function(){
		this_note.find('.notes-form').trigger("submit.rails");
	});
}