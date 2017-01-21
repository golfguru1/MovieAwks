var request = require("request")
var express = require("express")
var dateformat = require("dateformat")
var app = express();
var port = process.env.PORT || 3000;

var comments = []

function currentDate() {
    var date = new Date()
    date = dateformat(date, "isoDateTime").replace("T", " ")
    var n = date.lastIndexOf("-");
    date = date.slice(0, n) + date.slice(n).replace("-", " -");
    return date
}


app.post('/generate', function(req, res) {

    var movieID //generatethis
    var ratingValue = Math.floor(Math.random() * 10) + 1;
    var comment //make a list of these and populate it randomly
    var date = currentDate()

    var postData = {
        "movieID": movieID,
        "ratingValue": ratingValue,
        "user": "jimmer",
        "comment": comment,
        "email": "jimmer@hotmail.com",
        "timestamp": date
    }
    console.log(postData);

    // var options = {
    //     method: 'post',
    //     body: postData,
    //     json: true,
    //     url: "https://movie-app-c6978.firebaseio.com/movies.json?auth=NHWNyUxhnToXrgImq4pY06EtfBc4duNNZUYqFS3R"
    // }
    //
    // request(options, function (err, res, body) {
    //
    // }

    res.sendStatus(200);
});

app.listen(port)

console.log('Magic happens on port ' + port);
