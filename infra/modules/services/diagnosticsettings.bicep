// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

// This template is used to setup diagnostic settings.
targetScope = 'resourceGroup'

// Parameters
param logAnalytics001Name string
param datafactoryName string
param processingService string
param synapseName string
param synapseSqlPools array
param synapseSparkPools array

//variables
var synapseSqlPoolsCount = length(synapseSqlPools)
var synapseSparkPoolCount = length(synapseSparkPools)

//Resources
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalytics001Name
}

resource datafactoryworkspace 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: datafactoryName
}

resource synapseworkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: synapseName
}

resource synapsesqlpool 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' existing = [for sqlPool in synapseSqlPools: {
  parent: synapseworkspace
  name: sqlPool
}]

resource synapsebigdatapool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' existing = [for sparkPool in synapseSparkPools: {
  parent: synapseworkspace
  name: sparkPool
}]

resource diagnosticSetting001 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (processingService == 'dataFactory') {
  scope: datafactoryworkspace
  name: 'diagnostic-${datafactoryworkspace.name}'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'PipelineRuns'
        enabled: true
      }
      {
        category: 'TriggerRuns'
        enabled: true
      }
      {
        category: 'ActivityRuns'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

resource diagnosticSetting002 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (processingService == 'synapse') {
  scope: synapseworkspace
  name: 'diagnostic-${synapseworkspace.name}'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'SynapseRbacOperations'
        enabled: true
      }
      {
        category: 'GatewayApiRequests'
        enabled: true
      }
      {
        category: 'BuiltinSqlReqsEnded'
        enabled: true
      }
      {
        category: 'IntegrationPipelineRuns'
        enabled: true
      }
      {
        category: 'IntegrationActivityRuns'
        enabled: true
      }
      {
        category: 'IntegrationTriggerRuns'
        enabled: true
      }
    ]
  }
}

resource diagnosticSetting003 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for i in range(0, synapseSqlPoolsCount): if (processingService == 'synapse') {
  scope: synapsesqlpool[i]
  name: 'diagnostic-${synapseworkspace.name}-${synapsesqlpool[i].name}'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'SqlRequests'
        enabled: true
      }
      {
        category: 'RequestSteps'
        enabled: true
      }
      {
        category: 'ExecRequests'
        enabled: true
      }
      {
        category: 'DmsWorkers'
        enabled: true
      }
      {
        category: 'Waits'
        enabled: true
      }
    ]
  }
}]

resource diagnosticSetting004 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for i in range(0, synapseSparkPoolCount): if (processingService == 'synapse') {
  scope: synapsebigdatapool[i]
  name: 'diagnostic-${synapseworkspace.name}-${synapsebigdatapool[i].name}'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'BigDataPoolAppsEnded'
        enabled: true
      }
    ]
  }
}]

//Outputs
