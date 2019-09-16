#!/bin/bash

cat <<EOF > index.tmpl
<html>
  <h1> {{ .title }}</h1>

  <table>
    <tr>
      <th>Version</th>
      <td>${app_version}</td>
    </tr>
  </table>

</html>
EOF

curl -L -O "https://github.com/7wmr/terraform-mockapp-edu/releases/download/${app_version}/mockapp_linux_amd64" \
&& chmod +x ./mockapp_linux_amd64 \
&& nohup ./mockapp_linux_amd64 -port ${app_port} &

