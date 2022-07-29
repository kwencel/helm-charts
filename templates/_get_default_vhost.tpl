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
Extracts the default vhost from the value of RabbitMQ's configuration property 'default_vhost'.
If the property is not present, the default '/' vhost is returned, as per RabbitMQ's defaults.
If the property is commented out, it is treated as not present.
The result does not include the potential quotes around the value of the property.

Example usage: {{ include "get-default-vhost" . }}
Example result: /
*/}}
{{- define "get-default-vhost" -}}
{{- $mergedConfig := print ($.Values.rabbitmq.additionalConfig | default "") $.Values.rabbitmq.config }}
{{- include "extract-config-param" (dict `config` (tpl $mergedConfig $) `param` "default_vhost") | default "/" -}}
{{- end -}}
