chrome.runtime.onMessage.addListener(
 function(request, sender, sendResponse) {
  if (request.greeting == "close") {
   chrome.tabs.query({}, function (tabs) {
    for (var i = 0; i < tabs.length; i++) {
     chrome.tabs.remove(tabs[i].id);
    }
   });
  }
 }
);

chrome.webRequest.onHeadersReceived.addListener(info => {
 chrome.tabs.executeScript(info.tabId, {
  file: 'stop.js',
  runAt: 'document_start',
 });
}, {
 urls: ['*://foo/*'],
 types: ['main_frame'],
});
