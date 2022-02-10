// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

// Parameters
param dataFactoryEmailActionGroup string
param dataProductTeamEmail string
param tags object

// Resources
resource actiongroup 'Microsoft.Insights/actionGroups@2021-09-01' = {
  name: dataFactoryEmailActionGroup
  location: 'global'
  tags: tags
  properties: {
    groupShortName: 'emailgroup'
    emailReceivers: [
      {
        emailAddress: dataProductTeamEmail
        name: 'emailaction'
        useCommonAlertSchema: true
      }
    ]
    enabled: true
  }
}

// Outputs
output actiongroup_id string = actiongroup.id
