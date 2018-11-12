#!/bin/bash

echo "[all]"

kubectl get nodes -ogo-template='{{- range .items}}
      {{- .metadata.name }}{{ "\t" }}
      {{- range .status.addresses }}
          {{- .type }}={{ .address }}{{ "\t" }}
      {{- end }}{{"\n"}}
{{- end}}' | grep InternalIP | while read l; do
	ip=$(echo "$l" | perl -lne 'print $1 if /InternalIP=([^\s]*)/')
	hostname=$(echo "$l" | perl -lne 'print $1 if /Hostname=([^\s]*)/')
	printf '%s ansible_ssh_host=%s ansible_user=root  ansible_connection=ssh ansible_ssh_extra_args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"\n' "$hostname" "$ip"
done
