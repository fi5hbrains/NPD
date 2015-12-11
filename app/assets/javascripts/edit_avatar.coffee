showCoords = (c) ->
  $('#cropCoords').val(Math.round(c.w) + 'x' + Math.round(c.h) + '+' + Math.round(c.x) + '+' + Math.round(c.y))
  updatePreview(c)
  
updatePreview = (c) ->
  f = c.w / 48
  $('#currentUser').css
    width: Math.round(parseInt($('#jcrop').width()) / f)
    height: Math.round(parseInt($('#jcrop').height()) / f)
    marginLeft: '-' + Math.round(c.x / f) + 'px'
    marginTop: '-' + Math.round(c.y / f) + 'px'
    
$(document).on 'ready page:load', ->
  img = $('#jcrop')
  img.load ->  
    aspect = img.width()/img.height()
    halfDif = (img.width() - img.height()) / 2
    if aspect > 1 
      select = [halfDif,0,halfDif + img.height(),img.height()] 
    else
      select = [0,-halfDif,img.width(),img.width() - halfDif]
      
    img.Jcrop
      aspectRatio: 1
      minSize:     [48, 48]
      setSelect:   select
      boxWidth:    290
      boxHeight:   400
      onSelect:    showCoords
      onChange:    showCoords
      