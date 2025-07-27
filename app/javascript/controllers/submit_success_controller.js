// app/javascript/controllers/submit_success_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    status: String
  }

  connect() {
    if (this.statusValue === "login_success") {
      const audio = new Audio("/assets/success.mp3") // ← publicに置いた音声ファイル
      audio.play().catch(err => console.error("成功音の再生エラー", err))
    }
  }
}