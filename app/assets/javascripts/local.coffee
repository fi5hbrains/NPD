$(document).on 'ready page:load', ->
  tmpColour = document.getElementById('tmpColour')
  if tmpColour
    $(tmpColour).colorPicker({body: document.getElementById('tmpColour'), scrollResize: false, cssAddon: '.colourPicker{position:relative;top:0 !important;left:0 !important;background:none;width:290px;padding:0;border:none;margin:0}.cp-xy-slider{width:calc(100% -56px);height:238px}.cp-z-slider{height:238px}', animationSpeed: 0})
    $(tmpColour).focus().click()
    $('#colourFieldWrapper').prepend($('.colourPicker').css('top','').css('left',''))
  getRef = document.getElementById('getRef')
  if getRef
    $(getRef).prepend('<svg height="64" width="64"><rect class="strokeMed strokeActive noFill" stroke-width="4" stroke-dasharray="13.5,6" stroke-dashoffset="7" rx="4" height="61" width="61" y="2" x="2" stroke-width="4" fill="none"/><path opacity="0.3" d="m12,23c5,2,7,1,8-2l3-8c2-5-1-7-4-8-2-1-6.2-1.98-8,3l-3,8c-1,2-1,5,4,7zm32,34c2,4,4,4,6,3l7-4c4-2,3-6,2-8s-4-4-8-2l-7,4c-2,1-2,3,0,7zm-2-19c3,3,6,3,8,1l6-6c3-3,2-7,0-9s-6-3-9,0l-6,6c-2,2-2,5,1,8zm-10-16c4,2,7,2,8,0l5-9c2-3-1-7-3-8-3-2-7-1-9,3l-4.38,7.94c-1.6,2.1-0.6,4.1,3.4,6.1zm-4,41-26-18,0-39,3,13c1,5,8,8,12,7s5.98-7.6,8-14c-1,5,1,8,3,10,4,4,9,5,12,3-3,4-4.6,7.3-2,11,5.16,7.6,8,7,12,6-5,3-8,4-9,8-1,6,2,12,10,13z" /><path class="strokeMed strokeActive" stroke-width="4" d="m25,34,14,0" /><path class="strokeMed strokeActive" stroke-width="4" d="M32,41,32,27" /></svg>')

  $('#user_name').doneTyping ->
    field = $(this)
    $.ajax 
      url: '/'
      data: field.serialize() + '&active=' + document.activeElement.getAttribute('id')
      type: 'POST'
      dataType: "script"
      
  $('.cBox').on 'click', ->
    $($(this).data('field')).val($(this).data('colour')).trigger('change')
    
  $('#user_password').on 'focus', ->
    unless $('#status').text() == 'explain error'
      $('#status').text('look away')
  $('#user_password').focusout ->
    $('#status').text('stare')
  $('#user_name').on 'focus', ->
    unless $('#status').text() == 'explain error'
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
      colourField = document.getElementById('colour')
      if colourField
        colour = $(colourField).val()
      $.ajax 
        url: '/find_related'
        data: 'polish_id=' + $(spreadSlider).data('polish_id') + '&spread=' + (100 - spreadSlider.noUiSlider.get()) + '&colour=' + colour
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

  $(document).on 'mouseenter click', '.selectable', ->
    SelectText $(this)
    return
  refImg = $('#referenceImage')
  refImg.on 'click', ->
    $('#output').select()
    return
  refImg.on 'load', ->
    @canvas = false
    $(this).initReferencePicker()

$.fn.initReferencePicker = ->
  $zoomImage = $('#referenceZoomImage')
  realW = undefined
  realH = undefined
  kX = 0
  kY = 0
  $('<img/>').attr('src', $zoomImage.attr('src')).load ->
    realW = @width
    realH = @height
    $zoomImage.width(realW * 8).height(realH * 8)
    kX =  $zoomImage.width() / $('#referenceImage').width()
    kY =  $zoomImage.height() / $('#referenceImage').height()
    return

  $(this).mousemove (e) ->
    if !@canvas
      @canvas = $('<canvas />')[0]
      @canvas.width = @width
      @canvas.height = @height
      @canvas.getContext('2d').drawImage this, 0, 0, @width, @height
    pixelData = @canvas.getContext('2d').getImageData(e.offsetX, e.offsetY, 1, 1).data
    rgb = 'rgb(' + pixelData[0] + ', ' + pixelData[1] + ', ' + pixelData[2] + ')'
    $('#referenceZoom').css('background', rgb).css('left', e.pageX).css('top', e.pageY)
    $zoomImage.css('left', -1 * kX * e.offsetX + 40).css('top', -1 * kY * e.offsetY + 40)
    return    
  $(this).click (e) ->
    if !@canvas
      @canvas = $('<canvas />')[0]
      @canvas.width = @width
      @canvas.height = @height
      @canvas.getContext('2d').drawImage this, 0, 0, @width, @height
    pixelData = @canvas.getContext('2d').getImageData(event.offsetX, event.offsetY, 1, 1).data
    rgb = 'rgb(' + pixelData[0] + ', ' + pixelData[1] + ', ' + pixelData[2] + ')'
    $($(this).data('field')).val(rgb).css('background', rgb).trigger('change')
    return  
  $(this).mouseenter ->
    $('#referenceZoom').show()
  $(this).mouseleave ->
    $('#referenceZoom').hide()
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
    