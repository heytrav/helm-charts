{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-keystone-auth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k8s-keystone-auth.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "k8s-keystone-auth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "k8s-keystone-auth.labels" -}}
helm.sh/chart: {{ include "k8s-keystone-auth.chart" . }}
{{ include "k8s-keystone-auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k8s-keystone-auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-keystone-auth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "k8s-keystone-auth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "k8s-keystone-auth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "k8s-keystone-auth.authUrl" -}}
{{- if .Values.openstackAuthUrl }}
{{- .Values.openstackAuthUrl -}}
{{- else }}
{{- fail "openstackAuthUrl must be defined"}}
{{- end }}
{{- end }}

{{- define "k8s-keystone-auth.projectId" -}}
{{- if .Values.projectId }}
{{- .Values.projectId -}}
{{- else }}
{{- fail "projectId must be defined" }}
{{- end }}
{{- end }}


{{- define "k8s-keystone-auth.rbacPolicies.checksum" -}}
checksum/config: {{  tpl .Values.rbacPolicies . | sha256sum }}
{{- end }}
