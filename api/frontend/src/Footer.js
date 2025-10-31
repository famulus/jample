import React from 'react';
import './App.css';


// This component contains the Jampler logo and the
// cute stripes in the lower right



export default class Footer extends React.Component {
  render() {
    return(

      <footer>

        <h1 className="logo">Jampler</h1>

        <section id="lower-right-stripes">
          <div className="stripe-style" id="stripe1"></div>
          <div className="stripe-style" id="stripe2"></div>
          <div className="stripe-style" id="stripe3"></div>
          <div className="stripe-style" id="stripe4"></div>
        </section>

      </footer>

      );

  }
}
