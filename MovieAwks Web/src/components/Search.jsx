import React from 'react';
import {Button, Grid, Row, Col, FormGroup, InputGroup, FormControl} from 'react-bootstrap';
import ResultTable from './ResultTable'

export default class Search extends React.Component {

    constructor(props){
        super(props);

        this.state = {
            result: {}
        }
    }

    makeAPICall() {
        $.ajax({
            url: 'https://api.themoviedb.org/3/search/movie',
            method: 'GET',
            data: {
                "api_key": "05fb742d973ead23b8c11c9d46e53260",
                "query": this.state.searchText
            },
            success: function(apiResult) {
                this.setState({result: apiResult})
            }.bind(this)
        });
    }

    handleKeyPress(event){
        if (event.charCode === 13){
            event.preventDefault()
            this.makeAPICall()
        }
    }

    handleSearchChange(event){
        this.setState({searchText: event.target.value})
    }


    render() {
        return (
            <Grid>
                <Row>
                    <Col sm={6} md={6} lg={6} smOffset={3} mdOffset={3} lgOffset={3}>
                        <FormGroup>
                          <InputGroup>
                            <FormControl type="text" onChange={this.handleSearchChange.bind(this)} onKeyPress={this.handleKeyPress.bind(this)}/>
                            <InputGroup.Button>
                              <Button onClick = {this.makeAPICall.bind(this)} >Search</Button>
                            </InputGroup.Button>
                          </InputGroup>
                        </FormGroup>
                    </Col>
                </Row>
                <Row>
                    <Col lg={12}>
                        <ResultTable result={this.state.result} />
                    </Col>
                </Row>
            </Grid>
        );
    }
}
