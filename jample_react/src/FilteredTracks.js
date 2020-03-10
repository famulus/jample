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
    this.setFilter = this.setFilter.bind(this);

  }

  setFilter(event){
    // console.log("hello from setFilter()")
    // console.log(event.target.attributes.trackid.value)
    const trackId = event.target.attributes.trackid.value
     // {console.log(trackId)}
    this.props.updateFilterFromChild( trackId )
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
      <div>
        <div className="input" >
          <input id="filterInput" className="input_field" onChange={this.props.debounceInput} value={this.props.parentState.filter}/>
          <div className="message">
            <State is="requesting">
            <img style={{'width': '50px', 'height':'30px'}} src="https://media.giphy.com/media/2WjpfxAI5MvC9Nl8U7/giphy.gif"/>
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
              <li key={item._id.$oid} trackId={item._id.$oid} onClick={this.setFilter}> {item.formattedTitle} </li>
            )}
          </ul>
          <State is="results">{emptyMessage}</State>
        </div>
      </div>
    )
  }
}

