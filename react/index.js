import 'babel-polyfill';

import App from './js/components/App';
import AppHomeRoute from './js/routes/AppHomeRoute';

import React from 'react';
import ReactDOM from 'react-dom';
import Relay from 'react-relay';

ReactDOM.render(
  <Relay.Renderer
    environment={Relay.Store}
    Container={App}
    queryConfig={new AppHomeRoute()}
  />,
  document.getElementById('app')
);

//window.$ = require('jquery');
//require('./js/module1.js');
//alert('index2.js');
