var wrapper = doc.getElementById(params.widgetId);

if (!wrapper || !util.isSupportedBrowser()) {
  return;
}

var initWidget = function () {
  util.loadScript(urls.script, wrapper, function () {
    util.loadResource(urls.resource,
      function (responseText) {
        var element;

        if (!responseText) {
          return;
        }

        wrapper.innerHTML = responseText;
      })
  })
}

if (doc.readyState === 'complete' || doc.readyState === 'interactive') {
  initWidget();
} else {
  doc.addEventListener('DOMContentLoaded', initWidget, false);
}
