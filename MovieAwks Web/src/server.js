import React from 'react';
import ReactDOMServer from 'react-dom/server';
import MovieAwks from './components/MovieAwks';
import express from 'express';
import ResultTable from './components/ResultTable';

let app = express();

// Set the view engine to ejs
app.set('view engine', 'ejs');

// Serve static files from the 'public' folder
app.use(express.static('public'));

// GET /
app.get('/', function (req, res) {
  res.render('layout', {
    container: ReactDOMServer.renderToString(<MovieAwks />),
  });
});

// Start server
let server = app.listen(1337, function () {
  let host = server.address().address;
  let port = server.address().port;

  if (host === '::') {
    host = 'localhost';
  }

  console.log('Example app listening at http://%s:%s', host, port);
});
