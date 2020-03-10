import React from 'react';
import './App.css';
import axios from 'axios';
import truncate from 'truncate';
import { State } from 'react-automata'



// This component displays the last 15 tracks imported into
// the music storage. The limit of 15 is set on the back end.

export default class FilteredTracks extends React.Component {

  constructor(props) {
    super(props);

  }


  //  ==================================
  //  And finally, the render
  //  ==================================
  render() {
    var searchResults = this.props.formatedTracks
    var emptyMessage
    if(this.props.parentState.numFilteredResults == 0){
       emptyMessage =
        <ul>
          {"no search results for search term " + this.props.parentState.filter}
        </ul>
    }

    return(
      <>
        <div className="input" >
          <input id="filterInput" className="input_field" onChange={this.props.debounceInput} />
          <div className="message">
            <State is="requesting">
            <img style={{'width': '20px', 'height':'20px'}} src="https://media.giphy.com/media/2WjpfxAI5MvC9Nl8U7/giphy.gif"/>
            </State>
          </div>
        </div>

        <div className="num-filtered-tracks">
          Number of Filtered Tracks: {this.props.parentState.numFilteredResults}
        </div>

        <h2>Filtered Tracks:</h2>
        <div className="filtered-tracks">
          <ul>
            {searchResults.map( item =>
              <li key={item._id.$oid}> {item.formattedTitle} </li>
            )}
          </ul>
          <State is="results">{emptyMessage}</State>
        </div>
      </>
      )
  }
}

