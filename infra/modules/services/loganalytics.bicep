// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.


// Parameters
param location string
param loganalyticsName string
param tags object
param processingService string

// Variables
var dataFactoryAnalyticsName = 'AzureDataFactoryAnalytics(${loganalyticsName})'

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

resource dataFactoryAnalytics 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = if (processingService == 'dataFactory') {
  name: dataFactoryAnalyticsName
  location: location
  tags: tags
  plan: {
    name: dataFactoryAnalyticsName
    product: 'OMSGallery/AzureDataFactoryAnalytics'
    promotionCode: ''
    publisher: 'Microsoft'
  }
  properties: {
    workspaceResourceId: logAnalytics.id
  }
}

// Outputs
output logAnalyticsWorkspaceId  string = logAnalytics.id
