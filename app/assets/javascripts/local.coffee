$(document).on 'ready page:load', ->
  $('#user_name').doneTyping ->
    field = $(this)
    $.ajax 
      url: '/'
      data: field.serialize() + '&active=' + document.activeElement.getAttribute('id')
      type: 'POST'
      dataType: "script"
      
  $('#user_password').on 'focus', ->
    $('#status').text('close eyes')
  $('#user_password').focusout ->
    $('#status').text('stare')
  $('#user_name').on 'focus', ->
    $('#status').text('smile')

  $('textarea.resizable').each ->
    textareaResize this
  $('textarea.resizable').on 'keyup keypress paste', ->
    textareaResize this
    
  spreadSlider = document.getElementById('sliderSpread')
  if spreadSlider
    noUiSlider.create spreadSlider,
      start: $(spreadSlider).data('start')
      step: 1
      connect: 'lower'
      range:
        'min': 70
        'max': 99
        
    spreadSlider.noUiSlider.on 'change', ->
      $.ajax 
        url: '/find_related'
        data: 'polish_id=' + $(spreadSlider).data('polish_id') + '&spread=' + (100 - spreadSlider.noUiSlider.get())
        type: 'GET'
        dataType: "script"
      
  $('#boxNameField').doneTyping (->
    $.ajax 
      url: '/boxes/' + $(this).data('id')
      data: $(this).serialize()
      type: 'PATCH'
      dataType: "script"
  ), 300
  
  $('#noteBody').doneTyping (->
    $.ajax 
      url: '/note/' + $('#note').data('polish_id')
      data: $(this).serialize()
      type: 'POST'
      dataType: "script"
  ), 2e3
  $('#trashNote').click ->
    $('#noteBody').val('')
    $.ajax 
      url: '/note/' + $('#note').data('polish_id')
      data: $(this).serialize()
      type: 'POST'
      dataType: "script"

  $('#invites').on 'mouseenter', '.selectable', ->
    SelectText $(this)
    return

textareaResize = (element) ->   
  if element 
    $(element).next('pre').find("span").text(element.value.replace(/\r\n/g, "\n") + ' ')
  
# stackoverflow.com/questions/985272 
SelectText = (element) ->
  doc = document
  text = element[0]
  range = undefined
  selection = undefined
  if doc.body.createTextRange
    range = doc.body.createTextRange()
    range.moveToElementText text
    range.select()
  else if window.getSelection
    selection = window.getSelection()
    range = doc.createRange()
    range.selectNodeContents text
    selection.removeAllRanges()
    selection.addRange range
  return
    