/*! tinyColorPicker - v1.0.0 2015-04-18 */
!function(a,b){"use strict";function c(a,c,d,f,g){if("string"==typeof c){var c=t.txt2color(c);d=c.type,n[d]=c[d],g=g!==b?g:c.alpha}else if(c)for(var h in c)a[d][h]=k(c[h]/l[d][h][1],0,1);return g!==b&&(a.alpha=+g),e(d,f?a:b)}function d(a,b,c){var d=m.options.grey,e={};return e.RGB={r:a.r,g:a.g,b:a.b},e.rgb={r:b.r,g:b.g,b:b.b},e.alpha=c,e.equivalentGrey=Math.round(d.r*a.r+d.g*a.g+d.b*a.b),e.rgbaMixBlack=i(b,{r:0,g:0,b:0},c,1),e.rgbaMixWhite=i(b,{r:1,g:1,b:1},c,1),e.rgbaMixBlack.luminance=h(e.rgbaMixBlack,!0),e.rgbaMixWhite.luminance=h(e.rgbaMixWhite,!0),m.options.customBG&&(e.rgbaMixCustom=i(b,m.options.customBG,c,1),e.rgbaMixCustom.luminance=h(e.rgbaMixCustom,!0),m.options.customBG.luminance=h(m.options.customBG,!0)),e}function e(a,b){var c,e,k,o=b||n,p=t,q=m.options,r=l,s=o.RND,u="",v="",w={hsl:"hsv",rgb:a},x=s.rgb;if("alpha"!==a){for(var y in r)if(!r[y][y]){a!==y&&(v=w[y]||"rgb",o[y]=p[v+"2"+y](o[v])),s[y]||(s[y]={}),c=o[y];for(u in c)s[y][u]=Math.round(c[u]*r[y][u][1])}x=s.rgb,o.HEX=p.RGB2HEX(x),o.equivalentGrey=q.grey.r*o.rgb.r+q.grey.g*o.rgb.g+q.grey.b*o.rgb.b,o.webSave=e=f(x,51),o.webSmart=k=f(x,17),o.saveColor=x.r===e.r&&x.g===e.g&&x.b===e.b?"web save":x.r===k.r&&x.g===k.g&&x.b===k.b?"web smart":"",o.hueRGB=t.hue2RGB(o.hsv.h),b&&(o.background=d(x,o.rgb,o.alpha))}var z,A,B,C=o.rgb,D=o.alpha,E="luminance",F=o.background;return z=i(C,{r:0,g:0,b:0},D,1),z[E]=h(z,!0),o.rgbaMixBlack=z,A=i(C,{r:1,g:1,b:1},D,1),A[E]=h(A,!0),o.rgbaMixWhite=A,q.customBG&&(B=i(C,F.rgbaMixCustom,D,1),B[E]=h(B,!0),B.WCAG2Ratio=j(B[E],F.rgbaMixCustom[E]),o.rgbaMixBGMixCustom=B,B.luminanceDelta=Math.abs(B[E]-F.rgbaMixCustom[E]),B.hueDelta=g(F.rgbaMixCustom,B,!0)),o.RGBLuminance=h(x),o.HUELuminance=h(o.hueRGB),q.convertCallback&&q.convertCallback(o,a),o}function f(a,b){var c={},d=0,e=b/2;for(var f in a)d=a[f]%b,c[f]=a[f]+(d>e?b-d:-d);return c}function g(a,b,c){return(Math.max(a.r-b.r,b.r-a.r)+Math.max(a.g-b.g,b.g-a.g)+Math.max(a.b-b.b,b.b-a.b))*(c?255:1)/765}function h(a,b){for(var c=b?1:255,d=[a.r/c,a.g/c,a.b/c],e=m.options.luminance,f=d.length;f--;)d[f]=d[f]<=.03928?d[f]/12.92:Math.pow((d[f]+.055)/1.055,2.4);return e.r*d[0]+e.g*d[1]+e.b*d[2]}function i(a,c,d,e){var f={},g=d!==b?d:1,h=e!==b?e:1,i=g+h*(1-g);for(var j in a)f[j]=(a[j]*g+c[j]*h*(1-g))/i;return f.a=i,f}function j(a,b){var c=1;return c=a>=b?(a+.05)/(b+.05):(b+.05)/(a+.05),Math.round(100*c)/100}function k(a,b,c){return a>c?c:b>a?b:a}var l={rgb:{r:[0,255],g:[0,255],b:[0,255]},hsv:{h:[0,360],s:[0,100],v:[0,100]},hsl:{h:[0,360],s:[0,100],l:[0,100]},alpha:{alpha:[0,1]},HEX:{HEX:[0,16777215]}},m={},n={},o={r:.298954,g:.586434,b:.114612},p={r:.2126,g:.7152,b:.0722},q=a.Colors=function(a){this.colors={RND:{}},this.options={color:"rgba(204, 82, 37, 0.8)",grey:o,luminance:p,valueRanges:l},r(this,a||{})},r=function(a,d){var e,f=a.options;s(a);for(var g in d)d[g]!==b&&(f[g]=d[g]);e=f.customBG,f.customBG="string"==typeof e?t.txt2color(e).rgb:e,n=c(a.colors,f.color,b,!0)},s=function(a){m!==a&&(m=a,n=a.colors)};q.prototype.setColor=function(a,d,f){return s(this),a?c(this.colors,a,d,b,f):(f!==b&&(this.colors.alpha=f),e(d))},q.prototype.setCustomBackground=function(a){return s(this),this.options.customBG="string"==typeof a?t.txt2color(a).rgb:a,c(this.colors,b,"rgb")},q.prototype.saveAsBackground=function(){return s(this),c(this.colors,b,"rgb",!0)};var t={txt2color:function(a){var b={},c=a.replace(/(?:#|\)|%)/g,"").split("("),d=(c[1]||"").split(/,\s*/),e=c[1]?c[0].substr(0,3):"rgb",f="";if(b.type=e,b[e]={},c[1])for(var g=3;g--;)f=e[g]||e.charAt(g),b[e][f]=+d[g]/l[e][f][1];else b.rgb=t.HEX2rgb(c[0]);return b.alpha=d[3]?+d[3]:1,b},RGB2HEX:function(a){return((a.r<16?"0":"")+a.r.toString(16)+(a.g<16?"0":"")+a.g.toString(16)+(a.b<16?"0":"")+a.b.toString(16)).toUpperCase()},HEX2rgb:function(a){return a=a.split(""),{r:parseInt(a[0]+a[a[3]?1:0],16)/255,g:parseInt(a[a[3]?2:1]+(a[3]||a[1]),16)/255,b:parseInt((a[4]||a[2])+(a[5]||a[2]),16)/255}},hue2RGB:function(a){var b=6*a,c=~~b%6,d=6===b?0:b-c;return{r:Math.round(255*[1,1-d,0,0,d,1][c]),g:Math.round(255*[d,1,1,1-d,0,0][c]),b:Math.round(255*[0,0,d,1,1,1-d][c])}},rgb2hsv:function(a){var b,c,d,e=a.r,f=a.g,g=a.b,h=0;return g>f&&(f=g+(g=f,0),h=-1),c=g,f>e&&(e=f+(f=e,0),h=-2/6-h,c=Math.min(f,g)),b=e-c,d=e?b/e:0,{h:1e-15>d?n&&n.hsl&&n.hsl.h||0:b?Math.abs(h+(f-g)/(6*b)):0,s:e?b/e:n&&n.hsv&&n.hsv.s||0,v:e}},hsv2rgb:function(a){var b=6*a.h,c=a.s,d=a.v,e=~~b,f=b-e,g=d*(1-c),h=d*(1-f*c),i=d*(1-(1-f)*c),j=e%6;return{r:[d,h,g,g,i,d][j],g:[i,d,d,h,g,g][j],b:[g,g,i,d,d,h][j]}},hsv2hsl:function(a){var b=(2-a.s)*a.v,c=a.s*a.v;return c=a.s?1>b?b?c/b:0:c/(2-b):0,{h:a.h,s:a.v||c?c:n&&n.hsl&&n.hsl.s||0,l:b/2}},rgb2hsl:function(a,b){var c=t.rgb2hsv(a);return t.hsv2hsl(b?c:n.hsv=c)},hsl2rgb:function(a){var b=6*a.h,c=a.s,d=a.l,e=.5>d?d*(1+c):d+c-c*d,f=d+d-e,g=e?(e-f)/e:0,h=~~b,i=b-h,j=e*g*i,k=f+j,l=e-j,m=h%6;return{r:[e,l,f,f,k,e][m],g:[k,e,e,l,f,f][m],b:[f,f,k,e,e,l][m]}}}}(window);
(function (root, factory) {
  if (typeof exports === 'object') {
    module.exports = factory(root, require('jquery'), require('colors'));
  } else if (typeof define === 'function' && define.amd) {
    define(['jquery', 'colors'], function (jQuery, Colors) {
      return factory(root, jQuery, Colors);
    });
  } else {
    factory(root, root.jQuery, root.Colors);
  }
}(this, function(window, $, Colors, undefined){
  'use strict';

  var $document = $(document),
    _instance = $(),
    _colorPicker,
    _color,
    _options,

    _$trigger,
    _$cPreview,
    _$UI, _$xy_slider, _$xy_cursor, _$z_cursor , _$alpha , _$alpha_cursor,

    _pointermove = 'touchmove.a mousemove.a pointermove.a',
    _pointerdown = 'touchstart.a mousedown.a pointerdown.a',
    _pointerup = 'touchend.a mouseup.a pointerup.a',
    _GPU = false,
    _round = Math.round,
    _animate = window.requestAnimationFrame ||
      window.webkitRequestAnimationFrame || function(cb){cb()},
    _html = '<div class="cp-color-picker colourPicker"><div class="cp-z-slider"><div c' +
      'lass="cp-z-cursor"></div></div><div class="cp-xy-slider"><div cl' +
      'ass="cp-white"></div><div class="cp-xy-cursor"></div></div><div ' +
      'class="cp-alpha"><div class="cp-alpha-cursor"></div></div></div>',
      // 'grunt-contrib-uglify' puts all this back to one single string...
    _css = '',

    ColorPicker = function(options) {
      _color = this.color = new Colors(options);
      _options = _color.options;
      _colorPicker = this;
    };

  ColorPicker.prototype = {
    render: preRender,
    toggle: toggle
  };

  function extractValue(elm) {
    return elm.value || elm.getAttribute('value') ||
      $(elm).css('background-color') || '#fff';
  }

  function resolveEventType(event) {
    event = event.originalEvent && event.originalEvent.touches ?
      event.originalEvent.touches[0] : event;

    return event.originalEvent ? event.originalEvent : event;
  }

  function findElement($elm) {
    return $($elm.find(_options.doRender)[0] || $elm[0]);
  }

  function toggle(event) {
    var $this = $(this),
      position = $this.offset(),
      $window = $(window),
      gap = _options.gap;

    if (event) {
      _$trigger = findElement($this);
      _$cPreview = $('#cPreview');
      _$trigger._colorMode = _$trigger.data('colorMode');

      _colorPicker.$trigger = $this;

      (_$UI || build()).css({
        // 'width': _$UI[0]._width,
        'left': (_$UI[0]._left = position.left) -
          ((_$UI[0]._left = _$UI[0]._left + _$UI[0]._width -
          ($window.scrollLeft() + $window.width())) + gap > 0 ?
          _$UI[0]._left + gap : 0),
        'top': (_$UI[0]._top = position.top + $this.outerHeight()) -
          ((_$UI[0]._top = _$UI[0]._top + _$UI[0]._height -
          ($window.scrollTop() + $window.height())) + gap > 0 ?
          _$UI[0]._top + gap : 0)
      }).show(_options.animationSpeed, function() {
        if (event === true) {
          return;
        }
        _$alpha._width = _$alpha.width();
        _$xy_slider._width = _$xy_slider.width();
        _$xy_slider._height = _$xy_slider.height();
        _color.setColor(extractValue(_$trigger[0]));

        preRender(true);
      });
    } else {
      $(_$UI).hide(_options.animationSpeed, function() {
        preRender(false);
        _colorPicker.$trigger = null;
      });
    }
  }

  function build() {
    $('head').append('<style type="text/css">' +
      (_options.css || _css) + (_options.cssAddon || '') + '</style>');

    return _colorPicker.$UI = _$UI =
      $(_html).css({'margin': _options.margin})
      .appendTo('body')
      .show(0, function() {
        var $this = $(this);

        _GPU = _options.GPU && $this.css('perspective') !== undefined;
        _$xy_slider = $('.cp-xy-slider', this);
        _$xy_cursor = $('.cp-xy-cursor', this);
        _$z_cursor = $('.cp-z-cursor', this);
        _$alpha = $('.cp-alpha', this).toggle(!!_options.opacity);
        _$alpha_cursor = $('.cp-alpha-cursor', this);
        _options.buildCallback.call(_colorPicker, $this);
        $this.prepend('<div>').children().eq(0).css('width',
          $this.children().eq(0).width() // stabilizer
        );
        this._width = this.offsetWidth;
        this._height = this.offsetHeight;
      }).hide()
      .on(_pointerdown,
        '.cp-xy-slider,.cp-z-slider,.cp-alpha', pointerdown);
  }

  function pointerdown(e) {
    var action = this.className
        .replace(/cp-(.*?)(?:\s*|$)/, '$1').replace('-', '_');

    if ((e.button || e.which) > 1) return;

    e.preventDefault && e.preventDefault();
    e.returnValue = false;

    _$trigger._offset = $(this).offset();

    (action = action === 'xy_slider' ? xy_slider :
      action === 'z_slider' ? z_slider : alpha)(e);
    preRender();

    $document.on(_pointerup, function(e) {
      $document.off('.a');
    }).on(_pointermove, function(e) {
      action(e);
      preRender();
    });
  }

  function xy_slider(event) {
    var e = resolveEventType(event),
      x = e.pageX - _$trigger._offset.left,
      y = e.pageY - _$trigger._offset.top;

    _color.setColor({
      s: x / _$xy_slider._width * 100,
      v: 100 - (y / _$xy_slider._height * 100)
    }, 'hsv');
  }

  function z_slider(event) {
    var z = resolveEventType(event).pageY - _$trigger._offset.top;

    _color.setColor({h: 360 - (z / _$xy_slider._height * 360)}, 'hsv');
  }

  function alpha(event) {
    var x = resolveEventType(event).pageX - _$trigger._offset.left,
      alpha = x / _$alpha._width;

    _color.setColor({}, 'rgb', alpha);
  }

  function preRender(toggled) {
    var colors = _color.colors,
      hueRGB = colors.hueRGB,
      RGB = colors.RND.rgb,
      HSL = colors.RND.hsl,
      dark = '#222',
      light = '#ddd',
      colorMode = _$trigger._colorMode,
      isAlpha = colors.alpha !== 1,
      alpha = _round(colors.alpha * 100) / 100,
      RGBInnerText = RGB.r + ', ' + RGB.g + ', ' + RGB.b,
      text = (colorMode === 'HEX' && !isAlpha ? '#' + colors.HEX :
        (!isAlpha ? 'rgb(' + RGBInnerText + ')' :
          'rgba(' + RGBInnerText + ', ' + alpha + ')')),
      HUEContrast = colors.HUELuminance > 0.22 ? dark : light,
      alphaContrast = colors.rgbaMixBlack.luminance > 0.22 ? dark : light,
      h = (1 - colors.hsv.h) * _$xy_slider._height,
      s = colors.hsv.s * _$xy_slider._width,
      v = (1 - colors.hsv.v) * _$xy_slider._height,
      a = alpha * _$alpha._width,
      translate3d = _GPU ? 'translate3d' : '',
      triggerValue = _$trigger[0].value,
      hasNoValue = _$trigger[0].hasAttribute('value') && // question this
        triggerValue === '' && toggled !== undefined;

    _$xy_slider._css = {
      backgroundColor: 'rgb(' +
        hueRGB.r + ',' + hueRGB.g + ',' + hueRGB.b + ')'};
    _$xy_cursor._css = {
      transform: translate3d + '(' + s + 'px, ' + v + 'px, 0)',
      left: !_GPU ? s : '',
      top: !_GPU ? v : '',
      borderColor : colors.RGBLuminance > 0.22 ? dark : light
    };
    _$z_cursor._css = {
      transform: translate3d + '(0, ' + h + 'px, 0)',
      top: !_GPU ? h : '',
      borderColor : 'transparent ' + HUEContrast
    };
    _$alpha._css = {backgroundColor: 'rgb(' + RGBInnerText + ')'};
    _$alpha_cursor._css = {
      transform: translate3d + '(' + a + 'px, 0, 0)',
      left: !_GPU ? a : '',
      borderColor : alphaContrast + ' transparent'
    };
    _$trigger._css = {
      backgroundColor : hasNoValue ? '' : text,
      color: hasNoValue ? '' :
        colors.rgbaMixBGMixCustom.luminance > 0.22 ? dark : light
    };
    _$cPreview.css('background-color', hasNoValue ? '' : text);
    _$trigger.text = hasNoValue ? '' : triggerValue !== text ? text : '';

    toggled !== undefined ? render(toggled) : _animate(render);
  }

  // As _animate() is actually requestAnimationFrame(), render() gets called
  // decoupled from any pointer action (whenever the browser decides to do
  // so) as an event. preRender() is coupled to toggle() and all pointermove
  // actions; that's where all the calculations happen. render() can now be
  // called without extra calculations which results in faster rendering.
  function render(toggled) {
    _$xy_slider.css(_$xy_slider._css);
    _$xy_cursor.css(_$xy_cursor._css);
    _$z_cursor.css(_$z_cursor._css);
    _$alpha.css(_$alpha._css);
    _$alpha_cursor.css(_$alpha_cursor._css);

    _options.doRender && _$trigger.css(_$trigger._css);
    _$trigger.text && _$trigger.val(_$trigger.text);

    _options.renderCallback.call(
      _colorPicker,
      _$trigger,
      typeof toggled === 'boolean' ? toggled : undefined
    );
    $(_$trigger.data('field')).val(_$trigger.val());
  }

  $.fn.colorPicker = function(options) {
    var noop = function(){};

    options = $.extend({
      animationSpeed: 150,
      GPU: true,
      doRender: true,
      customBG: '#FFF',
      opacity: true,
      renderCallback: function($elm, toggled) {
        if (toggled) {
          this.$UI.find('.cp-alpha').toggle(!$elm.hasClass('noAlpha'));
          $elm.removeClass('disabled');
        } else if (toggled !== undefined) {
          if ($elm.val() == '') {
            if ($elm.hasClass('disableable')) {
              $elm.addClass('disabled');
            }
          }
        }
      },
      buildCallback: noop,
      body: document.body,
      scrollResize: true,
      gap: 4
      // css: '',
      // cssAddon: '',
      // margin: '',
      // preventFocus: false
    }, options);

    !_colorPicker && options.scrollResize && $(window)
    .on('resize.a scroll.a', function() {
      if (_colorPicker.$trigger) {
        _colorPicker.toggle.call(_colorPicker.$trigger[0], true);
      }
    });
    _instance = _instance.add(this);
    this.colorPicker = _instance.colorPicker =
      _colorPicker || new ColorPicker(options);

    $(options.body).off('.a').on(_pointerdown, function(e) {
      !_instance.add(_$UI).find(e.target)
        .add(_instance.filter(e.target))[0] && toggle();
    });

    return this.on('focusin.a click.a', toggle)
    .on('change.a', function() {
      _color.setColor(this.value || '#FFF');
      _instance.colorPicker.render(true);
    })
    .each(function() {
      var value = extractValue(this),
        mode = value.split('('),
        $elm = findElement($(this));

      $elm.data('colorMode', mode[1] ? mode[0].substr(0, 3) : 'HEX')
        .attr('readonly', _options.preventFocus);
      options.doRender &&
      $elm.css({'background-color': value,
        'color': function() {
          return _color.setColor(value)
            .rgbaMixBGMixCustom.luminance > 0.22 ? '#222' : '#ddd'
        }
      });
    });
  };

  $.fn.colorPicker.destroy = function() {
    _instance.add(_options.body).off('.a'); // saver
    _colorPicker.toggle(false);
    _instance = $();
  };

}));
