// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

// Parameters
param adfPipelineFailedAlertName string
param synapsePipelineFailedAlertName string
param datafactoryScope string
param alertsActionGroupID string
param location string
param tags object
param processingService string

// Resources
resource adfPipelineFailedAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = if (processingService == 'dataFactory'){
  name: adfPipelineFailedAlertName
  location: 'global'
  tags: tags
  properties: {
    actions: [
      {
        actionGroupId: alertsActionGroupID        
      }
    ]
    autoMitigate: false
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
            threshold : 1
            name : 'Metric1'
            metricNamespace: 'Microsoft.DataFactory/factories'
            metricName: 'PipelineFailedRuns'
            operator: 'GreaterThan'
            timeAggregation: 'Total'
            criterionType: 'StaticThresholdCriterion'
        }
       ]      
    }
    description: 'ADF pipeline failed'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      datafactoryScope
    ]
    severity: 1
    targetResourceRegion: location
    targetResourceType: 'Microsoft.DataFactory/factories'
    windowSize: 'PT5M'
  }
}

resource synapsePipelineFailedAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = if (processingService == 'synapse'){
  name: synapsePipelineFailedAlertName
  location: 'global'
  tags: tags
  properties: {
    actions: [
      {
        actionGroupId: alertsActionGroupID        
      }
    ]
    autoMitigate: false
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
            threshold : 1
            name : 'Metric1'
            metricNamespace: 'Microsoft.Synapse/Workspaces'
            metricName: 'IntegrationPipelineFailedRuns'
            operator: 'GreaterThan'
            timeAggregation: 'Total'
            criterionType: 'StaticThresholdCriterion'
        }
       ]      
    }
    description: 'Synapse integration pipeline failed'
    enabled: true
    evaluationFrequency: 'PT1M'
    scopes: [
      datafactoryScope
    ]
    severity: 1
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Synapse/Workspaces'
    windowSize: 'PT5M'
  }
}
// Outputs
