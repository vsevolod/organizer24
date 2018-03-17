// Button

var Button = function Button(element, contentElement) {
  var self = this;

  element.addEventListener('click', function (event) {
    self.onClick(event);
  }, false);

  this._element = element;
  this._contentElement = contentElement || this._element;
};

Button.prototype.onClick = function () {};

Button.prototype.setText = function (text) {
  this._contentElement.textContent = text;
  return this;
};

// Select

var Select = function Select(form, itemName) {
  var self = this;

  form.reset();

  form.addEventListener('click', function (event) {
    var target = event.target;
    if ('value' in target) {
      self.onSelect(target.value);
    }
  }, false);

  form.addEventListener('change', function (event) {
    var target = event.target;
    if (target.checked) {
      self.onChange(target.value);
    }
  }, false);

  this._form = form;
  this._itemName = itemName;
};

Select.prototype.onSelect = function () {};

Select.prototype.onChange = function () {};

Select.prototype.isHidden = function () {
  return this._form.hasAttribute('hidden');
};

Select.prototype.getItems = function () {
  return this._form[this._itemName] || [];
};

Select.prototype.getValue = function () {
  var i, n, items = this.getItems();
  for (i = 0, n = items.length; i < n; i++) {
    if (items[i].checked) {
      return items[i].value;
    }
  }
  return '';
};

Select.prototype.setValue = function (value) {
  var i, n, items = this.getItems();
  if (value === this.getValue()) {
    return this;
  }
  for (i = 0, n = items.length; i < n; i++) {
    if (items[i].value === value) {
      items[i].checked = true;
      this.onChange(value);
      break;
    }
  }
  return this;
};

Select.prototype.setHidden = function (hidden) {
  hidden = !!hidden;
  if (hidden !== this.isHidden()) {
    this._form[(hidden ? 'set' : 'remove') + 'Attribute']('hidden', '');
    this.onHiddenChange(hidden);
  }
  return this;
};

Select.prototype.onHiddenChange = function () {};
