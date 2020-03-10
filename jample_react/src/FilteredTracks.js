import React from 'react';
import './App.css';
import { State } from 'react-automata'





export default class FilteredTracks extends React.Component {

  constructor(props) {
    super(props);

    // 'this' binding
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
    if(this.props.parentState.numFilteredResults === 0){
       emptyMessage =
        <ul>
          {"no search results for search term " + this.props.parentState.filter}
        </ul>
    }

    return(
      <div>
        <div className="input" >
          <input id="filterInput" className="input-field" onChange={this.props.debounceInput} value={this.props.parentState.filter}/>
          <div className="message">
            <State is="requesting">


            <section className='loading-spinner'>
              <div className='ball fade-in-1'></div>
              <div className='ball fade-in-2'></div>
              <div className='ball fade-in-3'></div>
            </section>

            </State>
          </div>
        </div>

        <div className="num-filtered-tracks">
          Number Filtered Tracks: {this.props.parentState.numFilteredResults}
        </div>

        <h2>Filtered Tracks:</h2>
        <div className="filtered-tracks">
          <ul>
            {searchResults.map( item =>
              <li key={item._id.$oid} trackid={item._id.$oid} onClick={this.setFilter}> {item.formattedTitle} </li>
            )}
          </ul>
          <State is="results">{emptyMessage}</State>
        </div>
      </div>
    )
  }
}


            // <section className="loading-spinner-container">
            //   <img className="loading-spinner" src="https://media.giphy.com/media/2WjpfxAI5MvC9Nl8U7/giphy.gif"/>
            // </section>
