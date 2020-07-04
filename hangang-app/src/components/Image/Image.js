import React, { Component } from 'react';
import styled from 'styled-components';
import back1 from '../../img/back1.jpg';
import back2 from '../../img/back2.jpg';
import back3 from '../../img/back3.jpg';
import back4 from '../../img/back4.jpg';
import back5 from '../../img/back5.jpg';
var num = Math.round(Math.random() * 5);
var backs = [back1, back2, back3, back4, back5];

const Container = styled.div`
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(
      to right,
      rgba(20, 20, 20, 0.1) 10%,
      rgba(20, 20, 20, 0.7) 70%,
      rgba(20, 20, 20, 1)
    ),
    url(${backs[num]});
  background-size: cover;
`;

class Image extends Component {
    render() {
        return (
            <Container />
        )
    }
}

export default Image;