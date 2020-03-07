import React, { Component } from 'react'
import DragAndDropAction from './DragAndDropAction'



export default class DragAndDropWindow extends Component {
state = {
    files: []
  }


 handleDrop = (files) => {
    let fileList = this.state.files
    for (let i = 0; i < files.length; i++) {
      if (!files[i].name) return
      fileList.push(files[i].name)
    }
    this.setState({files: fileList})
    console.log("files from DragAndDropWindow: ", files)
  }


  // TODO: post contents of "files" to database
  //


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

