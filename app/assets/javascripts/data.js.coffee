# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

root = exports ? this

KEYBOARD_ARRAY = [];
IS_RECORDING = false;

update_content = (data) ->
    content = $('#content');
    content.html(data["content"]);

    info = $('#info');
    info.html(data["info"]);

    sidebar = $('#sidebar');
    sidebar.html(data["sidebar"]);



cursorAnimation = () ->
    $(".cursor").animate({borderLeftColor:"#FFFFFF"}).animate({borderLeftColor:"#000000"});
    $(".rcursor").animate({borderLeftColor:"#FFFFFF"}).animate({borderLeftColor:"#000000"});

sendKeystrokes = () ->
    if KEYBOARD_ARRAY.length > 0
        # TODO: if this fails, do a check to resend it later
        $.post("/action_lists/keystrokes", {keys : KEYBOARD_ARRAY}, (data) ->
               update_content(data));
        KEYBOARD_ARRAY.splice(0, KEYBOARD_ARRAY.length);

    setTimeout(sendKeystrokes, 200);

bind_record_keystrokes = () ->
    message_is_recording = '<a href="#" onclick="return false;" id="record_keystrokes_link">Stop recording</a>'
    message_stopped_recording = '<a href="#" onclick="return false;" id="record_keystrokes_link">Record keystrokes</a>'
    
    if IS_RECORDING
        $("#record_keystrokes_div").html(message_is_recording)
    else
        $("#record_keystrokes_div").html(message_stopped_recording)
        
    $("#record_keystrokes_link").bind('click', () ->
        if !IS_RECORDING
            $("#record_keystrokes_div").html(message_is_recording);
            IS_RECORDING = true;

            KEYBOARD_ARRAY = [];
        else
            IS_RECORDING = false;
            $("#record_keystrokes_div").html(message_stopped_recording);
        bind_record_keystrokes()
    );


$ ->
    setInterval(cursorAnimation, 600);

    $("#stop_recording").hide();

    $("#action_type_action_type").live('ajax:success', (evt, data, status, xhr) ->
            fields = $('#argument_fields');
        
            fields.html(data);
        );

    do_update_content = (evt, data, status, xhr) ->
        update_content(data);
        

    $("#execute_link").live("ajax:success", do_update_content)

    $("#reset_selected").live("ajax:success", do_update_content)
    $("#clear_link").live("ajax:success", do_update_content)
    $("#record_keystrokes_link").live("ajax:success", do_update_content)

    $(document).keypress((e) ->
                             alert("keypress" + e.which)
                             if IS_RECORDING
                                 KEYBOARD_ARRAY.push({"keypress": e.which or e.keyCode})
                                 false)
    $(document).keydown((e) ->
                            # alert("keydown" + e.which
                            if IS_RECORDING
                                KEYBOARD_ARRAY.push({"keydown": e.which or e.keyCode})
                                false)

    setTimeout(sendKeystrokes, 200);
    bind_record_keystrokes()

root.bind_record_keystrokes = bind_record_keystrokes

