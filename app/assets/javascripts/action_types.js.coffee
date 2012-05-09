# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
        $("#action_type_action_type").live('ajax:success', (evt, data, status, xhr) ->
                fields = $('#argument_fields')

                fields.html(data)
        )

