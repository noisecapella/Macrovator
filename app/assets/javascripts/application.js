// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require tinymce-jquery

//  sdf= require_tree .

//function add_fields(link, association, content) {
//    var new_id = new Date().getTime();
//    var regexp = new RegExp("new_" + association, "g");
//    $(link).parent().append(content.replace(regexp, new_id));
//}

function update_content(data) {
    var content = $('#textarea_content');
    tinyMCE.activeEditor.setContent(data["content"]);

    var info = $('#info');
    info.html(data["info"]);

    var sidebar = $('#sidebar');
    sidebar.html(data["sidebar"]);
}


function cursorAnimation()
{
    $("#textarea_content_ifr").contents().find(".cursor").animate(
	{opacity: 1}).animate(
	    {opacity: 0});
	
}


$(document).ready(function() {
    $("#action_type_action_type").live('ajax:success', function(evt, data, status, xhr) {
	    var fields = $('#argument_fields');
	
	    fields.html(data);
	});


    $("#execute_link").live("ajax:success", function(evt, data, status, xhr) {

	update_content(data);
	});

    $("#reset_selected").live("ajax:success", function(evt, data, status, xhr) {

	update_content(data);
    });

    setInterval("cursorAnimation()", 600);
});

tinyMCE.init({
    mode: "textareas",
    theme: "advanced",
    content_css: "/assets/application.css?body=1",
    readonly: true
});
