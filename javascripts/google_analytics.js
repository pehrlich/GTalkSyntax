// note: there's no .coffee for this file
// docs: http://developer.chrome.com/extensions/tut_analytics.html

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-38053147-1']);

// When placed on a background page, this will register a view once per browser session:
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = 'https://ssl.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
