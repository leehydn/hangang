import React, { Component } from 'react';
import styled from 'styled-components';
var srcf = '../../img/back' + (1 + Math.round(5 * Math.random())) + '.png';
backgroundImage = import(srcf);

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
    url(${backgroundImage});
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