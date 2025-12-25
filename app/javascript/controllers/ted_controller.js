import { Controller } from "@hotwired/stimulus"
import { EditorView, basicSetup, minimalSetup} from "codemirror"
import {EditorState, Compartment} from "@codemirror/state"
import {htmlLanguage, html} from "@codemirror/lang-html"
import {language} from "@codemirror/language"
import {javascript} from "@codemirror/lang-javascript"

export default class extends Controller {
  static targets = ["input", "output"];
  connect() {
    this.inputTarget.classList.add("hidden");
    // const languageConf = new Compartment

    // const autoLanguage = EditorState.transactionExtender.of(tr => {
    //   if (!tr.docChanged) return null
    //   let docIsHTML = /^\s*</.test(tr.newDoc.sliceString(0, 100))
    //   let stateIsHTML = tr.startState.facet(language) == htmlLanguage
    //   if (docIsHTML == stateIsHTML) return null
    //   return {
    //     effects: languageConf.reconfigure(docIsHTML ? html() : javascript())
    //   }
    // })
    // new EditorView({
    //   doc: this.inputTarget.innerText,
    //   extensions: [
    //     minimalSetup,
    //     languageConf.of(html()),
    //     // autoLanguage
    //   ],
    //   parent: this.outputTarget
    // })

    let editor = new EditorView({
      extensions: [basicSetup, html()],
      parent: this.outputTarget,
      theme: {
        ".cm-cursor": {
          width: "2px",
          height: "18px",
          backgroundColor: "blue",
          borderLeft: "2px solid black",
          // animation: "caretAnim 1s infinite forwards"
        }
      }
    })

    editor.setState(EditorState.create({
      doc: this.inputTarget.innerHTML
    }));
  }
}
