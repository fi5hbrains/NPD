
// jQuery - Smart Poll - Copyright TJ Holowaychuk <tj@vision-media.ca> (MIT Licensed)

;(function($) {
  $.poll = function(ms, callback) {
    if ($.isFunction(ms)) {
      callback = ms
      ms = 2000
    } 
    (function retry() {
      setTimeout(function() {
        callback(retry)
      }, ms)
      ms *= 1.5
    })()
  }
  
})(jQuery);