import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"];

  connect() {
    this.formTarget.addEventListener("submit", (e) => {
      const form = e.target;
      const inputEl = document.getElementById("os_log_in");
      inputEl.classList.add("hidden");

      // POST data using the fetch API.
      fetch(form.action, {
        method: form.method,
        body: new FormData(form)
      }).then(response => {
        inputEl.value = null;
        inputEl.classList.remove("hidden");
        inputEl.focus();
      }).catch(error => {
         console.error('tty_controller.js form post error: ', error);
         inputEl.classList.remove("hidden");
         inputEl.focus();
      })

      // prevent the default form submit
      e.preventDefault();
    });
  }
}
