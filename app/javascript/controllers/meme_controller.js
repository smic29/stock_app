import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="meme"
export default class extends Controller {
  static targets = ["memeSelect", "memeImage", "memeLoader"]

  updateMemeImage(event) {
    const templateId = event.target.value;
    const baseUrl = "https://api.memegen.link/images/";

    this.memeLoaderTarget.classList.remove('d-none')
    this.memeImageTarget.src = ''

    if (templateId) {
      this.memeImageTarget.src = `${baseUrl}${templateId}`;
      this.memeImageTarget.addEventListener("load", () => {
        this.memeLoaderTarget.classList.add('d-none')
      })
    } else {
      this.memeImageTarget.src = "";
    }
  }
}
