$(document).on 'ready page:load', ->  
  $('.layer').each ->
    initIcons($(this))
  
  getRef = document.getElementById('getRef')
  water = document.getElementById('water')
  juice = document.getElementById('juice')
  syrup = document.getElementById('syrup')
  jelly = document.getElementById('jelly')
  cream = document.getElementById('cream')
  if getRef
    getRef.innerHTML = '<svg height="64" width="64"><rect class="strokeMed strokeActive noFill" stroke-width="4" stroke-dasharray="13.5,6" stroke-dashoffset="7" rx="4" height="61" width="61" y="2" x="2" stroke-width="4" fill="none"/><path opacity="0.3" d="m12,23c5,2,7,1,8-2l3-8c2-5-1-7-4-8-2-1-6.2-1.98-8,3l-3,8c-1,2-1,5,4,7zm32,34c2,4,4,4,6,3l7-4c4-2,3-6,2-8s-4-4-8-2l-7,4c-2,1-2,3,0,7zm-2-19c3,3,6,3,8,1l6-6c3-3,2-7,0-9s-6-3-9,0l-6,6c-2,2-2,5,1,8zm-10-16c4,2,7,2,8,0l5-9c2-3-1-7-3-8-3-2-7-1-9,3l-4.38,7.94c-1.6,2.1-0.6,4.1,3.4,6.1zm-4,41-26-18,0-39,3,13c1,5,8,8,12,7s5.98-7.6,8-14c-1,5,1,8,3,10,4,4,9,5,12,3-3,4-4.6,7.3-2,11,5.16,7.6,8,7,12,6-5,3-8,4-9,8-1,6,2,12,10,13z" /><path class="strokeMed strokeActive" stroke-width="4" d="m25,34,14,0" /><path class="strokeMed strokeActive" stroke-width="4" d="M32,41,32,27" /></svg>'
  if water
    water.innerHTML = '<svg class="icon iSlider"><path stroke-opacity=".1" fill-opacity=".04" class="strokeActive" d="m20.7,7c0.2,0.3,0.3,0.8,0.3,1.5,0,3.5-1,1.5-1,3.5s1-1,1,5v1c0,4-1,4-2,4s-1-1-3-1-2,1-3,1-2,0-2-4v-1c0-6,1-3,1-5s-1,0-1-3.5c0-0.8,0.14-1.3,0.4-1.6z"/><path class="noFill strokeBase" d="m18,3v2c1.5,1.5,3,1,3,3.5,0,3.5-1,1.5-1,3.5s1-1,1,5v1c0,4-1,4-2,4s-1-1-3-1-2,1-3,1-2,0-2-4v-1c0-6,1-3,1-5s-1,0-1-3.5c0-2.5,1.5-2,3-3.5v-2"/><path class="strokeActive strokeMed" d="m13.5,2h5"/></svg>'
  if juice
    juice.innerHTML = '<svg class="icon iSlider"><path stroke-linejoin="round" d="M16,19,20,2,24,3" class="noFill strokeBase" stroke-linecap="round"/><path d="m12,22h8c1.5-4,1.9-7,2-11.5-6,4-6-4-12,0.5,0.2,4,0.5,7,2,11z" stroke-opacity="0.3" fill-opacity="0.2" class="strokeActive"/><path class="noFill strokeBase" d="m10,6c0,6,0,11,2,16h8c2-5,2-10,2-16z"/></svg>'
  if syrup
    syrup.innerHTML = '<svg class="icon iSlider"><path d="M22,11c4-2,0-8-4-4" class="noFill strokeBase" stroke="#bababa" stroke-linecap="round"/><rect rx="1" height="4" width="4" y="0" x="14"/><path stroke-linejoin="round" d="m9.7,14c-0.1,0.7-0.211,1.5-0.2,2.5,0,2.5,0.5,4.5,1.5,5.5h11c1-1,1.5-3,1.5-5.5,0-0.9,0-1.8-0.2-2.5z" stroke-opacity="0.5" fill-opacity="0.5" class="strokeActive"/><path stroke-linejoin="round" d="m11,2h2c1,2,2.3,1.8,2,7.5-4,0.5-5.5,2.5-5.5,7,0,2.5,0.5,4.5,1.5,5.5h11c1-1,1.5-3,1.5-5.5,0-4.5-1.5-6.5-5.5-7v-7.5h1z" class="noFill strokeBase"/></svg>'
  if jelly
    jelly.innerHTML = '<svg class="icon iSlider" fill-opacity=".45"><path d="m13,23c2,0,2,0,2.5-1h2c0.5,1,0.5,1,2.5,1s3.5-1,3.5-2c0-2,0.5-7-0.5-10-0.5-1.5-2-2.5-2-2.5,1.5-1.5,1.5-3,0.7-4,1.3-1.5,1.8-2.5,0.3-3.5s-2.5-1-4,0.5c-1-0.5-2-0.5-3,0-1.5-1.5-2.5-1.5-4-0.5s-1,2,0.3,3.5c-0.8,1-0.8,2.5,0.7,4,0,0-1.5,1-2,2.5-1,3-0.5,8-0.5,10,0,1,1.5,2,3.5,2z"/><ellipse cx="8" rx="3.3" ry="1.7" transform="translate(5,0)" cy="21"/><ellipse cx="15.1" rx="3.3" ry="1.7" transform="translate(5,0)" cy="21"/><ellipse cx="7.3" rx="2.2" ry="1.8" transform="translate(5,0)" cy="13"/><ellipse cx="15.5" rx="2.2" ry="1.8" transform="translate(5,0)" cy="13"/><ellipse cx="11.5" rx="5" ry="3.5" transform="translate(5,0)" cy="6"/><path d="m23,17c1,7-3,4.5-6.5,4.5s-7.5,2.5-6.5-4.5c0.6-4,1-10,6.5-10s5.9,6,6.5,10z"/><circle cy="16" transform="translate(5,0)" cx="11.5" r="5"/><ellipse cx="11.5" rx="3" ry="1.6" transform="translate(5,0)" cy="6"/></svg>'
  if cream
    cream.innerHTML = '<svg class="icon iSlider"><path class="fillBase" d="m19.5,17-1,4c-0.3,1 1.1,1.5 1.5,0l1-4c0.1-0.5-1.4-0.5-1.5,0zm-8.5,0 1,4c0.4,1.5 1.8,1 1.5,0l-1-4C12.4,16.5 10.8,16.4 11,2Zm4.2,0 0,4c0,1.5 1.6,1.5 1.6,0l0-4c0-0.5-1.6-0.5-1.6,0zm-3.7,6-2-7 13,0-2,7z"/><path d="M25,14c2-4-3-5-5-5,2.5-0.5,3-5-1-5-2,0-3.5-1-4-3-2,1-3,4-0.5,5.5-4-1-6.5,2-3.5,4.5-5-1-4.5,2-4,3s2,1,3,1h12c1.05,0,2.5,0,3-1z"/></svg>'

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
    initIcons(currentLayer)
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
 
initIcons = (element) ->
  element = if typeof element != 'undefined' then element else $(document)  
  
  sParticle_size = element.find('.sParticle_size')
  sParticle_density = element.find('.sParticle_density')
  sOpacity = element.find('.sOpacity')
  sHolo_intensity = element.find('.sHolo_intensity')
  sMagnet_intensity = element.find('.sMagnet_intensity')
  
  i = 0
  while i < sParticle_size.length
    sParticle_size[i].innerHTML = '<circle class="fillBase" cy="9" cx="18" r="8"/><circle cy="17" cx="8" r="3"/>'
    ++i
  i = 0
  while i < sParticle_density.length
    sParticle_density[i].innerHTML = '<path d="m11 2c-0.5 0-1 0.5-1 1s0.5 1 1 1c0.5 0 1-0.5 1-1s-0.5-1-1-1zm12 1c-0.5 0-1 0.5-1 1s0.5 1 1 1c0.5 0 1-0.5 1-1s-0.5-1-1-1zm-7 0c-0.5 0-1 0.5-1 1s0.5 1 1 1c0.56 0 1-0.5 1-1s-0.44-1-1-1zm4.01 2c-0.6 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1-0.5-1-1-1zm-9 1c-0.5 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1-0.5-1-1-1zm3 0c-0.5 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1-0.5-1-1-1zm0 3c0 0.5 0.5 1 1 1-0.5 0.05-1 0.5-1 1-0.5 0-1 0.5-1 1 0-0.5-0.5-1-1-1s-1 0.5-1 1c0 0.5 0.5 1 1 1 0.1 0.5 0.5 1 1 1s1-0.5 1-1c0.1 0.5 0.5 1 1 1 0.5 0 1-0.5 1-1 0 0.5 0.5 1 1 1-0.5 0-1 0.5-1 1 0 0.5 0.5 1 1 1 0.5 0 1-0.5 1-1 0.5 0 1-0.5 1-1 0 0.5 0.5 1 1 1 0.5 0 1-0.5 1-1 0-0.5-0.5-1-1-1 0-0.5-0.5-1-1-1 0-0.5-0.5-1-1-1 0.5-0.1 1-0.5 1-1h0.1c0.5 0 1.01-0.5 1-1s-0.5-1-1-1c-0.1-0.5-0.5-1-1-1-0.5 0-1 0.5-1 1s0.5 1 1 1c-0.5 0-1 0.5-1 1 0-0.5-0.5-1-1-1 0.5-0 1-0.5 1-1 0-0.5-0.5-1-1-1s-1 0.5-1 1c-0.5 0-1 0.5-1 1zm6 0c0 0.5 0.5 1 1 1s1-0.5 1-1c0-0.5-0.5-1-1-1s-1 0.5-1 1zm-4 6c0-0.5-0.5-1-1-1s-1 0.5-1 1 0.5 1 1 1 1-0.5 1-1zm-9-7c-0.5 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1-0.5-1-1-1zm6 0c-0.5 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1c0-0.5-0.45-1-1-1zm12 2c-0.5 0-1 0.5-1 1 0 0.5 0.5 1 1 1 0.5 0 1-0.5 1-1 0-0.5-0.5-1-1-1zm-3 1c-0.5 0-1 0.5-1 1s0.5 1 1 1c0.5 0 1-0.5 1-1s-0.5-1-1-1zm-13 1c-0.5 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1-0.5-1-1-1zm14 2c-0.5 0-1 0.5-1 1s0.5 1 1 1c0.5 0 1-0.5 1-1s-0.5-1-1-1zm-10 2c-0.5 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1-0.5-1-1-1zm7 3c0.5 0 1-0.5 1-1 0-0.5-0.5-1-1-1 0-0.5-0.5-1-1-1-0.5 0-1 0.5-1 1 0 0.5 0.5 1 1 1 0 0.5 0.5 1 1 1zm-11-1c-0.5 0-1 0.5-1 1s0.5 1 1 1 1-0.5 1-1-0.5-1-1-1zm14 0c-0.5 0-1 0.5-1 1s0.5 1 1 1c0.5 0 1-0.5 1-1s-0.5-1-1-1zm-8 2c-0.5 0-1 0.5-1 1s0.5 1 1 1c0.5 0 1-0.5 1-1s-0.5-1-1-1z"/>'
    ++i
  i = 0
  while i < sOpacity.length
    sOpacity[i].innerHTML = '<path fill-opacity=".7" d="m12 14h5c1.1 0 2-0.9 2-2v-5h-7z"/><rect fill-opacity=".3" class="strokeBase" rx="2" height="13" width="13" y="2" x="6"/><rect fill-opacity=".3" class="strokeBase" rx="2" height="13" width="13" y="7" x="12"/>'
    ++i
  i = 0
  while i < sHolo_intensity.length
    sHolo_intensity[i].innerHTML = '<path d="m9,19c0,0-2.2-11 7-11 9.2,0 7,11 7,11" class="noFill strokeActive strokeWide"/><path d="m10.5,18.5c0,0 -1.5-9 5.5-9 7,0 5.5,9 5.5,9M7,19.5C7,19.5 4,6 16,6c12,0 9,13.5 9,13.5" class="strokeBase noFill"/>'
    ++i
  i = 0
  while i < sMagnet_intensity.length
    sMagnet_intensity[i].innerHTML = '<path d="m7.5 4.5v5.5h5.04v-5.5zm12 0v5.5h5v-5.5z"/><path class="fillBase" d="m24.5 10c0 10-2.5 12.5-8.5 12.5s-8.5-2.5-8.5-12.5h5.04c0 4-0.5 7.5 3.5 7.5s3.5-3.5 3.5-7.5z"/>'
    ++i
    
  - if element.hasClass('lShimmer') 
    mStar = element.find('.mStar')
    mTree = element.find('.mTree')
    mHatch = element.find('.mHatch')
    mH_stripes = element.find('.mH_stripes')
    mD_stripes = element.find('.mD_stripes')

    i = 0
    while i < mStar.length
      mStar[i].innerHTML = '<svg class="icon iMid"><path d="m16 4.4c-4.8 0-9.7 0.4-10.4 1-1.5 1.5-1.5 19.4 0 20.9 1.5 1.4 19.3 1.4 20.8 0 1.5-1.5 1.5-19.4 0-20.9-0.7-0.7-5.6-1-10.4-1zm-0.2 1.2h0c0.6-0.1 1.1 0.4 1 1v6.7l2.2-2.2c0.2-0.2 0.4-0.3 0.6-0.3 0.8-0.1 1.4 1.2 0.8 1.7l-2.2 2.2h5c0.5 0 1 0.5 1 1s-0.6 1-1 1h-5l2.2 2.2c0.4 0.4 0.5 1 0 1.5-0.4 0.4-1.1 0.4-1.5-0.1l-2.2-2.2v6.7c0 0.5-0.5 1-1 1-0.5 0-1-0.5-1-1v-6.7l-2.2 2.2c-0.4 0.5-1 0.5-1.5 0.1-0.4-0.4-0.4-1.1 0-1.5l2.2-2.2h-4.9c-0.5 0-1-0.4-1.1-0.9s0.4-1 0.9-1.1h0.2 5l-2.2-2.2c-0.6-0.5-0.2-1.7 0.6-1.7 0.3 0 0.6 0.1 0.8 0.3l2.2 2.2v-6.7c0-0.5 0.4-0.9 0.8-1z"/></svg>'
      ++i
    i = 0
    while i < mTree.length
      mTree[i].innerHTML = '<svg class="icon iMid"><path d="m16 4.4c-4.8 0-9.7 0.4-10.4 1-1.5 1.5-1.5 19.4 0 20.9 1.5 1.4 19.3 1.4 20.8 0 1.5-1.5 1.5-19.4 0-20.9-0.7-0.7-5.6-1-10.4-1zm0.1 1.9c0.2 0 0.3 0.1 0.5 0.2l7.1 3.9c0.5 0.2 0.8 0.9 0.5 1.4-0.3 0.5-1 0.7-1.5 0.3l-6.6-3.5-6.4 3.7c-0.5 0.3-1.2 0.2-1.5-0.3-0.3-0.5 0-1.2 0.5-1.4l6.9-4.1c0.2-0.1 0.4-0.2 0.5-0.2zm-0.1 6c0.2 0 0.3 0 0.5 0.1l7.1 3.9c0.5 0.2 0.7 0.9 0.5 1.4-0.3 0.5-1 0.6-1.5 0.3l-6.7-3.6-6.4 3.7c-0.5 0.3-1.2 0.2-1.5-0.3-0.3-0.5 0-1.2 0.5-1.4l6.9-4c0.1-0.1 0.3-0.1 0.5-0.1zm0 6c0.2 0 0.3 0 0.5 0.1l7.1 3.9c0.5 0.2 0.7 1 0.5 1.5-0.3 0.4-1 0.6-1.5 0.3l-6.7-3.6-6.4 3.7c-0.5 0.3-1.2 0.1-1.5-0.3-0.3-0.5 0-1.3 0.5-1.5l6.9-4c0.1-0.1 0.3-0.1 0.5-0.1z"/></svg>'
      ++i
    i = 0
    while i < mHatch.length
      mHatch[i].innerHTML = '<svg class="icon iMid"><path d="m16 4.4c-4.8 0-9.7 0.4-10.4 1-1.5 1.5-1.5 19.4 0 20.9 1.5 1.4 19.3 1.4 20.8 0 1.5-1.5 1.5-19.4 0-20.9-0.7-0.7-5.6-1-10.4-1zm-3 1.5a1 1 0 0 1 0.2 0 1 1 0 0 1 0.1 0 1 1 0 0 1 0.6 0.3l2.3 2.3 2.3-2.3a1 1 0 0 1 0.6-0.3 1 1 0 0 1 0.1 0 1 1 0 0 1 0.7 1.8l-2.3 2.3 1.6 1.6 4.3-4.3a1 1 0 0 1 0.6-0.3 1 1 0 0 1 0.1 0 1 1 0 0 1 0.8 1.8l-4.4 4.4 1.6 1.6 1.3-1.3a1 1 0 0 1 0.6-0.3 1 1 0 0 1 0.1 0 1 1 0 0 1 0.8 1.8l-1.4 1.4 1.5 1.5a1 1 0 1 1-1.5 1.4l-1.5-1.5-1.6 1.6 4.5 4.4a1 1 0 1 1-1.4 1.4l-4.5-4.4-1.6 1.6 2 2.1a1 1 0 1 1-1.4 1.3l-2-2-2 2a1 1 0 1 1-1.4-1.3l2.1-2.1-1.6-1.6-4.5 4.4a1 1 0 1 1-1.4-1.4l4.5-4.5-1.6-1.6-1.5 1.5a1 1 0 1 1-1.4-1.4l1.5-1.5-1.4-1.4a1 1 0 0 1 0.5-1.8 1 1 0 0 1 0.3 0 1 1 0 0 1 0.6 0.3l1.3 1.3 1.6-1.6-4.3-4.3a1 1 0 0 1 0.4-1.8 1 1 0 0 1 0.1 0 1 1 0 0 1 0.3 0 1 1 0 0 1 0.6 0.3l4.3 4.3 1.6-1.6-2.3-2.3a1 1 0 0 1 0.5-1.8zm3.2 5.4-1.6 1.6 1.6 1.6 1.6-1.6-1.6-1.6zm-3 3-1.6 1.6 1.6 1.6 1.6-1.6-1.6-1.6zm6 0-1.6 1.6 1.6 1.6 1.6-1.6-1.6-1.6zm-3 3-1.6 1.6 1.6 1.6 1.6-1.6-1.6-1.6z"/></svg>'
      ++i
    i = 0
    while i < mH_stripes.length
      mH_stripes[i].innerHTML = '<svg class="icon iMid"><path d="m16 4.4c-4.8 0-9.7 0.4-10.4 1-1.5 1.5-1.5 19.4 0 20.9 1.5 1.4 19.3 1.4 20.8 0 1.5-1.5 1.5-19.4 0-20.9-0.7-0.7-5.6-1-10.4-1zm-8.1 4.3h0.1 16.2c0.5 0 1 0.5 1 1 0 0.5-0.5 1-1 1h-16.2c-0.5 0-1-0.4-1-0.9 0-0.5 0.4-1 0.9-1.1h0.1zm0 6h0.1 16.2c0.5 0 1 0.5 1 1s-0.5 1-1 1h-16.2c-0.5 0-1-0.4-1-0.9 0-0.5 0.4-1 0.9-1.1h0.1zm0 6h0.1 16.2c0.5 0 1 0.5 1 1s-0.5 1-1 1h-16.2c-0.5 0-1-0.4-1-0.9 0-0.5 0.4-1 0.9-1.1h0.1z"/></svg>'
      ++i
    i = 0
    while i < mD_stripes.length
      mD_stripes[i].innerHTML = '<svg class="icon iMid"><path d="m24.2 13.3c0.9-0.2 1.6 1.1 0.9 1.7-3.7 3.7-7.4 7.4-11.1 11.1-0.7 0.5-1.9-0.3-1.5-1.2 0.4-0.6 1-1.1 1.5-1.6 3.3-3.3 6.5-6.6 9.8-9.8 0.1-0.1 0.3-0.2 0.5-0.2zm0-6c1-0.2 1.6 1.1 0.9 1.7l-16.2 16.2c-0.7 0.7-1.9-0.1-1.6-1 0.2-0.6 0.9-1 1.3-1.5 5-5 10.2-10.2 15.2-15.3 0.1-0.1 0.3-0.2 0.5-0.2zm-5-1c1-0.1 1.4 1.2 0.7 1.8-3.7 3.7-7.4 7.5-11.2 11.2-0.7 0.6-1.9-0.3-1.5-1.2 0.3-0.6 1-1 1.4-1.6 3.3-3.3 6.6-6.7 10-10 0.2-0.2 0.4-0.2 0.6-0.2zm-3.2-1.9c-3.2 0.1-6.5 0-9.6 0.7-1.3 0.2-1.3 1.7-1.5 2.7-0.6 4.7-0.5 9.5-0.2 14.3 0.2 1.4 0.2 2.8 0.8 4 0.8 0.8 2 0.7 3.1 0.9 4.8 0.5 9.7 0.5 14.5 0 1.1-0.2 2.3-0.2 3.3-0.8 0.7-1.1 0.7-2.5 0.8-3.9 0.4-4.8 0.4-9.6-0.2-14.4-0.2-1-0.1-2.4-1.2-3-2.5-0.7-5.1-0.7-7.7-0.8h-2.3z"/></svg>'
      ++i
      
  - if element.hasClass('lGlitter')
    pHexagon = element.find('.pHexagon')
    pSquare = element.find('.pSquare')
    pCircle = element.find('.pCircle')
    pStar = element.find('.pStar')
    pHeart = element.find('.pHeart')
    pHalfmoon = element.find('.pHalfmoon')
    pSnow = element.find('.pSnow')
    pRhombus = element.find('.pRhombus')
    pStick = element.find('.pStick')
    
    i = 0
    while i < pHexagon.length
      pHexagon[i].innerHTML = '<svg class="icon iMid"><path d="m16 3c1.3 0 10.8 5.4 11.5 6.5 0.7 1.15 0.7 12.8 0 14-0.7 1.16-10.2 6.5-11.5 6.5-1.3 0-10.8-5.34-11.5-6.5-0.7-1.15-0.7-12.8 0-14 0.7-1.15 10.2-6.5 11.5-6.5z"/></svg>'
      ++i
    i = 0
    while i < pSquare.length
      pSquare[i].innerHTML = '<svg class="icon iMid"><path d="m5.5 6c1.5-1.5 19.5-1.5 21 0 1.5 1.5 1.5 19.5 0 21-1.5 1.5-19.5 1.5-21 0-1.5-1.5-1.5-19.5 0-21z"/></svg>'
      ++i
    i = 0
    while i < pCircle.length
      pCircle[i].innerHTML = '<svg class="icon iMid"><circle cy="16" cx="16" r="12.5"/></svg>'
      ++i
    i = 0
    while i < pStar.length
      pStar[i].innerHTML = '<svg class="icon iMid"><path d="m16.1 25.5c-1 0-8.1 4.8-8.9 4.3s1.6-8.9 1.3-9.8c-0.3-0.9-7.1-6.3-6.8-7.2 0.3-0.9 8.9-1.2 9.7-1.8s3.8-8.7 4.7-8.7 3.9 8.1 4.7 8.7 9.4 0.9 9.7 1.8c0.3 1-6.5 6.3-6.8 7.2-0.3 0.9 2 9.2 1.3 9.8s-8-4.3-8.9-4.3z"/></svg>'
      ++i
    i = 0
    while i < pHeart.length
      pHeart[i].innerHTML = '<svg class="icon iMid"><path d="m29.5 12.3c0 1.8-0.5 3.6-1.4 5.3-3.7 5.5-10.3 11.7-12.1 12.2-1.8-0.5-8.9-6.8-12.1-12.2-1-1.7-1.5-3.5-1.4-5.3 0.1-3.9 3-6.8 6.6-6.9 2.5 0 4.8 1.4 7 4.2 2.2-2.8 4.5-4.2 7-4.2 4 0.1 6.5 3.5 6.5 6.9z"/></svg>'
      ++i
    i = 0
    while i < pHalfmoon.length
      pHalfmoon[i].innerHTML = '<svg class="icon iMid"><path d="m12 4.5c-4.5 1.8-7.7 6.2-7.7 11.4 0 6.8 5.5 12.4 12.3 12.4 5.2 0 9.6-3.3 11.4-7.8-1.4 0.6-3 0.9-4.6 0.9-6.8 0-12.4-5.5-12.4-12.3 0-1.6 0.3-3.2 0.9-4.6z"/></svg>'
      ++i
    i = 0
    while i < pSnow.length
      pSnow[i].innerHTML = '<svg class="icon iMid"><path id="b" d="M19.5,10.5C16,8 21,8 21,6 21,4 18,6 17.5,4 17.5,3 18.5,3 18.5,2c0-2.5-5-2.5-5,0 0,1 1,1 1,2C14,6 11,3.7 11,6 11,7.5 16,8 12.5,10.5 9,13 9,20 16,20c7,0 7-7 3.5-9.5z"/><use xlink:href="#b" transform="rotate(60 16 16)"/><use xlink:href="#b" transform="rotate(120 16 16)"/><use xlink:href="#b" transform="rotate(180 16 16)"/><use xlink:href="#b" transform="rotate(240 16 16)"/><use xlink:href="#b" transform="rotate(300 16 16)"/></svg>'
      ++i
    i = 0
    while i < pRhombus.length
      pRhombus[i].innerHTML = '<svg class="icon iMid"><path d="m16 0.4c-0.3 0-0.5 0.1-0.7 0.4l-9.3 14.6c-0.3 0.4-0.3 1.1 0 1.4l9.3 14.7c0.4 0.5 1 0.5 1.3 0l9.2-14.7c0.3-0.3 0.3-1 0-1.4l-9.2-14.6c-0.2-0.3-0.4-0.4-0.7-0.4z"/></svg>'
      ++i
    i = 0
    while i < pStick.length
      pStick[i].innerHTML = '<svg class="icon iMid"><path d="m17.8 1.1c0.2 2.1 0.4 27.9 0 30-0.3 1.3-3.3 1.4-3.6 0-0.4-2.1-0.4-27.9 0-30 0.3-1.7 3.4-1.4 3.6 0z"/></svg>'
      ++i
  