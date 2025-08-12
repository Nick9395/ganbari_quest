// app/javascript/controllers/flash_controller.js
// バトルのフラッシュメッセージ(:rpg, :rpg2, :rpg3)を自動で消すjs
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 5000 } //デフォルト5秒で消える。viewで調整可能
  }

  static targets = ["message", "default"]

  connect() {
    setTimeout(() => {
      if (this.hasMessageTarget) {
        this.messageTarget.remove() // flashメッセージを削除
      }
      if (this.hasDefaultTarget) {
        this.defaultTarget.style.display = "block" // default-message を表示
      }

      // スマホ画面バトルウインドウ切り替えイベント発火
      window.dispatchEvent(new Event("flash:hide"))
    }, this.timeoutValue)
  }
}
