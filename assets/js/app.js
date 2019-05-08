import css from "../css/app.css"

import "phoenix_html"
import LiveSocket from "phoenix_live_view"

import { guitarSounds, drumSounds } from './sounds'

window.playGuitar = ({ chord, stroke }) => {
    if (guitarSounds[chord]) {
        guitarSounds[chord].play()

    } else {
        console.log(`Failed to find chord ${chord}`)
    }
}

window.playDrum = ({ key }) => {
    drumSounds[key].play()
}

window.addEventListener("keydown", event => {
    console.log("Keys disabled, heh, sry")
    event.preventDefault()
});

let liveSocket = new LiveSocket("/live");

liveSocket.connect();
