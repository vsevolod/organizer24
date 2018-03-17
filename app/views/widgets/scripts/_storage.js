// Storage

var Storage = function Storage(name) {
  this._name = name;
  try {
    this._data = win.JSON.parse(win.localStorage[name]);
  } catch (error) {
    this._data = {};
  }
};

Storage.prototype.getValue = function (prop) {
  return this._data[prop];
};

Storage.prototype.setValue = function (prop, value) {
  this._data[prop] = value;
  try {
    win.localStorage[this._name] = win.JSON.stringify(this._data);
  } catch (error) {}
};

