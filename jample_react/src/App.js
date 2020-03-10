import React from 'react';
import './App.css';
import {  withStateMachine, State } from 'react-automata'
import axios from 'axios';
import { debounce } from "debounce";
import LastImported from './LastImported';
import DragAndDropWindow from './DragAndDropWindow';
import Footer from './Footer';

const statechart = {
  initial: 'start',
  states: {
    start: {
      on: {
        inputChange: 'typing',
        debounce: 'requesting',
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
        inputChange: 'typing',
        debounce: 'requesting',

      },
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
      searchResults: [],
      numFilteredResults: 0
    }
  }

  searchAPI(){
    axios.post('http://localhost:3000/set_filter', {
      filter_text: this.state.filter,
    }).then((response) => {
      this.setState({searchResults: response.data.filter_set_tracks})
      this.setState({numFilteredResults: response.data.current_filter_size} )
      this.props.transition('response')

      // If search does not yield any results,
      // display a 'no search results' message
      // so the user gets visual feedback

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

  updateFilterFromChild(e){
    document.getElementById("filterInput").value = e;
    this.setState({filter: e })
    this.props.transition('debounce')


  }

//  ==================================
//  And finally, the render
//  ==================================
  render() {

    var emptyMessage
    if(this.state.numFilteredResults == 0){
       emptyMessage =
        <ul>
          {"no search results for search term " + this.state.filter}
        </ul>
    }



    return (
      <div>
        <div className="jampler">


          <div className="input" >
            <input id="filterInput" className="input_field" onChange={this.debounceInput} />
            <div className="message">
              <State is="start">START</State>
              <State is="typing">TYPING</State>
              <State is="requesting"><img src="https://media.giphy.com/media/2WjpfxAI5MvC9Nl8U7/giphy.gif"/></State>
              <State is="results">results</State>
            </div>
          </div>

          <div className="num-filtered-tracks">
            Number of Filtered Tracks: {this.state.numFilteredResults}
          </div>

          <h2>Filtered Tracks:</h2>
          <div className="filtered-tracks">
            <ul>
            {console.log(this.state.searchResults)}
              {this.state.searchResults.map( item =>
                <li key={item._id.$oid}> {item.path_and_file} </li>
              )}
            </ul>
            <State is="results">{emptyMessage}</State>


          </div>

          <LastImported
            parent_state={this.state}
            updateFilterFromChild={   (arg)=>{this.updateFilterFromChild(arg)}  } />

          <DragAndDropWindow parent_state={this.state} />


          <Footer />

        </div>
      </div>
    )
  }
}

export default withStateMachine(statechart)(App)

        // <section className="jample-board">

        //   <section className="stripes">
        //     <div className="stripe1"></div>
        //     <div className="stripe2"></div>
        //     <div className="stripe3"></div>
        //     <div className="stripe4"></div>
        //   </section>

        // </section>


