import React from 'react';
import './App.css';
import axios from 'axios';

export default class LastImported extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      lastImported:["test", "test2", "test3"]
    };

    this.findRecentImports = this.findRecentImports.bind(this)

  }


    findRecentImports() {
      console.log("penguin from findRecentImports()")
      axios.get('http://localhost:3000/get_recent_tracks')
       .then((response) => {
          console.log("Recent Imports:" , response.data);

            let tracks = []
            this.data = response.data;
            this.data.forEach((item) => {
            console.log("track: ", item.path_and_file)
            tracks.push(item.path_and_file)
          })

          this.setState({lastImported: tracks} )

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
        Last Imported:
        <div className="imported-items">

          {this.state.lastImported}

        </div>
      </div>


    );




  }
}

