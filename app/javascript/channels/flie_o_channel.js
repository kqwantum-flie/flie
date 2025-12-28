import consumer from "./consumer"
const pathname = window.location.pathname.split("/")
consumer.subscriptions.create(
  {channel: "FlieOChannel", flie_o_id: pathname[pathname.indexOf("flie_os") + 1]},
  {
    connected() {
      console.log("FlieOChannel: client connected");
    },

    disconnected() {
      console.log("FlieOChannel: client disconnected");
    },

    received(data) {
      console.log("FlieOChannel: client received");
      console.log(data);

      if (data.refresh && data.refresh === true) {
        window.location.replace("/");
      }

      if (data.body) {
        var screen = document.getElementById("output");
        screen.innerHTML = `<div style="white-space: pre-wrap;">${data.body}</div>` + screen.innerHTML;
      }

      var ps1 = document.getElementById("ps1");
      if (data.ps1) {
        ps1.innerHTML = data.ps1;
      }
      var inputEl = document.getElementById("os_log_in");
      if (data.input_type) {
        inputEl.type = data.input_type;
      }
      console.log(inputEl.type);
      ps1.scrollIntoView(true);
    }
  }
);

