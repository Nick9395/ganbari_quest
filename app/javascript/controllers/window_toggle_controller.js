// app/javascript/controllers/window_toggle_controller.js
// スマホ用バトル画面のコマンドとメッセージのウインドウ切り替えjs
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["command", "message"]

  connect() {
    this.toggleWindow()
  }

  toggleWindow() {
    // スマホ画面でのみ切り替え
    if (window.innerWidth <= 768) {
      const flashExists = this.messageTarget.innerText.trim().length > 0
      if (flashExists) {
        this.commandTarget.style.display = "none"
        this.messageTarget.style.display = "block"
      } else {
        this.commandTarget.style.display = "block"
        this.messageTarget.style.display = "none"
      }
    } else {
      // PCでは常に両方表示
      this.commandTarget.style.display = "block"
      this.messageTarget.style.display = "block"
    }
  }

  showCommand() {
    if (window.innerWidth <= 768) {
      this.commandTarget.style.display = "block"
      this.messageTarget.style.display = "none"
    }
  }
}