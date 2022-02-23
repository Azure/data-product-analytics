# Data Product Analytics - GitHub Action Deployment

In the previous step we have generated a JSON output similar to the following, which will be required in the next steps:

```json
{
  "clientId": "<GUID>",
  "clientSecret": "<GUID>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>",
  (...)
}
```

## Adding Secrets to GitHub repository

If you want to use GitHub Actions for deploying the resources, add the JSON output as a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) with the name `AZURE_CREDENTIALS` in your GitHub repository:

![GitHub Secrets](/docs/images/AzureCredentialsGH.png)

To do so, execute the following steps:

1. On GitHub, navigate to the main page of the repository.
2. Under your repository name, click on the **Settings** tab.
3. In the left sidebar, click **Secrets**.
4. Click **New repository secret**.
5. Type the name `AZURE_CREDENTIALS` for your secret in the Name input box.
6. Enter the JSON output from above as value for your secret.
7. Click **Add secret**.

## Update Parameters

In order to deploy the Infrastructure as Code (IaC) templates to the desired Azure subscription, you will need to modify some parameters in the forked repository. Therefore, **this step should not be skipped for neither Azure DevOps/GitHub options**. There are two files that require updates:

- `.github/workflows/dataProductDeployment.yml` and
- `infra/params.dev.json`.

Update these files in a seperate branch and then merge via Pull Request to trigger the initial deployment.

### Configure `dataProductDeployment.yml`

To begin, please open [.github/workflows/dataProductDeployment.yml](/.github/workflows/dataProductDeployment.yml). In this file you need to update the environment variables section. Just click on [.github/workflows/dataProductDeployment.yml](/.github/workflows/dataProductDeployment.yml) and edit the following section:

```yaml
env:
  AZURE_SUBSCRIPTION_ID: "2150d511-458f-43b9-8691-6819ba2e6c7b" # Update to '{dataLandingZoneSubscriptionId}'
  AZURE_RESOURCE_GROUP_NAME: "dlz01-dev-dp001"                  # Update to '{dataLandingZoneName}-rg'
  AZURE_LOCATION: "northeurope"                                 # Update to '{regionName}'
```

The following table explains each of the parameters:

| Parameter                     | Description  | Sample value |
|:------------------------------|:-------------|:-------------|
| **AZURE_SUBSCRIPTION_ID**     | Specifies the subscription ID of the Data Management Landing Zone where all the resources will be deployed | <div style="width: 36ch">`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`</div> |
| **AZURE_LOCATION**            | Specifies the region where you want the resources to be deployed. Please check [Supported Regions](/docs/DataManagementAnalytics-Prerequisites.md#supported-regions) | `northeurope` |
| **AZURE_RESOURCE_GROUP_NAME** | Specifies the name of an existing resource group in your data landing zone, where the resources will be deployed. | `my-rg-name` |

### Configure `params.dev.json`

To begin, please open the [infra/params.dev.json](/infra/params.dev.json). In this file you need to update the variable values. Just click on [infra/params.dev.json](/infra/params.dev.json) and edit the values. An explanation of the values is given in the table below:

| Parameter                                | Description  | Sample value |
|:-----------------------------------------|:-------------|:-------------|
| `location` | Specifies the location for all resources. | `northeurope` |
| `environment` | Specifies the environment of the deployment. | `dev`, `tst` or `prd` |
| `prefix` | Specifies the prefix for all resources created in this deployment. | `prefi` |
| `tags` | Specifies the tags that you want to apply to all resources. | {`key`: `value`} |
| `processingService` | Specifies the data engineering service that will be deployed (Data Factory, Synapse). | `dataFactory` or `synapse` |
| `datalakeFileSystemIds` | Specifies the list of Resource IDs of Data Lake Gen2 Containers which will be connected as datastores in the Machine Learning workspace. If you do not want to connect any datastores, provide an empty list. | [`/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-name}/blobServices/default/containers/{container-name}`] |
| `aksId` | Specifies the object ID of the user who gets assigned to compute instance 001 in the Machine Learning Workspace. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.ContainerService/managedClusters/{aks-name}` |
| `externalContainerRegistryId` | Specifies the Resource ID of a Conatiner Registry to which the Machine Learning MSI can be assigned. If you do not want to connect an external Container Registry, leave this value empty as is. Also set `enableRoleAssignments` to `true` to enable this. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.ContainerRegistry/registries/{containerRegistry-name}` |
| `machineLearningComputeInstance001AdministratorObjectId` | Specifies the object ID of the user who gets assigned to compute instance 001 in the Machine Learning Workspace. | `my-aad--user-object-id` |
| `machineLearningComputeInstance001AdministratorPublicSshKey` | Specifies the public ssh key for compute instance 001 in the Machine Learning Workspace. Use a secret for this parameter and overwrite as part of the deployment pipelines. | `my-aad--user-object-id` |
| `administratorPassword` | Specifies the administrator password of the sql servers. Will be automatically set in the workflow. **Leave this value as is.** | `<your-secure-password>` |
| `synapseDefaultStorageAccountFileSystemId` | Specifies the Resource ID of the default storage account file system for synapse. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-name}/blobServices/default/containers/{container-name}` |
| `purviewId` | Specifies the resource ID of the central Purview instance. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Purview/accounts/{purview-name}` |
| `purviewManagedStorageId` | Specifies the Resource ID of the managed storage of the central purview instance. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}` |
| `purviewManagedEventHubId` | Specifies the Resource ID of the managed event hub of the central purview instance. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.EventHub/namespaces/{eventhub-namespace-name}` |
| `databricksWorkspaceId` | Specifies the Resource ID of the Databricks workspace that will be connected to the Machine Learning Workspace. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Databricks/workspaces/{databricks-name}` |
| `databricksWorkspaceUrl` | Specifies the Workspace URL of the Databricks workspace that will be connected to the Machine Learning Workspace. | `adb-{databricks-workspace-id}.azuredatabricks.net` |
| `databricksAccessToken` | Specifies the access token of the Databricks workspace that will be connected to the Machine Learning Workspace. Use a secret for this parameter and overwrite as part of the deployment pipelines. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Purview/accounts/{purview-name}` |
| `enableRoleAssignments` | Specifies whether role assignments should be enabled. | `true` or `false` |
| `cognitiveServiceKinds` | Specifies the cognitive service kind that will be deployed. | [`FormRecognizer`, `LUIS`] |
| `enableSearch` | Specifies whether Azure Search should be deployed as part of the template. | `true` or `false` |
| `enableMonitoring` | Specifies whether key monitoring components like Azure Dashboard, metrics and alerts are enabled. | `true` or `false` |
| `dataProductTeamEmail` | Email ID of the group to receive monitoring alerts. | `email@domian.com` |
| `subnetId` | Specifies the Resource ID of the subnet to which all services will connect. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/virtualNetworks/{vnet-name}/subnets/{subnet-name}` |
| `privateDnsZoneIdKeyVault` | Specifies the Resource ID of the private DNS zone for KeyVault. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net` |
| `privateDnsZoneIdSynapseDev` | Specifies the Resource ID of the private DNS zone for Synapse Dev. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.dev.azuresynapse.net` |
| `privateDnsZoneIdSynapseSql` | Specifies the Resource ID of the private DNS zone for Synapse Sql. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.sql.azuresynapse.net` |
| `privateDnsZoneIdDataFactory` | Specifies the Resource ID of the private DNS zone for Data Factory. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.datafactory.azure.net` |
| `privateDnsZoneIdDataFactoryPortal` | Specifies the Resource ID of the private DNS zone for Data Factory Portal. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.adf.azure.com` |
| `privateDnsZoneIdCognitiveService` | Specifies the Resource ID of the private DNS zone for Cognitive Services. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com` |
| `privateDnsZoneIdContainerRegistry` | Specifies the Resource ID of the private DNS zone for Container Registry. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io` |
| `privateDnsZoneIdSearch` | Specifies the Resource ID of the private DNS zone for Azure Search. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net` |
| `privateDnsZoneIdBlob` | Specifies the Resource ID of the private DNS zone for Blob Storage. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net` |
| `privateDnsZoneIdFile` | Specifies the Resource ID of the private DNS zone for File Storage. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net` |
| `privateDnsZoneIdMachineLearningApi` | Specifies the Resource ID of the private DNS zone for Machine Learning API. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms` |
| `privateDnsZoneIdMachineLearningNotebooks` | Specifies the Resource ID of the private DNS zone for Machine Learning Notebooks. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net` |

## Merge these changes back to the `main` branch of your repository

After following the instructions and updating the parameters and variables in your repository in a separate branch and opening the pull request, you can merge the pull request back into the `main` branch of your repository by clicking on **Merge pull request**. Finally, you can click on **Delete branch** to clean up your repository. By doing this, you trigger the deployment workflow.

## Follow the workflow deployment

**Congratulations!** You have successfully executed all steps to deploy the template into your environment through GitHub Actions.

Now, you can navigate to the **Actions** tab of the main page of the repository, where you will see a workflow with the name `Data Product Deployment` running. Click on it to see how it deploys the environment. If you run into any issues, please check the [Known Issues](/docs/DataManagementAnalytics-KnownIssues.md) first and open an [issue](https://github.com/Azure/data-product-analytics/issues) if you come across a potential bug in the repository.

>[Previous](/docs/DataManagementAnalytics-ServicePrincipal.md)
>[Next](/docs/DataManagementAnalytics-KnownIssues.md)
