// Widget

var Widget = function Widget(options) {
  var self = this,
    active,
    select = options.select,
    element = options.element,
    storage = options.storage,
    autoMode = options.autoMode;

  this._element = element;

  this.onStateChange = function (name, enable) {
    if (name === 'active') {
      storage.setValue('active', enable);
    }
  };

  select.onSelect = function (lang) {
    this.setHidden(true);
    self.translate(lang);
  };

  select.onChange = function (lang) {
    storage.setValue('lang', lang);
    rightButton.setText(lang);
    self.setState('invalid', lang === pageLang);
  };

  select.onHiddenChange = function (hidden) {
    var docElem = doc.documentElement, formRect;
    self.setState('expanded', !hidden);
    if (!hidden) {
      self.setState('right', false)
        .setState('bottom', false);
      element.focus();
      formRect = this._form.getBoundingClientRect();

      if (formRect.right + (win.pageXOffset || docElem.scrollLeft) + 1 >= Math.max(docElem.clientWidth, docElem.scrollWidth)) {
        self.setState('right', true);
      }

      if (formRect.bottom + (win.pageYOffset || docElem.scrollTop) + 1 >= Math.max(docElem.clientHeight, docElem.scrollHeight)) {
        self.setState('bottom', true);
      }
    }
  };

  element.addEventListener('blur', function () {
    select.setHidden(true);
  }, false);

  element.addEventListener('keydown', function (event) {
    switch (event.keyCode) {
      case util.keycode.ESCAPE:
        select.setHidden(true);
        break;
    }
  }, false);

  translator.on('error', function () {
    this.abort();
    self.setState('busy', false)
      .setState('error', true);
  });

  translator.on('progress', function (progress) {
    switch (progress) {
      case 0:
        self.setState('busy', true)
          .setState('active', true);
        break;

      case 100:
        self.setState('done', true)
          .setState('busy', false);
        break;
    }
  });
};

//Widget.prototype.hasState = function (name) {
//  return util.hasStyleName(this._element, 'yt-state_' + name);
//};
//
//Widget.prototype.setState = function (name, enable) {
//  var hasState = this.hasState(name);
//  enable = !!enable;
//  if (enable === hasState) {
//    return this;
//  }
//  util[(enable ? 'add' : 'remove') + 'StyleName'](
//    this._element, 'yt-state_' + name
//  );
//  this.onStateChange(name, enable);
//  return this;
//};
//
//Widget.prototype.onStateChange = function () {};
