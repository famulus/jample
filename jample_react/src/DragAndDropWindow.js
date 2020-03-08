import React, { Component } from 'react'
import axios from 'axios';
import DragAndDropAction from './DragAndDropAction'



export default class DragAndDropWindow extends Component {
    constructor(props) {
    super(props);

    this.state = {
      files:[]
    };

    this.sendTrackToDatabase = this.sendTrackToDatabase.bind(this)

  }

 handleDrop = (files) => {
    let fileList = this.state.files
    for (let i = 0; i < files.length; i++) {
      if (!files[i].name) return
      fileList.push(files[i].name)
    }
    this.setState({files: fileList})
    console.log("files from DragAndDropWindow.js: ", files)
    this.sendTrackToDatabase()
  }


  // TODO: post contents of "files" to database
  // NOT WORKING
  // ? What path should I use?
  sendTrackToDatabase(files){
    console.log("hello from sendTrackToDatabase()")

    axios.post('http://localhost:3000/drag_and_drop', {
      artist: "Sark Muppes",
      title: "Snekdown Boogie"
    })
      .then((response) => {
        console.log("response: ", response);
        console.log("response.data: ", response.data);
      })
      .catch(function (error) {
        console.log("Oh no! Error!: ", error);
       });
  }

//  ==================================
//  And finally, the render
//  ==================================
render() {
    return (
      <DragAndDropAction handleDrop={this.handleDrop}>
        <div style={{height: 200, width: 300}}>
          {this.state.files.map((file, i) =>
            <div key={i}>{file}</div>
          )}
        </div>
      </DragAndDropAction>
    )
  }
}

