{{/*
Copyright 2021-2022 Telematics Technologies sp. z o.o.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

{{/*
Extracts the requested property from the configuration specified as a multiline string.
The delimiter between the name and value of the property is expected to be either '=' or ':' character.
If the property is commented out, it is treated as not present.
The result does not include the potential quotes around the value of the property.

Example config (values.yaml):
  rabbitmq:
    additionalConfig: |
      cluster_partition_handling = pause_minority
      log.file.level = "debug"
      disk_free_limit.relative = 1.0

Example usage: {{ include "extract-config-param" (dict `config` $.Values.rabbitmq.additionalConfig `param` "log.file.level") }}
Example result: debug
*/}}
{{- define "extract-config-param" -}}
{{- $param := .param | replace "." `\.` -}}
{{- $pattern := print `(?:^|\n)[ \t]*` $param `[ \t]*[:=][ \t]*"?([^"\n]+)"?` -}}
{{- $paramConfigLine := regexFind $pattern .config | trim -}}
{{- $paramValue := regexReplaceAll $pattern $paramConfigLine "${1}" -}}
{{- $paramValue -}}
{{- end -}}
