'use strict';

Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactBootstrap = require('react-bootstrap');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var SimpleCounter = function (_React$Component) {
    _inherits(SimpleCounter, _React$Component);

    function SimpleCounter() {
        _classCallCheck(this, SimpleCounter);

        return _possibleConstructorReturn(this, (SimpleCounter.__proto__ || Object.getPrototypeOf(SimpleCounter)).apply(this, arguments));
    }

    _createClass(SimpleCounter, [{
        key: 'makeAPICall',
        value: function makeAPICall() {
            $.ajax({
                url: 'https://api.themoviedb.org/3/search/movie',
                method: 'GET',
                data: {
                    "api_key": "05fb742d973ead23b8c11c9d46e53260",
                    "query": this.state.searchText
                },
                success: function (result) {
                    console.log(result);
                }.bind(this)
            });
        }
    }, {
        key: 'handleKeyPress',
        value: function handleKeyPress(event) {
            if (event.charCode === 13) {
                event.preventDefault();
                this.makeAPICall();
            }
        }
    }, {
        key: 'handleSearchChange',
        value: function handleSearchChange(event) {
            this.setState({ searchText: event.target.value });
            // this.makeAPICall()
        }
    }, {
        key: 'render',
        value: function render() {
            return _react2.default.createElement(
                _reactBootstrap.Grid,
                null,
                _react2.default.createElement(
                    _reactBootstrap.Row,
                    null,
                    _react2.default.createElement(
                        _reactBootstrap.Col,
                        { sm: 6, md: 6, lg: 6, smOffset: 3, mdOffset: 3, lgOffset: 3 },
                        _react2.default.createElement(
                            _reactBootstrap.FormGroup,
                            null,
                            _react2.default.createElement(
                                _reactBootstrap.InputGroup,
                                null,
                                _react2.default.createElement(_reactBootstrap.FormControl, { type: 'text', onChange: this.handleSearchChange.bind(this), onKeyPress: this.handleKeyPress.bind(this) }),
                                _react2.default.createElement(
                                    _reactBootstrap.InputGroup.Button,
                                    null,
                                    _react2.default.createElement(
                                        _reactBootstrap.Button,
                                        { onClick: this.makeAPICall.bind(this) },
                                        'Search'
                                    )
                                )
                            )
                        )
                    )
                )
            );
        }
    }]);

    return SimpleCounter;
}(_react2.default.Component);

exports.default = SimpleCounter;