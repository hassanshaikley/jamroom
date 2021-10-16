import css from "../css/app.css"

import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

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

let Hooks = {};

Hooks.PlayGuitar = {
  mounted() {
    const chord = this.el.dataset.chord;
    window.playGuitar && window.playGuitar({ chord: chord, stroke: 'down' });
  }
}

Hooks.PlayDrums = {
  mounted() {
    const key = this.el.dataset.key;
    window.playDrum && window.playDrum({ key: key });
  }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {}})

liveSocket.connect();
