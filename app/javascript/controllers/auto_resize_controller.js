import { Controller } from "@hotwired/stimulus";
// 目標やふりかえり画面の入力フォームの大きさ（高さ）を、文字数に応じて自動変動させるjs

export default class extends Controller {
  static targets = ["textarea"];

  connect() {
    this.textareaTargets.forEach((textarea) => this.resize(textarea));
  }

  resize(textarea) {
    textarea.style.height = "auto";
    textarea.style.height = textarea.scrollHeight + "px";
  }

  autoResize(event) {
    this.resize(event.target);
  }
}