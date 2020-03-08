import React from 'react';
import './App.css';
import axios from 'axios';



// This component displays the last 15 tracks imported into
// the music storage. The limit of 15 is set on the back end.

export default class LastImported extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      lastImported:[]
    };
    this.findRecentImports = this.findRecentImports.bind(this)
    this.setFilter = this.setFilter.bind(this)
  }


  findRecentImports() {
    console.log("hello from findRecentImports()")
    axios.get('http://localhost:3000/get_recent_tracks')
     .then((response) => {
        console.log("Recent Imports:" , response.data);
        this.setState({lastImported: response.data})
    });
  }

  setFilter(event){
    // console.log("hello from setFilter()")
    // console.log(event.target.attributes.trackid.value)
    const trackId = event.target.attributes.trackid.value
     {console.log(trackId)}
    this.props.updateFilterFromChild( trackId )
  }

  componentDidMount() {
      this.findRecentImports()
  }

  //  ==================================
  //  And finally, the render
  //  ==================================
  render() {
    const displayTracks = this.state.lastImported.map( item  => {
      if ((item.title !== null) && (item.artist !== null)) {
        item.formattedTitle = (item.title + `, ` + item.artist)
      } else {
        item.formattedTitle = (item.path_and_file)
      }
      return item
    })

    return(
      <div>
        <h2>Last Imported:</h2>

        <div className="last-imported">

          <ul>
             {displayTracks.map( item =>{
              return(
                <li key={item._id.$oid} trackId={item._id.$oid} onClick= {this.setFilter }>
                  {item.formattedTitle}
                </li>
                )
               })
              }
          </ul>

        </div>
      </div>


    );




  }
}

