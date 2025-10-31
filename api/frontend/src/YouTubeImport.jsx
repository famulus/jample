import React from 'react';
import './App.css';
import axios from 'axios';


export default class YouTubeImport extends React.Component {

  constructor(props) {
    super(props);

    // 'this' binding
    this.setYouTubeURL = this.setYouTubeURL.bind(this);

  }

    setYouTubeURL(event){
      // console.log("hello from setYouTubeURL()")
      // console.log(event.target.attributes)
    }





    // Are we going to use a state machine here?
    // OR, seeing as the field is only accepting a pasted URL,
    // is it enough to delay the database call for half a second?













  //  ==================================
  //  And finally, the render
  //  ==================================
  render() {
    return(
      <div>
      </div>
    );
  }

}
