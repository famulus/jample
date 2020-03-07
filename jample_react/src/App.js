import React from 'react';
import './App.css';
import {  withStateMachine, State } from 'react-automata'
import axios from 'axios';
import { debounce } from "debounce";
import LastImported from './LastImported';
import Footer from './Footer';

const statechart = {
  initial: 'start',
  states: {
    start: {
      on: {
        inputChange: 'typing',
      },
      onEntry: 'start',
    },
    typing: {
      on: {
        debounce: 'requesting',
      },
    },
    requesting: {
      on: {
        response: 'results',
        inputChange: 'typing',
      },
      onEntry: 'searchAPI',
    },
    results: {
      on: {
        response: 'results',
        inputChange: 'typing',
      },
      onEntry: 'requesting',
    },
  },
}

class App extends React.Component {

  constructor( props ){
    super( props );
    this.debounceInput = this.debounceInput.bind(this);
    this.debounceDone = debounce(this.debounceDone.bind(this),1000);
    this.state = {
      filter: '',
      // results: null,
      searchResults: ['no filtered tracks'],
      numFilteredResults: 0
    }
  }

  searchAPI(){
    axios.post('http://localhost:3000/set_filter', {
      filter_text: this.state.filter,
    }).then((response) => {
      console.log("response.data: ", response.data);
      // console.log("response.data.filter_set_tracks[0].title: ", response.data.filter_set_tracks[0].title);
      // console.log("response.data.filter_set_tracks[0].path_and_file: ", response.data.filter_set_tracks[0].path_and_file);
      // console.log("response.status: ", response.status);
      // console.log("response.statusText: ", response.statusText);
      // console.log("response.headers: ", response.headers);
      // console.log("response.config: ", response.config);

      let filteredTracks = []
      // this.data = response.data.filter_set_tracks
      response.data.filter_set_tracks.forEach((item) => {

        // If the track title or artist data is null, then
        // show the path and file name so at least you have
        // some idea of what the track is.
        // If not, then great! Show the track title & artist
        if ((item.title !== null) && (item.artist !== null)) {
          filteredTracks.push(item.title + `, ` + item.artist)
        } else {
          filteredTracks.push(item.path_and_file)
        }

      })

      // If search does not yield any results,
      // display a 'no search results' message
      // so the user gets visual feedback
      if (this.state.numFilteredResults == 0) {
        filteredTracks.push("no search results for " + this.state.filter)
      }


      this.setState({searchResults: filteredTracks})
      this.setState({numFilteredResults: response.data.current_filter_size} )
      this.props.transition('response')

    });
  }

  debounceDone(){
    console.log('hello from debounceDone()')
    this.props.transition('debounce')
  }

  debounceInput(e){
    console.log('hello from debounceInput(e)')
    this.setState({filter: e.target.value })
    this.props.transition('inputChange')
    this.debounceDone()
  }



//  ==================================
//  And finally, the render
//  ==================================
  render() {
    return (
      <div>
        <div className="jampler">

          <div className="input">
            <input className="input_field" onChange={this.debounceInput} />
            <div className="message">
              <State is="start">START</State>
              <State is="typing">TYPING</State>
              <State is="requesting">REQUESTING</State>
              <State is="results">results</State>
            </div>
          </div>

          <div className="num-filtered-tracks">
            Number of Filtered Tracks: {this.state.numFilteredResults}
          </div>

          <h2>Filtered Tracks:</h2>
          <div className="filtered-tracks">
            <ul>
              {this.state.searchResults.map( item =>
                <li>{item}
                </li>
              )}
            </ul>
          </div>

          <LastImported parent_state={this.state} />
          <Footer />

        </div>
      </div>
    )
  }
}

export default withStateMachine(statechart)(App)
