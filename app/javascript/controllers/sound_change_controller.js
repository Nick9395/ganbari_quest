// app/javascript/controllers/sound_change_controller.js
// レベル増減時に鳴らすjs
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    levelup: Boolean,
    leveldown: Boolean
  }

  connect() {
    if (this.levelupValue) {
      this.play("/levelup.mp3")
    }

    if (this.leveldownValue) {
      this.play("/leveldown.mp3")
    }
  }

  play(path) {
    const audio = new Audio(path)
    audio.play().catch(error => {
      console.error("音声再生に失敗しました:", error)
    })
  }
}