'use strict';

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactDom = require('react-dom');

var _reactDom2 = _interopRequireDefault(_reactDom);

var _MovieAwks = require('./components/MovieAwks');

var _MovieAwks2 = _interopRequireDefault(_MovieAwks);

var _ResultTable = require('./components/ResultTable');

var _ResultTable2 = _interopRequireDefault(_ResultTable);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

_reactDom2.default.render(_react2.default.createElement(_MovieAwks2.default, null), document.getElementById('container'));