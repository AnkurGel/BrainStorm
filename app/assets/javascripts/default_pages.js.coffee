# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $(".links_hover").on 'click', (event) ->
    $(this).parent().next().toggle('fast')
    $(this).toggleClass('red')

  $(".display-image").on 'click', (even) ->
    $(@).toggleClass 'display-image-toggle'

  $(".icon-info-sign").on 'click', (event) ->
    $('.hint').fadeToggle()
    
  map = {}
  selectedItem = ""
  $("#user_college_id").typeahead
    source: (query, process) ->
      data = colleges
      list = []
      map = {}

      $.each colleges, (i, collg) ->
        map[collg.name] = collg
        list.push(collg.name)
      process(list)
      list

    updater: (item) ->
      selectedItem = map[item].id
      item

   $("input[value='Sign Up']").on 'click', (event) ->
     $("#user_college_id").val(selectedItem)
   $("input[value='Update']").on 'click', (event) ->
     $("#user_college_id").val(selectedItem)