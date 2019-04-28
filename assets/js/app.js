// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
import { Howl, Howler } from 'howler';


var guitarSound = new Howl({
    src: ['sounds/a_maj_guitar.mp3']
});

//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

window.playGuitar = ({ chord, stroke }) => {
    console.log(`Playing ${chord} in a ${stroke}-stroke`)
    guitarSound.play()
}

import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live");




liveSocket.connect();

