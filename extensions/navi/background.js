chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.greeting == "close") {
   chrome.tabs.query({}, function (tabs) {
    for (var i = 0; i < tabs.length; i++) { chrome.tabs.remove(tabs[i].id); }
   });
  }
});
