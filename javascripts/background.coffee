textarea = document.getElementById('textarea')
chrome.extension.onMessage.addListener (request, sender, sendResponse) ->
  console.log("from the extension", request);
  if (request.command == "copy")

    if request.content == ''
      sendResponse({status: 'Empty string given.'})
      return

    textarea.value = request.content
    textarea.select()
    sendResponse({status: document.execCommand('Copy')})
