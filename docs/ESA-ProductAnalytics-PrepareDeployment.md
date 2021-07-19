# Prepare the deployment

## 1. Create repository from a template

1. On GitHub, navigate to the main page of this repository.
1. Above the file list, click **Use this template**

  ![GitHub Template repository](images/UseThisTemplateGH.png)

1. Use the **Owner** drop-down menu and select the account you want to own the repository.

  ![Create Repository from Template](images/CreateRepoGH.png)

1. Type a name for your repository and an optional description.
1. Choose a repository visibility. For more information, see "[About repository visibility](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-repository-visibility)."
1. Optionally, to include the directory structure and files from all branches in the template and not just the default branch, select **Include all branches**.
1. Click **Create repository from template**.

## 2. Setting up the required Service Principal and access

A service principal with *Contributor* role needs to be generated for authentication and authorization from GitHub or Azure DevOps to your Azure **Data Landing Zone** subscription, where the data-product-analytics services will be deployed. Just go to the Azure Portal to find the ID of your subscription. Then start the Cloud Shell or Azure CLI, login to Azure, set the Azure context and execute the following commands to generate the required credentials:

> **Note:** The purpose of this new **Service Principal** is to assign least-privilege rights. Therefore, it requires the **Contributor** role at a resource group scope in order to deploy the resources inside the resource group dedicated to a specific data product. The **Network Contributor** role assignment is required as well in this repository in order to add the private endpoint of resources to the dedicated subnet.

### 2.1. Create service principal - Azure CLI

```sh
# Replace {service-principal-name} and {subscription-id} and {resource-group} with your
# Azure subscription id and any name for your service principal.
az ad sp create-for-rbac \
  --name {service-principal-name} \
  --role contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
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

### 2.2. Add role assignments

Now that the new Service Principal is created, as mentioned,  role assignments are required for this service principal in order to be able to successfully deploy all services. Required role assignments which will be added on a later step include:

| Role Name | Description | Scope |
|:----------|:------------|:------|
| [Private DNS Zone Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#private-dns-zone-contributor) | We expect you to deploy all Private DNS Zones for all data services into a single subscription and resource group. Therefor, the service principal needs to be Private DNS Zone Contributor on the global dns resource group which was created during the Data Management Zone deployment. This is required to deploy A-records for the respective private endpoints.| <div style="width: 36ch">(Resource Group Scope) `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`</div> |
| [Network Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#network-contributor) | In order to deploy Private Endpoints to the specified privatelink-subnet which was created during the Data Landing Zone deployment, the service principal requires **Network Contributor** access on that specific subnet.| <div style="width: 36ch">(Child-Resource Scope) `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName} /providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}"`</div> |

To add these role assignments, you can use the [Azure Portal](https://portal.azure.com/) or run the following commands using Azure CLI/Azure Powershell:

#### Azure CLI

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

#### Azure Powershell

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
  -ResourceName "{subnetName}" `
  -ResourceType "Microsoft.Network/virtualNetworks/subnets" `
  -ParentResource "virtualNetworks/{virtualNetworkName}" `
  -ResourceGroupName "{resourceGroupName}
```

### 3. Resource Deployment

Now that you have set up the Service Principal, you need to choose how would you like to deploy the resources.
Deployment options:

1. [GitHub Actions](#github-actions)
1. [Azure DevOps](#azure-devops)

<p align="right">  Next: <a href="./ESA-ProductAnalytics-DeployUsingAzureDevops.md">Deploy Reference implementation using Azure DevOps</a> > </p>
<p align="right"> <a href="./ESA-ProductAnalytics-DeployUsingGithubActions.md">Deploy Reference implementation using GitHub Actions</a> > </p>

< Previous: [Prerequisites](./ESA-ProductAnalytics-Prerequisites.md)
