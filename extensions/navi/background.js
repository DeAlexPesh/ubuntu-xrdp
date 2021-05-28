// logout
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.greeting == "close") {
   chrome.tabs.query({}, (tabs) => {
    for (var i = 0; i < tabs.length; i++) { chrome.tabs.remove(tabs[i].id); }
   });
  }
});

// deny new tabs
chrome.tabs.onCreated.addListener((tab) => {
 chrome.tabs.query({ currentWindow: true }, (tabs) => {
  if (tabs.length > 1) {
   chrome.storage.local.get({ blockWindows: false, blockTabs: false }, (items) => {
    chrome.windows.getCurrent({}, (window) => {
     if (window.state == "fullscreen") {
      if (items.blockTabs) { chrome.tabs.remove(tab.id); }
     }
    });
   });
  }
 });
});

// deny new windows
chrome.windows.onCreated.addListener((window) => {
 chrome.windows.getAll({populate: true}, (windows) => {
  if (windows.length > 1) {
   chrome.storage.local.get({ blockWindows: false, blockTabs: false }, (items) => {
    if (items.blockWindows) {
     for (var i = 0; i < windows.length; i++) {
      if (windows[i].state == "fullscreen") { chrome.windows.remove(window.id); break; }
     }
    }
   });
  }
 });
});

// custom error page
chrome.webNavigation.onErrorOccurred.addListener((data) => {
 var errs = "net::ERR_BLOCKED_BY_ADMINISTRATOR;net::ERR_NAME_NOT_RESOLVED;net::ERR_CONNECTION_FAILED;net::ERR_CONNECTION_RESET;net::ERR_EMPTY_RESPONSE;net::ERR_FAILED;net::ERR_CONNECTION_REFUSED;net::ERR_INTERNET_DISCONNECTED";
 if (errs.indexOf(data.error) != -1) {
	var Page = GetPageName(data.error)
  chrome.tabs.update(data.tabId, { url: Page });
 }
});

function GetPageName(error) {
 var ErrText = new String(error);
 if (ErrText.indexOf("net::ERR_BLOCKED_BY_ADMINISTRATOR") >= 0)
  return "Error-Blocked-by-Administrator.html";
 if (ErrText.indexOf("net::ERR_NAME_NOT_RESOLVED") >= 0)
  return "Error-Name-not-Resolved.html";
 if (ErrText.indexOf("net::ERR_CONNECTION_FAILED") >= 0)
  return "Error-Connectoin-Failed.html";
 if (ErrText.indexOf("net::ERR_CONNECTION_RESET") >= 0)
  return "Error-Connection-Reset.html";
 if (ErrText.indexOf("net::ERR_EMPTY_RESPONSE") >= 0)
  return "Error-Empty-Response.html";
 if (ErrText.indexOf("net::ERR_FAILED") >= 0)
  return "Error.html";
 if (ErrText.indexOf("net::ERR_CONNECTION_REFUSED") >= 0)
  return "Error-Connection-Refused.html";
 if (ErrText.indexOf("net::ERR_INTERNET_DISCONNECTED") >= 0)
  return "Error-Internet-Disconnected.html";
 return "Error.html";
}
