import React from 'react';
import './App.css';
import {  withStateMachine, State } from 'react-automata'
import axios from 'axios';
import { debounce } from "debounce";

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
    this.state = {filter: '', results: null}
  }

  search_api(){
    axios.post('http://localhost:3000/set_filter', {
      filter_text: this.state.filter,
    }).then((response) => {
      console.log(response.data);
      console.log(response.status);
      console.log(response.statusText);
      console.log(response.headers);
      console.log(response.config);
          this.setState({results: response.data} )
          this.props.transition('response')

    });
  }

  debouceDone(){
    console.log('osdfs')
    this.props.transition('debounce')
  }

  debouceInput(e){
    console.log('ok')
    this.setState({filter: e.target.value })
    this.props.transition('inputChange')
    this.debouceDone()
  }

  render() {
    return (
      <div>
        <div className="jample">

          <div className="input">
            <input className="input_field" onChange={ this.debouceInput } />
            <div className="message">
              <State is="start">START</State>
              <State is="typing">TYPING</State>
              <State is="requesting">REQUESTING</State>
              <State is="results">results</State>
            </div>
          </div>


        </div>
      </div>
    )
  }
}

export default withStateMachine(statechart)(App)
