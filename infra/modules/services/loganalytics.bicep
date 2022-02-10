// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.


// Parameters
param location string
param loganalyticsName string
param tags object

// Resources
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: loganalyticsName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 120
    features: {
      searchVersion: 1
      legacy: 0
    }
  }
}

// Outputs
output logAnalyticsWorkspaceId  string = logAnalytics.id
