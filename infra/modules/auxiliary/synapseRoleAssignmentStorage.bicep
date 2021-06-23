// The module contains a template to create a role assignment of the Synase MSI to a file system.
targetScope = 'resourceGroup'

// Parameters
param storageAccountFileSystemId string
param synapseId string

// Variables
var storageAccountFileSystemName = length(split(storageAccountFileSystemId, '/')) >= 12 ? last(split(storageAccountFileSystemId, '/')) : 'error'
var storageAccountName = length(split(storageAccountFileSystemId, '/')) >= 12 ? split(storageAccountFileSystemId, '/')[8] : 'error'
var synapseSubscriptionId = length(split(synapseId, '/')) >= 8 ? split(synapseId, '/')[2] : 'error'
var synapseResourceGroupName = length(split(synapseId, '/')) >= 8 ? split(synapseId, '/')[4] : 'error'
var synapseName = length(split(synapseId, '/')) >= 8 ? last(split(synapseId, '/')) : 'error'

// Resources
resource storageAccountFileSystem 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-02-01' existing = {
  name: '${storageAccountName}/default/${storageAccountFileSystemName}'
}

resource synapse 'Microsoft.Synapse/workspaces@2021-03-01' existing = {
  name: synapseName
  scope: resourceGroup(synapseSubscriptionId, synapseResourceGroupName)
}

resource synapseRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(uniqueString(storageAccountFileSystem.id, synapse.id))
  scope: storageAccountFileSystem
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalId: synapse.identity.principalId
  }
}

// Outputs
