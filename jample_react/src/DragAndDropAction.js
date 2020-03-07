import React from 'react';
import './App.css';
// import axios from 'axios';


// https://reactjs.org/docs/refs-and-the-dom.html

export default class DragAndDropAction extends React.Component {

    constructor(props) {
      super(props);

      this.state = {
        dragging: false,
        files:["no dragged tracks"]
      };
    }

  // this.importDraggedTracks = this.importDraggedTracks.bind(this)
  dropRef = React.createRef()

  // we need our component to listen to four events
  // so we create a listener for each
  // preventDefault() stops the browser from default behavior (opening the file)
  // stopPropagation() stops the event from being propagated through parent & child
  handleDrag = (e) => {
    console.log("handleDrag")
    e.preventDefault()
    e.stopPropagation()
  }

  handleDragIn = (e) => {
    console.log("handleDragIn")
    e.preventDefault()
    e.stopPropagation()
    this.dragCounter++
    if (e.dataTransfer.items && e.dataTransfer.items.length > 0) {
      this.setState({dragging: true})
    }
  }

  handleDragOut = (e) => {
    console.log("handleDragOut")
    e.preventDefault()
    e.stopPropagation()
    this.dragCounter--
      if (this.dragCounter > 0) return
    this.setState({dragging: false})
  }

 // 1) hide overaly
 // 2) check that there are files
 // 3) pass array to our callback
 // 4) clear dataTransfer array
 // 5) reset drag counter
  handleDrop = (e) => {
    e.preventDefault()
    e.stopPropagation()
    this.setState({dragging: false})
    if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
      this.props.handleDrop(e.dataTransfer.files)
      // sarah
      // this.setState({files: e.dataTransfer.files} )

      e.dataTransfer.clearData()
      this.dragCounter = 0
    }
      // sarah
      // console.log("files: ", this.state.files)
  }

  // we add each of the four listeners in componentDidMount()
  componentDidMount() {
    this.dragCounter = 0
    let div = this.dropRef.current
    div.addEventListener('dragenter', this.handleDragIn)
    div.addEventListener('dragleave', this.handleDragOut)
    div.addEventListener('dragover', this.handleDrag)
    div.addEventListener('drop', this.handleDrop)
  }

  // we remove each of the four listeners in componentWillUnmount()
  componentWillUnmount() {
    let div = this.dropRef.current
    div.removeEventListener('dragenter', this.handleDragIn)
    div.removeEventListener('dragleave', this.handleDragOut)
    div.removeEventListener('dragover', this.handleDrag)
    div.removeEventListener('drop', this.handleDrop)
  }













  //  ==================================
  //  And finally, the render
  //  ==================================
  render() {
    return (

      <section>
      <h2>Drag & Drop Tracks:</h2>
      <div
        className="drag-drop-field"
        ref={this.dropRef}
      >
        {this.state.dragging &&
          <div
            style={{
              border: 'dashed grey 4px',
              backgroundColor: 'rgba(255,255,255,.8)',
              position: 'absolute',
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              zIndex: 9999
            }}
          >
            <div
              style={{
                position: 'absolute',
                top: '50%',
                right: 0,
                left: 0,
                textAlign: 'center',
                color: 'grey',
                fontSize: 36
              }}
            >
              <div>drop here :)</div>
            </div>
          </div>
        }
        {this.props.children}
      </div>
      </section>
    )
  }
}

          // {this.state.dragDropBucket}
