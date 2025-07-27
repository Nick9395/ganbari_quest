// トップ画面のメニュークリック時の効果音js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    delay: { type: Number, default: 5000 }
  }

  connect() {
    this.clicked = false
  }

  async playAndRedirect(event) {
    event.preventDefault()

    // ✅ 連打防止
    if (this.clicked) {
      console.log("⛔ すでにクリックされました。")
      return
    }

    this.clicked = true
    this.element.classList.add("disabled") // 見た目を無効化（任意）

    console.log("🎵 音を再生して遷移準備中...")

    const audio = new Audio("/assets/start.mp3")
    audio.play().catch(error => console.error("音声再生エラー:", error))

    await new Promise(resolve => setTimeout(resolve, this.delayValue))

    if (this.urlValue) {
      window.location.href = this.urlValue
    } else {
      console.error("❌ 遷移先URLが設定されていません")
    }
  }
}

