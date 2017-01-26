import React from 'react';
import {Media, Table, Image, Grid, Row, Col} from 'react-bootstrap';

export default class ResultTable extends React.Component {
    constructor(props) {
        super(props);
    }

    render (){
        var rows = [];
        if (this.props.result.results){
            this.props.result.results.forEach(function(movie){
                rows.push(
                    <ResultTableRow movie={movie} key={movie.id}/>
                );
            })
        }
        return (
            <Table>
                <tbody>
                    {rows}
                </tbody>
            </Table>
        );
    }
}
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

class ResultTableRow extends React.Component {
    constructor(props){
        super(props)
        this.getRating()
        this.state = {
            averageRating: "-"
        }
    }

    getRating(){
        $.ajax({
            url: 'https://movie-app-c6978.firebaseio.com/movies.json?orderBy="movieID"&equalTo='+this.props.movie.id,
            method: 'GET',
            success: function(apiResult) {
                var averageReview = 0;
                var num = 0;
                var object = {}

                for (var id in apiResult){
                    var movie = apiResult[id]
                    averageReview += movie.ratingValue
                    num +=1
                }
                var average = Math.round(averageReview/num)
                if (average){
                    this.setState({[this.props.movie.id]: average })
                }
            }.bind(this)
        });
    }

    render() {
        var movie = this.props.movie
        var movieName = movie.original_title
        var movieImageURL
        if (movie.poster_path){
            movieImageURL = "http://image.tmdb.org/t/p/w300"+movie.poster_path
        }
        var movieID = movie.id
        return (
            <tr>
                <td>
                    <Media>
                        <Media.Left align="middle">
                            <Image src={movieImageURL} style={{width: 80}}/>
                        </Media.Left>
                    </Media>
                </td>
                <td>
                    <p style={{float: "left"}}>{movieName}</p><p style={{float: "right"}}>{movie.release_date}</p>
                    <p>{this.state[movieID]}</p>
                </td>
            </tr>
        )


    }
}
