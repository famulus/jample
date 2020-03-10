import React from 'react';
import './App.css';
import {  withStateMachine, State } from 'react-automata'
import axios from 'axios';
import { debounce } from "debounce";
import LastImported from './LastImported';
import DragAndDropWindow from './DragAndDropWindow';
import FilteredTracks from './FilteredTracks';
import Footer from './Footer';
import truncate from 'truncate';


const statechart = {
  initial: 'start',
  states: {
    start: {
      on: {
        typing: 'typing',
        requesting: 'requesting',
      },
      onEntry: 'start',
    },
    typing: {
      on: {
        requesting: 'requesting',
      },
    },
    requesting: {
      on: {
        results: 'results',
        typing: 'typing',
      },
      onEntry: 'searchAPI',
    },
    results: {
      on: {
        typing: 'typing',
        requesting: 'requesting',

      },
    },
  },
}

class App extends React.Component {

  constructor( props ){
    super( props );
    this.formatTracks = this.formatTracks.bind(this);
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
      this.props.transition('results')
    });
  }

  debounceDone(){
    console.log('hello from debounceDone()')
    this.props.transition('requesting')
  }

  debounceInput(e){
    console.log('hello from debounceInput(e)')
    this.setState({filter: e.target.value })
    this.props.transition('typing')
    this.debounceDone()
  }

  updatefilterfromchild(e){
    document.getelementbyid("filterinput").value = e;
    this.setstate({filter: e })
    this.props.transition('requesting')
  }
  updateFilter(e){
    this.setstate({filter: e })
    this.props.transition('requesting')
  }

  formatTracks(tracks){
    const displayTracks = tracks.map( item  => {
      if ((item.title !== null) && (item.artist !== null)) {
        item.formattedTitle = (item.title + `, ` + item.artist)
      } else {
        item.formattedTitle = (item.path_and_file)
      }
      item.formattedTitle = truncate(item.formattedTitle, 200)
      return item
    })

    return displayTracks

  }

//  ==================================
//  And finally, the render
//  ==================================
  render() {

    return (
      <div>
        <div className="jampler">

          <FilteredTracks
            parentState={this.state}
            debounceInput={   (arg)=>{this.debounceInput(arg)}  }
            formatedTracks = {this.formatTracks(this.state.searchResults)}
           />

          <LastImported
            parentState={this.state}
            updateFilterFromChild={   (arg)=>{this.updateFilterFromChild(arg)}  }
           />

          <DragAndDropWindow
            parentState={this.state}
          />

          <Footer />

        </div>
      </div>
    )
  }
}

export default withStateMachine(statechart)(App)
