param loganalyticsName string
param datafactoryName string
param processingService string
param synapseName string
param synapseSqlPoolName string
param synapseSparkPoolName string

// Resources
resource datafactoryworkspace 'Microsoft.DataFactory/factories@2018-06-01' existing = if (processingService == 'dataFactory'){
  name: datafactoryName
}

resource synapseworkspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = if (processingService == 'synapse'){
  name: synapseName
}

resource synapsesqlpool 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' existing = if (processingService == 'synapse'){
  parent: synapseworkspace
  name: synapseSqlPoolName
}

resource synapsebigdatapool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' existing = if (processingService == 'synapse'){
  parent: synapseworkspace
  name: synapseSparkPoolName
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: loganalyticsName
}

resource diagnosticSetting1 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (processingService == 'dataFactory'){
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

resource diagnosticSetting2 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (processingService == 'synapse'){
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

resource diagnosticSetting3 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (processingService == 'synapse'){
  scope: synapsesqlpool
  name: 'diagnostic-${synapseworkspace.name}-${synapsesqlpool.name}'
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
}

resource diagnosticSetting4 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (processingService == 'synapse'){
  scope: synapsebigdatapool
  name: 'diagnostic-${synapseworkspace.name}-${synapsebigdatapool.name}'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'BigDataPoolAppsEnded'
        enabled: true
      }
    ]
  }
}

//Outputs
