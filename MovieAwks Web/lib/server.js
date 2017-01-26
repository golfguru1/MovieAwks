'use strict';

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _server = require('react-dom/server');

var _server2 = _interopRequireDefault(_server);

var _MovieAwks = require('./components/MovieAwks');

var _MovieAwks2 = _interopRequireDefault(_MovieAwks);

var _express = require('express');

var _express2 = _interopRequireDefault(_express);

var _ResultTable = require('./components/ResultTable');

var _ResultTable2 = _interopRequireDefault(_ResultTable);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var app = (0, _express2.default)();

// Set the view engine to ejs
app.set('view engine', 'ejs');

// Serve static files from the 'public' folder
app.use(_express2.default.static('public'));

// GET /
app.get('/', function (req, res) {
  res.render('layout', {
    container: _server2.default.renderToString(_react2.default.createElement(_MovieAwks2.default, null))
  });
});

// Start server
var server = app.listen(1337, function () {
  var host = server.address().address;
  var port = server.address().port;

  if (host === '::') {
    host = 'localhost';
  }

  console.log('Example app listening at http://%s:%s', host, port);
});