// app/javascript/controllers/submit_success_controller.js
// ログイン成功時にキラキラした音を鳴らすjs
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    status: String
  }

  connect() {
    if (this.statusValue === "login_success") {
      const audio = new Audio("/success.mp3") // ← publicに置いた音声ファイル
      audio.play().catch(err => console.error("成功音の再生エラー", err))
    }
  }
}
