// This template is used to create a KeyVault.
targetScope = 'resourceGroup'

// Parameters
param location string
param tags object
param subnetId string
param machineLearningName string
param applicationInsightsId string
param containerRegistryId string
param keyVaultId string
param storageAccountId string
param aksId string
param synapseId string
param synapseBigDataPoolId string
param databricksWorkspaceId string
param databricksWorkspaceUrl string
@secure()
param databricksAccessToken string
param machineLearningComputeInstance001AdministratorObjectId string
@secure()
param machineLearningComputeInstance001AdministratorPublicSshKey string
param privateDnsZoneIdMachineLearningApi string
param privateDnsZoneIdMachineLearningNotebooks string

// Variables
var machineLearningPrivateEndpointName = '${machineLearning.name}-private-endpoint'

// Resources
resource machineLearning 'Microsoft.MachineLearningServices/workspaces@2021-04-01' = {
  name: machineLearningName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    allowPublicAccessWhenBehindVnet: false
    description: machineLearningName
    encryption: {
      status: 'Disabled'
    }
    friendlyName: machineLearningName
    hbiWorkspace: true
    imageBuildCompute: 'cluster001'
    primaryUserAssignedIdentity: ''
    serviceManagedResourcesSettings: {
      cosmosDb: {
        collectionsThroughput: 400
      }
    }
    applicationInsights: applicationInsightsId
    containerRegistry: containerRegistryId
    keyVault: keyVaultId
    storageAccount: storageAccountId
  }
}

resource machineLearningKubernetes001 'Microsoft.MachineLearningServices/workspaces/computes@2021-04-01' = if (!empty(aksId)) {
  parent: machineLearning
  name: 'kubernetes001'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    computeType: 'AKS'
    resourceId: aksId
  }
}

resource machineLearningDatabricks001 'Microsoft.MachineLearningServices/workspaces/computes@2021-04-01' = if (!empty(databricksWorkspaceId) && !empty(databricksWorkspaceUrl) && !empty(databricksAccessToken)) {
  parent: machineLearning
  name: 'databricks001'
  location: location
  tags: tags
  properties: {
    computeType: 'Databricks'
    computeLocation: location
    description: 'Databricks workspace connection'
    disableLocalAuth: true
    properties: {
      databricksAccessToken: databricksAccessToken
      workspaceUrl: databricksWorkspaceUrl
    }
    resourceId: databricksWorkspaceId
  }
}

resource machineLearningSynapse001 'Microsoft.MachineLearningServices/workspaces/linkedServices@2020-09-01-preview' = if (!empty(synapseId)) {
  parent: machineLearning
  name: 'synapse001'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    linkedServiceResourceId: synapseId
    linkType: 'Synapse'
  }
}

resource machineLearningSynapse001BigDataPool001 'Microsoft.MachineLearningServices/workspaces/computes@2021-04-01' = if (!empty(synapseId) && !empty(synapseBigDataPoolId)) {
  parent: machineLearning
  name: 'bigdatapool001'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    machineLearningSynapse001
  ]
  properties: {
    computeType: 'SynapseSpark'
    computeLocation: location
    description: 'Synapse workspace - Spark Pool'
    disableLocalAuth: true
    resourceId: synapseBigDataPoolId
  }
}

resource machineLearningCluster001 'Microsoft.MachineLearningServices/workspaces/computes@2021-04-01' = {
  parent: machineLearning
  name: 'cluster001'
  dependsOn: [
    machineLearningPrivateEndpoint
    machineLearningPrivateEndpointARecord
  ]
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    computeType: 'AmlCompute'
    computeLocation: location
    description: 'Machine Learning cluster 001'
    disableLocalAuth: true
    properties: {
      enableNodePublicIp: false
      isolatedNetwork: false
      osType: 'Linux'
      remoteLoginPortPublicAccess: 'Disabled'
      scaleSettings: {
        minNodeCount: 0
        maxNodeCount: 4
        nodeIdleTimeBeforeScaleDown: 'PT120S'
      }
      subnet: {
        id: subnetId
      }
      vmPriority: 'Dedicated'
      vmSize: 'Standard_DS3_v2'
    }
  }
}

resource machineLearningComputeInstance001 'Microsoft.MachineLearningServices/workspaces/computes@2021-04-01' = if (!empty(machineLearningComputeInstance001AdministratorObjectId)) {
  parent: machineLearning
  name: 'computeinstance001'
  dependsOn: [
    machineLearningPrivateEndpoint
    machineLearningPrivateEndpointARecord
  ]
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    computeType: 'ComputeInstance'
    computeLocation: location
    description: 'Machine Learning compute instance 001'
    disableLocalAuth: true
    properties: {
      applicationSharingPolicy: 'Personal'
      computeInstanceAuthorizationType: 'personal'
      enableNodePublicIp: false
      isolatedNetwork: false
      personalComputeInstanceSettings: {
        assignedUser: {
          objectId: machineLearningComputeInstance001AdministratorObjectId
          tenantId: subscription().tenantId
        }
      }
      setupScripts: {
        scripts: {
          creationScript: {}
          startupScript: {}
        }
      }
      sshSettings: {
        adminPublicKey: machineLearningComputeInstance001AdministratorPublicSshKey
        sshPublicAccess: empty(machineLearningComputeInstance001AdministratorPublicSshKey) ? 'Disabled' : 'Enabled'
      }
      subnet: {
        id: subnetId
      }
      vmSize: 'Standard_DS3_v2'

    }
  }
}

resource machineLearningPrivateEndpoint 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: machineLearningPrivateEndpointName
  location: location
  tags: tags
  properties: {
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: machineLearningPrivateEndpointName
        properties: {
          groupIds: [
            'amlworkspace'
          ]
          privateLinkServiceId: machineLearning.id
          requestMessage: ''
        }
      }
    ]
    subnet: {
      id: subnetId
    }
  }
}

resource machineLearningPrivateEndpointARecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-11-01' = {
  parent: machineLearningPrivateEndpoint
  name: 'aRecord'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${machineLearningPrivateEndpoint.name}-api-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdMachineLearningApi
        }
      }
      {
        name: '${machineLearningPrivateEndpoint.name}-notebooks-arecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdMachineLearningNotebooks
        }
      }
    ]
  }
}

// Outputs
