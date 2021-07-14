// The module contains a template to create a role assignment of the Synase MSI to a file system.
targetScope = 'resourceGroup'

// Parameters
param containerRegistryId string
param machineLearningId string

// Variables
var containerRegistryName = length(split(containerRegistryId, '/')) >= 8 ? last(split(containerRegistryId, '/')) : 'incorrectSegmentLength'
var machineLearningSubscriptionId = length(split(machineLearningId, '/')) >= 8 ? split(machineLearningId, '/')[2] : subscription().subscriptionId
var machineLearningResourceGroupName = length(split(machineLearningId, '/')) >= 8 ? split(machineLearningId, '/')[4] : resourceGroup().name
var machineLearningName = length(split(machineLearningId, '/')) >= 8 ? last(split(machineLearningId, '/')) : 'incorrectSegmentLength'

// Resources
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' existing = {
  name: containerRegistryName
}

resource machineLearning 'Microsoft.MachineLearningServices/workspaces@2021-04-01' existing = {
  name: machineLearningName
  scope: resourceGroup(machineLearningSubscriptionId, machineLearningResourceGroupName)
}

resource synapseRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(uniqueString(containerRegistry.id, machineLearning.id))
  scope: containerRegistry
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: machineLearning.identity.principalId
  }
}

// Outputs
