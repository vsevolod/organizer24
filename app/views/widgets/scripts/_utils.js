var util = {
  getRequest: function () {
    if (win.XDomainRequest) {
      return new win.XDomainRequest();
    }
    if (win.XMLHttpRequest) {
      return new win.XMLHttpRequest();
    }
    return null;
  },
  loadScript: function (src, parent, callback) {
    var script = doc.createElement('script');
    script.src = src;

    script.addEventListener('load', function onLoad() {
      this.removeEventListener('load', onLoad, false);
      callback();
    }, false);

    parent.appendChild(script);
  },
  loadResource: function (url, callback) {
    var request = this.getRequest();

    if (!request) {
      return null;
    }

    request.onload = function () {
      callback(this.responseText);
    };
    request.open('GET', url, true);

    win.setTimeout(function () {
      request.send();
    }, 0);

    return request;
  },
  getStyleList: function (element) {
    var value = element.getAttribute('class');
    if (!value) {
      return [];
    }
    return value.replace(/\s+/g, ' ').trim().split(' ');
  },
  isSupportedBrowser: function () {
    return 'localStorage' in win &&
      'querySelector' in doc &&
      'addEventListener' in win &&
      'getComputedStyle' in win && doc.compatMode === 'CSS1Compat';
  },
}
