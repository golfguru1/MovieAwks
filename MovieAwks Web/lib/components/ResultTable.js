'use strict';

Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactBootstrap = require('react-bootstrap');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var ResultTable = function (_React$Component) {
    _inherits(ResultTable, _React$Component);

    function ResultTable(props) {
        _classCallCheck(this, ResultTable);

        return _possibleConstructorReturn(this, (ResultTable.__proto__ || Object.getPrototypeOf(ResultTable)).call(this, props));
    }

    _createClass(ResultTable, [{
        key: 'render',
        value: function render() {
            var rows = [];
            if (this.props.result.results) {
                this.props.result.results.forEach(function (movie) {
                    rows.push(_react2.default.createElement(ResultTableRow, { movie: movie, key: movie.id }));
                });
            }
            return _react2.default.createElement(
                _reactBootstrap.Table,
                null,
                _react2.default.createElement(
                    'tbody',
                    null,
                    rows
                )
            );
        }
    }]);

    return ResultTable;
}(_react2.default.Component);
/*
{
"poster_path": "/s2IG9qXfhJYxIttKyroYFBsHwzQ.jpg",
"adult": false,
"overview": "After being held captive in an Afghan cave, billionaire engineer Tony Stark creates a unique weaponized suit of armor to fight evil.",
"release_date": "2008-04-30",
"genre_ids": [
28,
878,
12
],
"id": 1726,
"original_title": "Iron Man",
"original_language": "en",
"title": "Iron Man",
"backdrop_path": "/ZQixhAZx6fH1VNafFXsqa1B8QI.jpg",
"popularity": 6.749554,
"vote_count": 6295,
"video": false,
"vote_average": 7.3
}
*/

exports.default = ResultTable;

var ResultTableRow = function (_React$Component2) {
    _inherits(ResultTableRow, _React$Component2);

    function ResultTableRow(props) {
        _classCallCheck(this, ResultTableRow);

        var _this2 = _possibleConstructorReturn(this, (ResultTableRow.__proto__ || Object.getPrototypeOf(ResultTableRow)).call(this, props));

        _this2.getRating();
        _this2.state = {
            averageRating: "-"
        };
        return _this2;
    }

    _createClass(ResultTableRow, [{
        key: 'getRating',
        value: function getRating() {
            $.ajax({
                url: 'https://movie-app-c6978.firebaseio.com/movies.json?orderBy="movieID"&equalTo=' + this.props.movie.id,
                method: 'GET',
                success: function (apiResult) {
                    var averageReview = 0;
                    var num = 0;
                    var object = {};

                    for (var id in apiResult) {
                        var movie = apiResult[id];
                        averageReview += movie.ratingValue;
                        num += 1;
                    }
                    var average = Math.round(averageReview / num);
                    if (average) {
                        this.setState(_defineProperty({}, this.props.movie.id, average));
                    }
                }.bind(this)
            });
        }
    }, {
        key: 'render',
        value: function render() {
            var movie = this.props.movie;
            var movieName = movie.original_title;
            var movieImageURL;
            if (movie.poster_path) {
                movieImageURL = "http://image.tmdb.org/t/p/w300" + movie.poster_path;
            }
            var movieID = movie.id;
            return _react2.default.createElement(
                'tr',
                null,
                _react2.default.createElement(
                    'td',
                    null,
                    _react2.default.createElement(
                        _reactBootstrap.Media,
                        null,
                        _react2.default.createElement(
                            _reactBootstrap.Media.Left,
                            { align: 'middle' },
                            _react2.default.createElement(_reactBootstrap.Image, { src: movieImageURL, style: { width: 80 } })
                        )
                    )
                ),
                _react2.default.createElement(
                    'td',
                    null,
                    _react2.default.createElement(
                        'p',
                        { style: { float: "left" } },
                        movieName
                    ),
                    _react2.default.createElement(
                        'p',
                        { style: { float: "right" } },
                        movie.release_date
                    ),
                    _react2.default.createElement(
                        'p',
                        null,
                        this.state[movieID]
                    )
                )
            );
        }
    }]);

    return ResultTableRow;
}(_react2.default.Component);