// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

// Parameters
param loganalyticsName string
param datafactoryName string

// Resources
resource datafactoryworkspace 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: datafactoryName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: loganalyticsName
}

resource diagnosticSetting1 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
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

//Outputs
