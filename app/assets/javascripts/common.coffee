$(document).on 'ready page:load', ->
  $window = $(window)
  $document = $(document)
  navTolerance = 20
  navOffset = 50
  $nav = $('#navBar')
  navHeight = $nav.outerHeight()
  lastY = 0
  $window.scroll ->
    y = $window.scrollTop()    
    return  if y < 0 or y > ($document.height() - $window.height())
    if (y < lastY && lastY - y > navTolerance) || y < navOffset
      $nav.removeClass('unpin')
    else if (y > lastY && y - lastY > navTolerance + 20)
      $nav.addClass('unpin')
    lastY = y

  $('input:radio.uncheckable').uncheckableRadio()
  $('label.uncheckable').uncheckableRadioLabel()

  icons = new XMLHttpRequest
  icons.open 'GET', 'icons_common.xml', true
  icons.send()
  icons.onload = (e) -> $('#defs').html( icons.responseText )
    
  $('input[name=polish], input[name=brand]').doneTyping ->
    $.ajax 
      url: '/autocomplete'
      data: $(this).closest('.searchWrapper').serialize() + '&id=' + $(this).closest('.search').attr('id')
      type: 'GET'
      dataType: "script"

  $('.searchWrapper').submit (event) ->
    skipBlanks $(this)

  $('input[data-updatable=true]').on 'change', -> $(this).closest('form').find('[name=preview]').click()
   
  $('[name=preview]').click (e) ->
    if $(this).attr('name') == 'preview'
      e.preventDefault()
      f = $(this).closest('form')
      formData = new FormData(f[0])
      formData.append("preview", "true")
      $.ajax 
        url: f.attr('action')
        data: formData
        type: 'POST'
        cache: false
        contentType: false
        processData: false
        dataType: "script"
        
  $('.switch[data-activate]').click (e) -> 
    e.preventDefault()
    $($(this).attr('data-activate')).toggleClass('active')
    
  $('.switch[data-activate]').hover (->
    $($(this).attr('data-activate')).addClass 'hover'
    return
  ), ->
    $($(this).attr('data-activate')).removeClass 'hover'
    return
    
  gotBack = false      
  $('.notCurrent').click ->
    menu = $(this).parent()
    if menu.attr('id') != 'boxesList'
      setTimeout (->
        menu.removeClass('active')
      ), 300
    
  $('.furlable').mouseleave ->
    menu = $(this)
    if menu.hasClass('active')
      gotBack = false      
      setTimeout (->
        if gotBack == false
          menu.removeClass('active')
      ), 1000
      menu.mouseenter ->
        gotBack = true

  range = undefined
  rangeWidth = undefined
  $(document).on 'mouseenter', '.voteBox', (->
    containerWidth = $(this).width()
    offset = $(this).offset().left
    w = undefined
    rating = undefined
    range = $(this).find('.stars.absolute')
    rangeWidth = range.width()
    range.attr 'class', (index, classNames) ->
      classNames + ' active'
    $(this).mousemove (e) ->
      rating = Math.round((e.pageX - offset) * 5 / containerWidth + 0.5)
      w = rating * 20 + '%'
      range.width(w)
    $(this).on 'click', -> 
      rangeWidth = w
      range.attr 'class', (index, classNames) ->
        classNames + ' voted'
      $.ajax 
        url: '/vote/Polish/' + range.data('id')
        type: 'POST'
        data: { vote: rating }
        dataType: "script"
  )
  $(document).on 'mouseleave', '.voteBox', ->  
    range.attr 'class', (index, classNames) ->
      classNames.replace ' active', ''
    range.width(rangeWidth)
    $(this).unbind( 'click' )
  
  $('.getBottlingStatus').each ->
    $this = $(this)
    $.poll (retry) ->
      $.get '/bottling_status/' + $this.closest('[data-id]').data('id'), (response, status) -> 
        if status != 'success'
          retry()
        return
      return
      
skipBlanks = (element) ->
  element.find(':input[type="text"]').each (->
    if $(this).val() == ''
      $(this).attr('disabled','true')
  )
  
(($) ->
  # http://stackoverflow.com/questions/14042193
  $.fn.extend doneTyping: (callback, timeout) ->
    timeout = timeout or 5e2
    timeoutReference = undefined

    doneTyping = (el) ->
      if !timeoutReference
        return
      timeoutReference = null
      callback.call el
      return

    @each (i, el) ->
      $el = $(el)
      $el.is(':input') and $el.on('keyup keypress paste', (e) ->
        if e.type == 'keyup' and e.keyCode != 8
          return
        if timeoutReference
          clearTimeout timeoutReference
        timeoutReference = setTimeout((->
          doneTyping el
          return
        ), timeout)
        return
      ).on('blur', ->
        doneTyping el
        return
      )
      return
  return
) jQuery

(($) ->
  $.fn.uncheckableRadio = ->
    @each ->
      radio = this
      $(radio).mousedown ->
        $(radio).data 'wasChecked', radio.checked
        return
      $(radio).click ->
        if $(radio).data('wasChecked')
          radio.checked = false
        $(radio).ifExternal()
        return
      return
  return
) jQuery
(($) ->  
  $.fn.uncheckableRadioLabel = ->
    @each ->
      label = this
      radio = $('#' + $(label).attr('for'))[0]
      $(label).mousedown ->
        $(radio).data 'wasChecked', radio.checked
        return
      $(label).click ->
        if $(radio).data('wasChecked')
          radio.checked = false
        return
      return
  return
) jQuery
(($) ->  
  $.fn.ifExternal = ->
    if this.hasClass('external')
      this.add(this.siblings('input[type=radio]')).each ->
        if this.checked
          $('label[for=' + this.id + ']').addClass('active')
        else
          $('label[for=' + this.id + ']').removeClass('active')
  return
) jQuery
