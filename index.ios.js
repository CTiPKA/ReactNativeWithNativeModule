/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Image,
  NativeModules
} from 'react-native';
// import { Actions } from 'react-native-router-flux';
import ImagePicker from 'react-native-image-picker';

var CalendarManager = NativeModules.CalendarManager;
var styles = require('./src/common/styles');

export default class ProjectWithNewModule extends Component {

  state = {
    imageData: null,
    imageDataProcessed: null
  };

  // processImageToGrey(imageData) {
  //       CalendarManager.processImageToGrey(
  //           imageData,
  //           //errorCallback
  //           (results) => {
  //               alert('Error: ' + results[0]);
  //           },
  //           // successCallback
  //           (results) => {
  //             console.log('Results data: ', results);
  //             // getting uri of processed file from native module
  //             var resultsImage = {'uri': results};
  //
  //             // Update the state of the view
  //             this.setState({
  //                 imageDataProcessed : resultsImage
  //             });
  //           }
  //       );
  //   }

processImageDetectPellets(imageData) {
    CalendarManager.detectPelletsOnImage(
      imageData,
      //errorCallback
      (results) => {
        alert('Error: ' + results[0]);
      },
      // successCallback
      (results) => {
        console.log('Results data: ', results);
        // getting uri of processed file from native module
        var resultsImage = {'uri': results[1]};
        // Update the state of the view
        this.setState({
            imageDataProcessed : resultsImage
        });
      }
    );
}

  selectPhotoTapped() {
    const options = {
      title: 'Photo Picker',
      takePhotoButtonTitle: 'Take Photo...',
      chooseFromLibraryButtonTitle: 'Choose from Library...',
      quality: 0.5,
      maxWidth: 300,
      maxHeight: 300,
      allowsEditing: false,
      storageOptions: {
        skipBackup: true
      }
    };

    ImagePicker.showImagePicker(options, (response) => {
      // console.log('Response: ', response);
      if (response.didCancel) {
        console.log('User cancelled photo picker');
      }
      else if (response.error) {
        console.log('ImagePicker Error: ', response.error);
      }
      else if (response.customButton) {
        console.log('User tapped custom button: ', response.customButton);
      }
      else {
        this.setState({
          imageData: response
        })
        //passing image data for processing
        this.processImageDetectPellets(response);
      }
    });
  }

  //
  // var processImageToGrey = CalendarManager.processImageToGrey(
  //   image,
  //   function errorCallback(results) {
  //     alert('Error: ' + results[0]);
  //   },
  //   function successCallback(results) {
  //     alert('Success : ' + results[0]);
  //   }
  // );

  render() {
    // console.log('Image data: ', this.state.imageData);
    console.log('Processed image data: ', this.state.imageDataProcessed);
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <TouchableOpacity onPress={this.selectPhotoTapped.bind(this)}>
          <View style={[styles.avatar, styles.avatarContainer, {marginBottom: 20}]}>
            { this.state.imageData === null ? <Text>Select a Photo</Text> :
              <Image
                style={styles.avatar}
                source={this.state.imageData}
             />
            }
          </View>
        </TouchableOpacity>
        <Text style={styles.welcome}>
          Image processed with Pellet detector:
        </Text>

        <View style={[styles.avatar, styles.avatarContainer, {marginBottom: 20}]}>
          { this.state.imageDataProcessed === null ? <Text>Photo for processing not selected</Text> :
            <Image
              style={styles.avatar}
              source={this.state.imageDataProcessed}
            />
          }
        </View>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu{'\n'}
        </Text>
      </View>
    );
  }

}

AppRegistry.registerComponent('ProjectWithNewModule', () => ProjectWithNewModule);
