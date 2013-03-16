# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $.fn.add_image_fields = ->
    $(this).on 'click', (event) -> 
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).before($(this).data('fields').replace(regexp, time))
      event.preventDefault()
    this
  $('form .add_fields').add_image_fields()
    
  $.fn.remove_image_fields = ->
    $(this).on 'click', (event) ->
      $(this).prev('input[type=hidden]').val('1')
      $(this).closest('fieldset').hide()
      event.preventDefault()
    this

  $('form .remove_fields').remove_image_fields()
  
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $(".links_hover").on 'click', (event) ->
    $(this).parent().next().toggle('fast')
    $(this).toggleClass('red')

  $(".display-image").on 'click', (even) ->
    $(@).toggleClass 'display-image-toggle'

  $(".icon-info-sign").on 'click', (event) ->
    $('.hint').toggleClass 'hint_toggle', 1000

  $(".optional > span").on 'click', (event) ->
    $(this).siblings().slideToggle()
    
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

    
    
  $('.hide_div_toggle').on 'click', (event) ->
    $(this).next().fadeToggle()

  if($("#user_observe_chart").size() == 1)
    Morris.Bar
      element: 'user_observe_chart'
      data: $("#user_observe_chart").data("attempts")
      xkey: 'level_id'
      ykeys: ['max_attempts']
      labels: ['Attempts']

    Morris.Line
      element: 'user_attempts_timeline_chart'
      data: $("#user_attempts_timeline_chart").data("user-attempts-timeline")
      xkey: 'created_at'
      ykeys: ['level_id']
      labels: ['Level']
  Morris.Bar
    element: 'level_attempt_chart'
    data: $("#level_attempt_chart").data('attempts')
    xkey: 'level_id'
    ykeys: ['top_user_attempts', 'second_user_attempts', 'third_user_attempts', 'current_user_attempts']
    labels: ['Top ranker attempts', "2nd ranker's attempts", "3rd ranker's attempts", "Your attempts"]
    
  Morris.Line
    element: 'registration_chart'
    data: $("#registration_chart").data('registrations')
    xkey: 'date'
    ykeys: ['total_ids']
    labels: ['registrations']
    xLabels: ['day']
    
  Morris.Bar
    element: 'colleges_bar_chart'
    data: $("#colleges_bar_chart").data('colleges')
    xkey: 'college'
    ykeys: ['id', 'score']
    labels: ['Registrations', 'Max Score']
    
  Morris.Bar
    element: 'colleges_signins'
    data: $("#colleges_bar_chart").data('colleges')
    xkey: 'college'
    ykeys: ['signins']
    labels: ['Total signins']
    barColors: ['#4da74d']

  Morris.Donut
    element: 'colleges_donut'
    data: $("#colleges_donut").data('colleges')
    ###formatter: (y, d) -> y + '%'###
    
  Morris.Donut
    element: 'attempts_per_level_chart'
    data: $("#attempts_per_level_chart").data('attempts')
    formatter: (y,d) -> ["Attempts: " + y]
    
  Morris.Bar
    element: 'attempts_per_level_line_chart'
    data: $("#attempts_per_level_chart").data("attempts")
    xkey: 'label'
    ykeys: ['value']
    labels: ['Attempts']
    barColors: ['#1e1e1e']
    
  Morris.Donut  
    element: 'fb_non_fb_users_chart'
    data: $("#fb_non_fb_users_chart").data('fb')
