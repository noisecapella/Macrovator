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
//= require jquery-ui

//  sdf= require_tree .

//function add_fields(link, association, content) {
//    var new_id = new Date().getTime();
//    var regexp = new RegExp("new_" + association, "g");
//    $(link).parent().append(content.replace(regexp, new_id));
//}

var KEYBOARD_ARRAY = [];
var IS_RECORDING = false;

function update_content(data) {
    var content = $('#content');
    content.html(data["content"]);

    var info = $('#info');
    info.html(data["info"]);

    var sidebar = $('#sidebar');
    sidebar.html(data["sidebar"]);
}


function cursorAnimation()
{
   /* $(".cursor").animate(
	{opacity: 1}).animate(
	    {opacity: 0});*/

    $(".cursor").animate({borderLeftColor:"#FFFFFF"}).animate({borderLeftColor:"#000000"});
	
}

function sendKeystrokes()
{
    if (KEYBOARD_ARRAY.length > 0)
    {
	// TODO: if this fails, do a check to resend it later
	$.post("/action_lists/keystrokes", {keys : KEYBOARD_ARRAY});
	KEYBOARD_ARRAY.splice(0, KEYBOARD_ARRAY.length);
    }

    setTimeout("sendKeystrokes()", 200);
}

$(document).ready(function() {
    setInterval("cursorAnimation()", 600);

    $("#stop_recording").hide();

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
    $("#clear_link").live("ajax:success", function(evt, data, status, xhr) {

	update_content(data);
    });
    $("#record_keystrokes_link").live("ajax:success", function(evt, data, status, xhr) {

	update_content(data);
    });

    $(document).keydown(function(e)
			 {
			     if (IS_RECORDING)
			     {
				 KEYBOARD_ARRAY.push({"keydown": e.which});
				 return false;
			     }
			 });
    $(document).keypress(function(e)
			 {
			     if (IS_RECORDING)
			     {
				 KEYBOARD_ARRAY.push({"keypress": e.which});
				 return false;
			     }
			 });

    setTimeout("sendKeystrokes()", 200);

});

function bind_record_keystrokes()
{
    $("#record_keystrokes_div").bind('click', function() {
	if (!IS_RECORDING)
	{
		

	    $("#record_keystrokes").html('<%= (link_to "Stop recording", url_for(:controller => :action_lists, :action => :status, :id => @datum.action_list.id), :remote => true, :id => "record_keystrokes_link").to_json %>');
	    IS_RECORDING = true;

	    KEYBOARD_ARRAY = [];
	}
	else
	{
	    IS_RECORDING = false;
	    $("#record_keystrokes").html('<%= (link_to "Record keystrokes", url_for(:controller => :action_lists, :action => :status, :id => @datum.action_list.id), :remote => true, :id => "record_keystrokes_link").to_json %>');
	}
    });

}