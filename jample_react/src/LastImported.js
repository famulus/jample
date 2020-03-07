import React from 'react';
import './App.css';
import axios from 'axios';



// This component displays the last 15 tracks imported into
// the music storage. The limit of 15 is set on the back end.

export default class LastImported extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      lastImported:["no imported tracks"]
    };

    this.findRecentImports = this.findRecentImports.bind(this)

  }


    findRecentImports() {
      console.log("hello from findRecentImports()")
      axios.get('http://localhost:3000/get_recent_tracks')
       .then((response) => {
          console.log("Recent Imports:" , response.data);

            let tracks = []
            this.data = response.data;
            this.data.forEach((item) => {

              // If the track title or artist data is null, then
              // show the path and file name so at least you have
              // some idea of what the track is.
              // If not, then great! Show the track title & artist
              if ((item.title !== null) && (item.artist !== null)) {
                console.log("track artist: ", item.artist)
                console.log("track title: ", item.title)
                tracks.push(item.title + `, ` + item.artist)
              } else {
                tracks.push(item.path_and_file)
              }
          })

          this.setState({lastImported: tracks})

    });
  }




    componentDidMount() {
        this.findRecentImports()
    }

  //  ==================================
  //  And finally, the render
  //  ==================================
  render() {
    return(

      <div>
        <h2>Last Imported:</h2>

        <div className="last-imported">

          <ul>

          {this.state.lastImported.map( item =>
            <li key={item} onClick={this.makeFilteredTrack}>
              {item}
            </li>
          )}

          </ul>

        </div>
      </div>


    );




  }
}

