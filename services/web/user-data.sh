#!/bin/bash

cat <<EOF > index.tmpl
<html>
  <style>
    .info {
      font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
      border-collapse: collapse;
      width: auto;
      max-width: 700px;
      height: auto;
      max-height: 150px;
    }

    .info td, .info th {
        background-color: #ffffff;
        border: 1px solid #ddd;
        padding: 8px;
    }

    .info th {
        background-color: #f2f2f2;
        color: black;
    }
  </style>
  <h1 class="info"> {{ .title }} </h1>

  <table class="info">
    <tr>
      <th>Version</th>
      <td><code>${app_version}</code></td>
    </tr>
    <tr>
      <th>Hostname</th>
      <td><code id="hostname"></code></td>
    </tr>
    <tr>
      <th>Request</th>
      <td><code id="request"></code></td>
    </tr>
  </table>
  <script>
    function httpGetAsync(theUrl, callback) {
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function() { 
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
                callback(xmlHttp.responseText);
        }
        xmlHttp.open("GET", theUrl, true); // true for asynchronous 
        xmlHttp.send(null);
    }

    httpGetAsync('/api/v1/info', function(res) {
      var info = JSON.parse(res);
      document.getElementById('hostname').innerText = info.hostname;
      document.getElementById('request').innerText = info.uuid;
    });
  </script>
</html>
EOF

curl -L -O "https://github.com/7wmr/terraform-mockapp-edu/releases/download/${app_version}/mockapp_linux_amd64" \
&& chmod +x ./mockapp_linux_amd64 \
&& nohup ./mockapp_linux_amd64 -port ${app_port} &

