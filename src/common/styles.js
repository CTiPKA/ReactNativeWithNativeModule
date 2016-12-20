import React, { Component } from 'react';
import {
  Navigator,
  PixelRatio,
  StyleSheet,
  Platform
} from 'react-native';

import Colors from './colors';

const {width, height} = require('Dimensions').get('window');

// create different padding sizes for tablet and phones based on iPhone breakpoints
const PADDING = width <= 375 ? 10 : 20;

module.exports = StyleSheet.create({

  /** DEFAULT **/

  containerGeneric: {
    flex: 1,
  },
  mainContainer:{
    flex:1,
    backgroundColor: '#FFF',
    justifyContent: 'center',
    alignItems: 'center'
  },
  mainContainerUnderHeader: {
    marginTop: 60,
    flex:1,
    backgroundColor: '#FFF',
  },
  paddedContainer: {
    padding: PADDING,
    flex:1,
    justifyContent: 'center',
    alignItems: 'center'
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  actionLinkText: {
    color: '#0000FF',
  },
  avatarContainer: {
    borderColor: '#9B9B9B',
    borderWidth: 1 / PixelRatio.get(),
    justifyContent: 'center',
    alignItems: 'center'
  },
  avatar: {
    borderRadius: 75,
    width: 150,
    height: 150
  },
  base64: {
    flex: 1,
    height: 50,
    resizeMode: 'contain',
  },


});
