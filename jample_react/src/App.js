import React from 'react';
import './App.css';
import {  withStateMachine, State } from 'react-automata'
import axios from 'axios';
import { debounce } from "debounce";
import LastImported from './LastImported';

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
      onEntry: 'search_api',
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
    this.debouceInput = this.debouceInput.bind(this);
    // this.debouceDone = this.debouceDone.bind(this);
    this.debouceDone = debounce(this.debouceDone.bind(this),1000);
    this.state = {
      filter: '',
      results: null,
      searchResults: ['no filtered tracks'],
      numFilteredResults: 0
    }
  }

  search_api(){
    axios.post('http://localhost:3000/set_filter', {
      filter_text: this.state.filter,
    }).then((response) => {
      console.log("response.data: ", response.data);
      // console.log("response.data.current_filter_size: ", response.data.current_filter_size);
      // console.log("response.data.filter_set_tracks[0].title: ", response.data.filter_set_tracks[0].title);
      // console.log("response.data.filter_set_tracks[0].artist: ", response.data.filter_set_tracks[0].artist);
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

      this.setState({searchResults: filteredTracks})
      this.setState({numFilteredResults: response.data.current_filter_size} )
      this.props.transition('response')

    });
  }

  debouceDone(){
    console.log('hello from debouceDone()')
    this.props.transition('debounce')
  }

  debouceInput(e){
    console.log('hello from debouceInput(e)')
    this.setState({filter: e.target.value })
    this.props.transition('inputChange')
    this.debouceDone()
  }

  render() {
    return (
      <div>
        <div className="jampler">

          <div className="input">
            <input className="input_field" onChange={ this.debouceInput } />
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
                <li>
                  <a href="">{item}</a>
                </li>
              )}
            </ul>
          </div>

          <div>
            <LastImported parent_state={this.state} />
          </div>

          <h1 class="logo">Jampler</h1>

          <section id="lower-right-stripes">
            <div className="stripe-style" id="stripe1"></div>
            <div className="stripe-style" id="stripe2"></div>
            <div className="stripe-style" id="stripe3"></div>
            <div className="stripe-style" id="stripe4"></div>
          </section>
        </div>
      </div>
    )
  }
}

export default withStateMachine(statechart)(App)
