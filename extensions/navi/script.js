var localUrls = [KIOSKURLREBIND];
var localUrlsId = 0;

var height = 45;
var liHeight = height - 10;

var html = document.getElementsByTagName('html')[0];
var htmlStyles = window.getComputedStyle(html);
if (htmlStyles.getPropertyValue('position') === 'static') {
 html.style.position = 'relative';
}
var currentTop = htmlStyles.getPropertyValue('top');
currentTop = ( currentTop === '0px' ) ? 0 : parseFloat(currentTop);
html.style.top = currentTop + parseFloat(height) + 'px';

var elFixed = document.body.getElementsByTagName("*");
Array.apply(null, elFixed).map(function(el) {
 var elStyles = window.getComputedStyle(el);
 if (elStyles.getPropertyValue('position') == 'fixed') {
  currentTop = elStyles.getPropertyValue('top');
  currentTop = ( currentTop === '0px' ) ? 0 : parseFloat(currentTop);
  el.style.top = currentTop + parseFloat(height) + 'px';;
 }
});

var iframeId = chrome.runtime.id;

if (!document.getElementById(iframeId)) {
 var iframe = document.createElement('iframe');
 iframe.id = iframeId;
 iframe.setAttribute('scrolling', 'no');
 iframe.setAttribute('allowtransparency', 'false');
 iframe.setAttribute('frameBorder', '0');
 iframe.setAttribute('style', 'width:100%;height:' + height + 'px;position:fixed;top:0;left:0;right:0;border:0;z-index:2147483647;');
 html.appendChild(iframe);
 
 var iframeDoc = iframe.contentWindow.document;
 
 var navList = iframeDoc.createElement('ul');
 navList.className = "nav-list";
 var navBack = iframeDoc.createElement('li');
 navBack.className = false ? "nav-back btn dis" : "nav-back btn";
 navBack.onclick = function() { window.history.back(); };
 navList.appendChild(navBack);

 var navFwd = iframeDoc.createElement('li');
 navFwd.className = false ? "nav-fwd btn dis" : "nav-fwd btn";
 navFwd.onclick = function() { window.history.forward(); };
 navList.appendChild(navFwd);

 var navUpd = iframeDoc.createElement('li');
 navUpd.className = "nav-upd btn";
 navUpd.onclick = function() { window.location.reload(); };
 navList.appendChild(navUpd);

 var navUrl = iframeDoc.createElement('li');
 navUrl.className = "nav-url";
 navUrl.innerHTML = localUrls[localUrlsId];
 var navUrlIcon = iframeDoc.createElement('span');
 navUrlIcon.className = "nav-url-icon";
 navUrlIcon.onclick = function() { window.location.assign(localUrls[localUrlsId]); };
 navUrl.insertBefore(navUrlIcon, navUrl.firstChild);
 navList.appendChild(navUrl);

 var navExit = iframeDoc.createElement('li');
 navExit.className = "nav-exit btn";
 navExit.onclick = function() {
  chrome.history
 };
 navList.appendChild(navExit);

 var iframeStyle = iframeDoc.createElement('style');
 iframeStyle.setAttribute('type', 'text/css');
 iframeStyle.innerHTML = 'html,body{margin:0;padding:0;font-family:Arial,sans-serif;font-size:14px;letter-spacing:1px;}'
                       + 'ul{display:flex;flex-direction:row;box-sizing:border-box;height:' + height + 'px;margin:0;padding:0;padding-left:5px;padding-right:10px;background-color:#3b3b3b;color:#c1c1c1;}'
                       + 'li{display:inline-block;width:' + liHeight + 'px;height:' + liHeight + 'px;margin:5px;margin-right:0;}'
                       + 'li.dis{pointer-events:none;opacity:0.6;}'
                       + '.nav-back{background:url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0Ij48cGF0aCBkPSJNMCAwaDI0djI0SDB6IiBmaWxsPSJub25lIi8+PHBhdGggZD0iTTIwIDExSDcuODNsNS41OS01LjU5TDEyIDRsLTggOCA4IDggMS40MS0xLjQxTDcuODMgMTNIMjB2LTJ6IiBmaWxsPSIjYzFjMWMxIi8+PC9zdmc+) no-repeat center;}'
                       + '.nav-fwd{background:url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0Ij48cGF0aCBkPSJNMCAwaDI0djI0SDB6IiBmaWxsPSJub25lIi8+PHBhdGggZD0iTTEyIDRsLTEuNDEgMS40MUwxNi4xNyAxMUg0djJoMTIuMTdsLTUuNTggNS41OUwxMiAyMGw4LTh6IiBmaWxsPSIjYzFjMWMxIi8+PC9zdmc+) no-repeat center;}'
                       + '.nav-upd{background:url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0Ij48cGF0aCBkPSJNMCAwaDI0djI0SDB6IiBmaWxsPSJub25lIi8+PHBhdGggZD0iTTE3LjY1IDYuMzVDMTYuMiA0LjkgMTQuMjEgNCAxMiA0Yy00LjQyIDAtNy45OSAzLjU4LTcuOTkgOHMzLjU3IDggNy45OSA4YzMuNzMgMCA2Ljg0LTIuNTUgNy43My02aC0yLjA4Yy0uODIgMi4zMy0zLjA0IDQtNS42NSA0LTMuMzEgMC02LTIuNjktNi02czIuNjktNiA2LTZjMS42NiAwIDMuMTQuNjkgNC4yMiAxLjc4TDEzIDExaDdWNGwtMi4zNSAyLjM1eiIgZmlsbD0iI2MxYzFjMSIvPjwvc3ZnPg==) no-repeat center;}'
                       + '.nav-exit{background:url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0Ij48cGF0aCBkPSJNMCAwaDI0djI0SDB6IiBmaWxsPSJub25lIi8+PHBhdGggZD0iTTE5IDYuNDFMMTcuNTkgNSAxMiAxMC41OSA2LjQxIDUgNSA2LjQxIDEwLjU5IDEyIDUgMTcuNTkgNi40MSAxOSAxMiAxMy40MSAxNy41OSAxOSAxOSAxNy41OSAxMy40MSAxMnoiIGZpbGw9IiNjMWMxYzEiLz48L3N2Zz4=) no-repeat center;}'
                       + '.nav-url{padding-right:' + liHeight + 'px;line-height:' + liHeight + 'px;background-color:#2e2f2b;border-radius:' + height + 'px;user-select:none;flex:1;}'
                       + '.nav-url:hover{background-color:#363733;}'
                       + '.nav-url-icon{display:inline-block;content:"";width:25px;height:25px;padding:2px;padding-left:5px;padding-right:5px;margin:3px;vertical-align:top;background:url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0Ij48cGF0aCBkPSJNMCAwaDI0djI0SDB6IiBmaWxsPSJub25lIi8+PHBhdGggZD0iTTExLjk5IDJDNi40NyAyIDIgNi40OCAyIDEyczQuNDcgMTAgOS45OSAxMEMxNy41MiAyMiAyMiAxNy41MiAyMiAxMlMxNy41MiAyIDExLjk5IDJ6bTYuOTMgNmgtMi45NWMtLjMyLTEuMjUtLjc4LTIuNDUtMS4zOC0zLjU2IDEuODQuNjMgMy4zNyAxLjkxIDQuMzMgMy41NnpNMTIgNC4wNGMuODMgMS4yIDEuNDggMi41MyAxLjkxIDMuOTZoLTMuODJjLjQzLTEuNDMgMS4wOC0yLjc2IDEuOTEtMy45NnpNNC4yNiAxNEM0LjEgMTMuMzYgNCAxMi42OSA0IDEycy4xLTEuMzYuMjYtMmgzLjM4Yy0uMDguNjYtLjE0IDEuMzItLjE0IDIgMCAuNjguMDYgMS4zNC4xNCAySDQuMjZ6bS44MiAyaDIuOTVjLjMyIDEuMjUuNzggMi40NSAxLjM4IDMuNTYtMS44NC0uNjMtMy4zNy0xLjktNC4zMy0zLjU2em0yLjk1LThINS4wOGMuOTYtMS42NiAyLjQ5LTIuOTMgNC4zMy0zLjU2QzguODEgNS41NSA4LjM1IDYuNzUgOC4wMyA4ek0xMiAxOS45NmMtLjgzLTEuMi0xLjQ4LTIuNTMtMS45MS0zLjk2aDMuODJjLS40MyAxLjQzLTEuMDggMi43Ni0xLjkxIDMuOTZ6TTE0LjM0IDE0SDkuNjZjLS4wOS0uNjYtLjE2LTEuMzItLjE2LTIgMC0uNjguMDctMS4zNS4xNi0yaDQuNjhjLjA5LjY1LjE2IDEuMzIuMTYgMiAwIC42OC0uMDcgMS4zNC0uMTYgMnptLjI1IDUuNTZjLjYtMS4xMSAxLjA2LTIuMzEgMS4zOC0zLjU2aDIuOTVjLS45NiAxLjY1LTIuNDkgMi45My00LjMzIDMuNTZ6TTE2LjM2IDE0Yy4wOC0uNjYuMTQtMS4zMi4xNC0yIDAtLjY4LS4wNi0xLjM0LS4xNC0yaDMuMzhjLjE2LjY0LjI2IDEuMzEuMjYgMnMtLjEgMS4zNi0uMjYgMmgtMy4zOHoiIGZpbGw9IiNjMWMxYzEiLz48L3N2Zz4=) no-repeat center;}'
                       + 'li.btn:hover,.nav-url-icon:hover{background-color:#535353;border-radius:' + height + 'px;}'

 iframeDoc.head.appendChild(iframeStyle);
 iframeDoc.body.appendChild(navList);
}

var s = document.createElement('script');
s.src = chrome.runtime.getURL('navi.js');
s.onload = function() {
 this.remove();
};
(document.head || document.documentElement).appendChild(s);
