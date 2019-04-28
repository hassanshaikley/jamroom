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


const guitarSounds = {
    a: new Howl({
        src: ['sounds/ax-grinder__a2-pmute.wav']
    }),
    b: new Howl({
        src: ['sounds/ax-grinder__b2-pmute.wav']
    }),
    c: new Howl({
        src: ['sounds/ax-grinder__c2-pmute.wav']
    }),
    d: new Howl({
        src: ['sounds/ax-grinder__d2-pmute.wav']
    }),
    e: new Howl({
        src: ['sounds/ax-grinder__e2-pmute.wav']
    }),
    f: new Howl({
        src: ['sounds/ax-grinder__f2-pmute.wav']
    }),
    g: new Howl({
        src: ['sounds/ax-grinder__g2-pmute.wav']
    })
}



//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

window.playGuitar = ({ chord, stroke }) => {
    if (guitarSounds[chord]) {
        guitarSounds[chord].play()

    } else {
        console.log(`Failed to find chord ${chord}`)
    }
}

const drumSounds = {
    s: new Howl({
        src: ['sounds/snare-drum.wav']
    }),
    k: new Howl({
        src: ['sounds/kick-drum.wav']
    }),
    b: new Howl({
        src: ['sounds/bass-drum.wav']
    }),
}

window.playDrum = ({ key }) => {

    console.log(key, drumSounds)

    drumSounds[key].play()
}

import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live");




liveSocket.connect();

