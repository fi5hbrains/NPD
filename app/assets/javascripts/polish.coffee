$(document).on 'ready page:load', ->  
  $('#layers').on 'click', '.sliderV, .colour', ->
    $('#changes_' + $(this).parentsUntil('#layers','.layer').find('.orderingField').val()).val('1') 
  $('#sliderBaseOpacity, #labelsBaseOpacity').click ->
    $('#changes_0').val('1')

  $('.removeLayer').click ->
    $(this).initRemove()
      
  baseSlider = document.getElementById('sliderBaseOpacity')
  if baseSlider
    baseInput = document.getElementById('baseOpacity')
    noUiSlider.create baseSlider,
      start: baseInput.value
      step: 12.5
      connect: 'lower'
      range:
        'min': 0
        'max': 99
    baseSlider.noUiSlider.on 'update', (values, handle) ->
      baseInput.value = values[handle]
    document.getElementById('waterVal').addEventListener 'click', ->
      baseSlider.noUiSlider.set 0
    document.getElementById('juiceVal').addEventListener 'click', ->
      baseSlider.noUiSlider.set 25
    document.getElementById('syrupVal').addEventListener 'click', ->
      baseSlider.noUiSlider.set 50
    document.getElementById('jellyVal').addEventListener 'click', ->
      baseSlider.noUiSlider.set 75
    document.getElementById('creamVal').addEventListener 'click', ->
      baseSlider.noUiSlider.set 100 
    $('.sliderV').each ->
      $(this).initVSlider()

  $('.colour').colorPicker()
  
  $('.add_layer').click (e) ->
    e.preventDefault()
    $layers = $('#layers')
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    currentOrdering = $layers.find('.layer').size()
    if currentOrdering >= 2
      $layers.prepend("<svg class='iSwap' data-ordering='" + currentOrdering + "'><use xlink:href='#swap'/></svg>")
    $layers.prepend $(this).data('fields').replace(regexp, time)
    
    currentLayer = $layers.find('.layer').first()
    currentLayer.find('.orderingField').val(currentOrdering)
    currentLayer.find('label.uncheckable').uncheckableRadioLabel()
    currentLayer.find('.colour').colorPicker()
    $('#changes').prepend('<input type="hidden" name="changes[' + currentOrdering + ']" id="changes_' + currentOrdering + '">')
    $('#changes_' + currentOrdering).val('1')
    currentLayer.find('.sliderV').each ->
      $(this).initVSlider()
    currentLayer.slideDown(500)
    currentLayer.find('.removeLayer').click ->
      $(this).initRemove()
      
  $('#layers').on 'click', '.iSwap', ->
    ordering = $(this).data('ordering')
    prevLayer =  $(this).prevAll('.layer').first()
    nextLayer =  $(this).nextAll('.layer').first()
    nextLayer.find('.orderingField').val(ordering)
    prevLayer.find('.orderingField').val(ordering - 1)
    $(this).before(nextLayer)
    $(this).after(prevLayer)
    nextLayer.removeClass('upped downed')
    setTimeout (-> nextLayer.addClass 'upped' ), 5
    prevLayer.removeClass('downed upped')
    setTimeout (-> prevLayer.addClass 'downed' ), 5
    
    prevImage = $('#layer_' + ordering)
    nextImage = $('#layer_' + (ordering - 1))
    prevImage.attr('id', 'layer_' + (ordering - 1))
    nextImage.attr('id', 'layer_' + ordering)
    nextImage.before prevImage
(($) ->  
  $.fn.initRemove = ->
    currentLayer = $(this).closest('.layer')
    $(this).next('input').val('1')
    $('#changes_' + currentLayer.find('.orderingField').val()).remove()
    $iSwap = undefined
    if currentLayer.next('.iSwap').size() == 0
      $iSwap = currentLayer.prev('.iSwap')
    else
      $iSwap = currentLayer.next('.iSwap')
    $iSwap.slideUp 100, ->
      $iSwap.remove()        
    currentLayer.slideUp 500, ->
      $('#layers').after(currentLayer)
  return
) jQuery
(($) ->  
  $.fn.initVSlider = ->
    slider = this[0]
    link = $(slider).next()[0]
    noUiSlider.create slider,
      start: link.value
      connect: 'lower'
      step: 1
      orientation: 'vertical'
      direction: 'rtl'
      range:
        'min': 0
        'max': 99
    slider.noUiSlider.on 'update', (values, handle) ->
      link.value = values[0]
  
    if $.inArray('pMagnet_intensity', slider.classList) >= 0
      slider.noUiSlider.on 'slide', (values, handle) ->
        magnets = $(slider).parent().parent().parent().find('.magnets')
        if values[0] > 0 then magnets.show(300) else magnets.hide(300)
        return
    return  
) jQuery    