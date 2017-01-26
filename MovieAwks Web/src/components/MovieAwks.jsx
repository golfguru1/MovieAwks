import React from 'react';
import Search from './Search';
import {PageHeader} from 'react-bootstrap';

export default class MovieAwks extends React.Component {
  render() {
    return (
      <div>
        <PageHeader>MovieAwks</PageHeader>
        <Search />
      </div>
    );
  }
}
