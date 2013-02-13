// Generated by CoffeeScript 1.3.3
(function() {
  var textarea;

  textarea = document.getElementById('textarea');

  chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
    console.log("from the extension", request);
    if (request.command === "copy") {
      if (request.content === '') {
        sendResponse({
          status: 'Empty string given.'
        });
        return;
      }
      textarea.value = request.content;
      textarea.select();
      return sendResponse({
        status: document.execCommand('Copy')
      });
    }
  });

}).call(this);