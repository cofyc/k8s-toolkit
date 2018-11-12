#!/bin/bash

kubectl get nodes -ogo-template='{{- range .items}}
   {{- $name := .metadata.name }}
   {{- range $key, $value := .metadata.labels }}
       {{- $name }}{{ "\t" }}{{- $key }}: {{ $value }}{{- "\n" }}
   {{- end }}
{{- end}}'
