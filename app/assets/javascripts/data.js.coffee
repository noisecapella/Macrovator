# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

root = exports ? this

KEYBOARD_ARRAY = [];
IS_RECORDING = false;
CTRL_KEY = false
ALT_KEY = false
SHIFT_KEY = false

update_content = (data) ->
        content = $('#content')
        content.html(data["content"])

        info = $('#info')
        info.html(data["info"])

        sidebar = $('#sidebar')
        sidebar.html(data["sidebar"])



cursorAnimation = () ->
        $(".cursor").animate({opacity:"1"}).animate({opacity:"0"})
        # $(".rcursor").animate({borderLeftColor:"#FFFFFF"}).animate({borderLeftColor:"#000000"})

sendKeystrokes = () ->
        if KEYBOARD_ARRAY.length > 0
                # TODO: if this fails, do a check to resend it later
                url = $("#record_keystrokes_hidden_form").attr('action')
                $.post(url, {keys : KEYBOARD_ARRAY}, (data) ->
                        update_content(data))
                KEYBOARD_ARRAY.splice(0, KEYBOARD_ARRAY.length)

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
                        $("#record_keystrokes_div").html(message_is_recording)
                        IS_RECORDING = true

                        KEYBOARD_ARRAY = []
                else
                        IS_RECORDING = false
                        $("#record_keystrokes_div").html(message_stopped_recording)
                bind_record_keystrokes()
        )


popup_search = () ->
        result = prompt("Search for: ", "")
        if result
                url = $("#search_url_hidden_form").attr('action')
                action_type_obj = {"type" : "SearchActionType", "search_key" : result}
                $.post(url, {"action_type": action_type_obj}, (data) ->
                        update_content(data))

delete_action = () ->
        url = $("#delete_action_hidden_form").attr('action')
        $.post(url, {}, (data) ->
                update_content(data))

add_modifiers = (m, e) ->
        m["ctrl"] = true if e.ctrlKey
        m["alt"] = true if e.altKey
        # m["shift"] = true if e.shiftKey
        m["meta"] = true if e.metaKey

$ ->
        setInterval(cursorAnimation, 600)

        do_update_content = (evt, data, status, xhr) ->
                update_content(data);


        $("#execute_link").live("ajax:success", do_update_content)
        $("#execute_rest_link").live("ajax:success", do_update_content)
        $("#reset_selected").live("ajax:success", do_update_content)
        $("#clear_link").live("ajax:success", do_update_content)
        $("#record_keystrokes_link").live("ajax:success", do_update_content)

        $(document).keypress((e) ->
                # keep this list as short as possible, to avoid collisions
                if e.ctrlKey and !e.metaKey and !e.altKey and !e.shiftKey
                        if e.which == 101 # ctrl+e
                                $("#execute_link").trigger('click');
                                return false
                        else if e.which == 114 # ctrl+r
                                $("#record_keystrokes_link").trigger('click')
                                return false
                        else if e.which == 102 # ctrl+f
                                popup_search()
                                return false
                        else if e.which == 100 # ctrl+d
                                delete_action()
                                return false
                        else if e.which == 122 # ctrl+z
                                preform_undo()
                                return false


                else if IS_RECORDING and e.which != 0
                        m = {"keypress": e.which}
                        add_modifiers(m, e)
                        KEYBOARD_ARRAY.push(m)
                        return false
        )
        $(document).keydown((e) ->
                if IS_RECORDING
                        m = {"keydown": e.which or e.keyCode}
                        add_modifiers(m, e)
                        KEYBOARD_ARRAY.push({"keydown": e.which or e.keyCode})
                        false
        )

        setTimeout(sendKeystrokes, 200);
        bind_record_keystrokes()

        $("#datum_source_type").live('ajax:success', (evt, data, status, xhr) ->
                fields = $('#content_text')

                fields.html(data)
        )


root.bind_record_keystrokes = bind_record_keystrokes

