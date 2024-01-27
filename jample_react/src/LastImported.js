import React from 'react';
import './App.css';
import axios from 'axios';

export default class LastImported extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      lastImported:["no tracks"]
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
            // logging path_and_file b/c artist & track name are blank
            console.log("track: ", item.path_and_file)
            tracks.push(item.path_and_file)
          })

          this.setState({lastImported: tracks} )

    }).catch((error) => {
      // Error
      if (error.response) {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx
          console.log('error.response.data:', error.response.data);
          console.log('error.response.status:', error.response.status);
          console.log('error.response.headers:', error.response.headers);
      } else if (error.request) {
          // The request was made but no response was received
          // `error.request` is an instance of XMLHttpRequest in the 
          // browser and an instance of
          // http.ClientRequest in node.js
          console.log('Error.request:', error.request);
      } else {
          // Something happened in setting up the request that triggered an Error
          console.log('Error:', error.message);
      }
      console.log(error.config);
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

      <div className="last-imported">
        <div className="imported-items">

          <ul>
            Last Imported:

          {this.state.lastImported.map( track => <li>{track}</li>)}

          </ul>

        </div>
      </div>


    );




  }
}

