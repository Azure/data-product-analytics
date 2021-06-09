targetScope = 'resourceGroup'

// General parameters
@description('Specifies the location for all resources.')
param location string
@allowed([
  'dev'
  'test'
  'prod'
])
@description('Specifies the environment of the deployment.')
param environment string
@minLength(2)
@maxLength(5)
@description('Specifies the prefix for all resources created in this deployment.')
param prefix string

// Resource parameters
@description('Specifies the resource ID of a shared AKS cluster.')
param aksId string
@description('Specifies the object ID of the user who gets assigned to compute instance 001 in the Machine Learning Workspace.')
param machineLearningComputeInstance001AdministratorObjectId string
@secure()
@description('Specifies the public ssh key for compute instance 001 in the Machine Learning Workspace.')
param machineLearningComputeInstance001AdministratorPublicSshKey string
@secure()
@description('Specifies the administrator password of the sql servers.')
param administratorPassword string
@description('Specifies the resource ID of the default storage account file system for synapse.')
param synapseDefaultStorageAccountFileSystemId string
@description('Specifies the resource ID of the central purview instance.')
param purviewId string
@description('Specifies the resource ID of the Databricks workspace that will be connected to the Machine Learning Workspace.')
param databricksWorkspaceId string
@description('Specifies the workspace URL of the Databricks workspace that will be connected to the Machine Learning Workspace.')
param databricksWorkspaceUrl string
@secure()
@description('Specifies the access token of the Databricks workspace that will be connected to the Machine Learning Workspace.')
param databricksAccessToken string
@description('Specifies whether role assignments should be enabled.')
param enableRoleAssignments bool = false

// Network parameters
@description('Specifies the resource ID of the subnet to which all services will connect.')
param subnetId string

// Private DNS Zone parameters
@description('Specifies the resource ID of the private DNS zone for KeyVault.')
param privateDnsZoneIdKeyVault string
@description('Specifies the resource ID of the private DNS zone for Synapse Dev.')
param privateDnsZoneIdSynapseDev string
@description('Specifies the resource ID of the private DNS zone for Synapse Sql.')
param privateDnsZoneIdSynapseSql string
@description('Specifies the resource ID of the private DNS zone for Data Factory.')
param privateDnsZoneIdDataFactory string
@description('Specifies the resource ID of the private DNS zone for Data Factory Portal.')
param privateDnsZoneIdDataFactoryPortal string
@description('Specifies the resource ID of the private DNS zone for Cognitive Services.')
param privateDnsZoneIdCognitiveService string
@description('Specifies the resource ID of the private DNS zone for Container Registry.')
param privateDnsZoneIdContainerRegistry string
@description('Specifies the resource ID of the private DNS zone for Azure Search.')
param privateDnsZoneIdSearch string
@description('Specifies the resource ID of the private DNS zone for Blob Storage.')
param privateDnsZoneIdBlob string
@description('Specifies the resource ID of the private DNS zone for File Storage.')
param privateDnsZoneIdFile string
@description('Specifies the resource ID of the private DNS zone for Machine Learning API.')
param privateDnsZoneIdMachineLearningApi string
@description('Specifies the resource ID of the private DNS zone for Machine Learning Notebooks.')
param privateDnsZoneIdMachineLearningNotebooks string

// Variables
var name = toLower('${prefix}-${environment}')
var tags = {
  Owner: 'Enterprise Scale Analytics'
  Project: 'Enterprise Scale Analytics'
  Environment: environment
  Toolkit: 'bicep'
  Name: name
}
var synapseDefaultStorageAccountSubscriptionId = split(synapseDefaultStorageAccountFileSystemId, '/')[2]
var synapseDefaultStorageAccountResourceGroupName = split(synapseDefaultStorageAccountFileSystemId, '/')[4]

// Resources
module keyvault001 'modules/services/keyvault.bicep' = {
  name: 'keyvault001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    keyvaultName: '${name}-vault001'
    privateDnsZoneIdKeyVault: privateDnsZoneIdKeyVault
  }
}

module synapse001 'modules/services/synapse.bicep' = {
  name: 'synapse001'
  scope: resourceGroup()
  params: {
    location: location
    synapseName: '${name}-synapse001'
    tags: tags
    subnetId: subnetId
    administratorPassword: administratorPassword
    synapseSqlAdminGroupName: ''
    synapseSqlAdminGroupObjectID: ''
    privateDnsZoneIdSynapseDev: privateDnsZoneIdSynapseDev
    privateDnsZoneIdSynapseSql: privateDnsZoneIdSynapseSql
    purviewId: purviewId
    synapseComputeSubnetId: ''
    synapseDefaultStorageAccountFileSystemId: synapseDefaultStorageAccountFileSystemId
  }
}

module synapse001RoleAssignmentStorage 'modules/auxiliary/synapseRoleAssignmentStorage.bicep' = if (enableRoleAssignments) {
  name: 'synapse001RoleAssignmentStorage'
  scope: resourceGroup(synapseDefaultStorageAccountSubscriptionId, synapseDefaultStorageAccountResourceGroupName)
  params: {
    storageAccountFileSystemId: synapseDefaultStorageAccountFileSystemId
    synapseId: synapse001.outputs.synapseId
  }
}

module datafactory001 'modules/services/datafactory.bicep' = {
  name: 'datafactory001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    datafactoryName: '${name}-datafactory001'
    keyVault001Id: keyvault001.outputs.keyvaultId
    privateDnsZoneIdDataFactory: privateDnsZoneIdDataFactory
    privateDnsZoneIdDataFactoryPortal: privateDnsZoneIdDataFactoryPortal
    purviewId: purviewId
  }
}

module cognitiveservice001 'modules/services/cognitiveservices.bicep' = {
  name: 'cognitiveservice001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    cognitiveServiceName: '${name}-cognitiveservice001'
    cognitiveServiceKind: 'FormRecognizer'
    cognitiveServiceSkuName: 'S0'
    privateDnsZoneIdCognitiveService: privateDnsZoneIdCognitiveService
  }
}

module search001 'modules/services/search.bicep' = {
  name: 'search001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    searchName: '${name}-search001'
    searchHostingMode: 'default'
    searchPartitionCount: 1
    searchReplicaCount: 1
    searchSkuName: 'standard'
    privateDnsZoneIdSearch: privateDnsZoneIdSearch
  }
}

module applicationInsights001 'modules/services/applicationinsights.bicep' = {
  name: 'applicationInsights001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    applicationInsightsName: '${name}-insights001'
    logAnalyticsWorkspaceId: ''
  }
}

module containerRegistry001 'modules/services/containerregistry.bicep' = {
  name: 'containerRegistry001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    containerRegistryName: '${name}-containerregistry001'
    privateDnsZoneIdContainerRegistry: privateDnsZoneIdContainerRegistry
  }
}

module storage001 'modules/services/storage.bicep' = {
  name: 'storage001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    storageName: '${name}-storage001'
    storageContainerNames: [
      'default'
    ]
    storageSkuName: 'Standard_LRS'
    privateDnsZoneIdBlob: privateDnsZoneIdBlob
    privateDnsZoneIdFile: privateDnsZoneIdFile
  }
}

module machineLearning001 'modules/services/machinelearning.bicep' = {
  name: 'machineLearning001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    subnetId: subnetId
    machineLearningName: '${name}-machinelearning001'
    applicationInsightsId: applicationInsights001.outputs.applicationInsightsId
    containerRegistryId: containerRegistry001.outputs.containerRegistryId
    keyVaultId: keyvault001.outputs.keyvaultId
    storageAccountId: storage001.outputs.storageId
    aksId: aksId
    databricksAccessToken: databricksAccessToken
    databricksWorkspaceId: databricksWorkspaceId
    databricksWorkspaceUrl: databricksWorkspaceUrl
    synapseId: synapse001.outputs.synapseId
    synapseBigDataPoolId: synapse001.outputs.synapseBigDataPool001Id
    machineLearningComputeInstance001AdministratorObjectId: machineLearningComputeInstance001AdministratorObjectId
    machineLearningComputeInstance001AdministratorPublicSshKey: machineLearningComputeInstance001AdministratorPublicSshKey
    privateDnsZoneIdMachineLearningApi: privateDnsZoneIdMachineLearningApi
    privateDnsZoneIdMachineLearningNotebooks: privateDnsZoneIdMachineLearningNotebooks
  }
}
