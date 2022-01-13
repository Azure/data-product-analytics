# Data Product Analytics - Setting up Service Principal

A service principal with *Contributor*, *Private DNS Zone Contributor* and *Network Contributor* rights needs to be generated for authentication and authorization from GitHub or Azure DevOps to your Azure subscription. This is required to deploy resources to your environment.

> **Note:** The number of role assignments can be further reduced in a production scenario. The **Private DNS Zone Contributor** is not required if the deployment of DNS A-records of the Private Endpoints is automated through Azure Policies with `deployIfNotExists` effect.

## Create Service Principal

First, go to the Azure Portal to find the ID of your subscription. Then start the Cloud Shell or Azure CLI, login to Azure, set the Azure context and execute the following commands to generate the required credentials:

**Azure CLI:**

```sh
# Replace {service-principal-name} and {subscription-id} with your
# Azure subscription id and any name for your service principal.
az ad sp create-for-rbac \
  --name "{service-principal-name}" \
  --role "Contributor" \
  --scopes "/subscriptions/{subscription-id}" \
  --sdk-auth
```

This will generate the following JSON output:

```json
{
  "clientId": "<GUID>",
  "clientSecret": "<GUID>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>",
  (...)
}
```

> **Note:** Take note of the output. It will be required for the next steps.

## Adding additional role assignments

For automation purposes, more role assignments are required for the service principal.
Additional required role assignments include:

| Role Name | Description | Scope |
|:----------|:------------|:------|
| [Private DNS Zone Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#private-dns-zone-contributor) | We expect you to deploy all Private DNS Zones for all data services into a single subscription and resource group. Therefor, the service principal needs to be Private DNS Zone Contributor on the global dns resource group which was created during the Data Management Landing Zone deployment. This is required to deploy A-records for the respective private endpoints.| <div style="width: 36ch">(Resource Group Scope) `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`</div> |
| [Network Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#network-contributor) | In order to deploy Private Endpoints to the specified privatelink-subnet which was created during the Data Landing Zone deployment, the service principal requires **Network Contributor** access on that specific subnet.| <div style="width: 36ch">(Child-Resource Scope) `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName} /providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}"`</div> |

To add these role assignments, you can use the [Azure Portal](https://portal.azure.com/) or run the following commands using Azure CLI/Azure Powershell:

**Azure CLI - Add role assignments:**

```sh
# Get Service Principal Object ID
az ad sp list --display-name "{servicePrincipalName}" --query "[].{objectId:objectId}" --output tsv

# Add role assignment
# Resource Scope level assignment
az role assignment create \
  --assignee "{servicePrincipalObjectId}" \
  --role "{roleName}" \
  --scopes "{scope}"

# Resource group scope level assignment
az role assignment create \
  --assignee "{servicePrincipalObjectId}" \
  --role "{roleName}" \
  --resource-group "{resourceGroupName}"
```

**Azure Powershell - Add role assignments:**

```powershell
# Get Service Principal Object ID
$spObjectId = (Get-AzADServicePrincipal -DisplayName "{servicePrincipalName}").id

# Add role assignment
# For Resource Scope level assignment
New-AzRoleAssignment `
  -ObjectId $spObjectId `
  -RoleDefinitionName "{roleName}" `
  -Scope "{scope}"

# For Resource group scope level assignment
New-AzRoleAssignment `
  -ObjectId $spObjectId `
  -RoleDefinitionName "{roleName}" `
  -ResourceGroupName "{resourceGroupName}"

# For Child-Resource Scope level assignment
New-AzRoleAssignment `
  -ObjectId $spObjectId `
  -RoleDefinitionName "{roleName}" `
  -ResourceName "{resourceName}" `
  -ResourceType "{resourceType (e.g. 'Microsoft.Network/virtualNetworks/subnets')}" `
  -ParentResource "{parentResource (e.g. 'virtualNetworks/{virtualNetworkName}')" `
  -ResourceGroupName "{resourceGroupName}
```

>[Previous](/docs/DataManagementAnalytics-CreateRepository.md)
>[Next (Option (a) GitHub Actions)](/docs/DataManagementAnalytics-GitHubActionsDeployment.md)
>[Next (Option (b) Azure DevOps)](/docs/DataManagementAnalytics-AzureDevOpsDeployment.md)
