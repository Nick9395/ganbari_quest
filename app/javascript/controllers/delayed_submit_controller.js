// アカウント作成とログインのsubmit時の効果音js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 3000 } // デフォルトは3秒
  }

  connect() {
    this.clicked = false
  }

  async handle(event) {
    if (this.clicked) {
      event.preventDefault()
      return
    }

    event.preventDefault()
    this.clicked = true

    // 視覚的に無効にしたい場合
    this.element.disabled = true
    this.element.classList.add("disabled")

    console.log("🎵 効果音再生中...")

    const audio = new Audio("/assets/start.mp3")
    audio.play().catch(err => console.error("音声再生エラー", err))

    await new Promise(resolve => setTimeout(resolve, this.delayValue))

    // フォーム送信
    this.element.closest("form").submit()
  }
}
