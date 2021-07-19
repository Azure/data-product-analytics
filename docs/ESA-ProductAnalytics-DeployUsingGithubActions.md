# Deploy reference implementation using GitHub Actions

## 1. Resource deployment

If you want to use GitHub Actions for deploying the resources, add the previous JSON output as a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) with the name `AZURE_CREDENTIALS` in your GitHub repository:

![GitHub Secrets](images/AzureCredentialsGH.png)

To do so, execute the following steps:

1. On GitHub, navigate to the main page of the repository.
2. Under your repository name, click on the **Settings** tab.
3. In the left sidebar, click **Secrets**.
4. Click **New repository secret**.
5. Type the name `AZURE_CREDENTIALS` for your secret in the Name input box.
6. Enter the JSON output from above as value for your secret.
7. Click **Add secret**.

## 2. Parameter Updates

In order to deploy the Infrastructure as Code (IaC) templates to the desired Azure subscription, you will need to modify some parameters in the forked repository. Therefore, **this step should not be skipped**. There are two files that require updates:

- `.github/workflows/dataProductDeployment.yml` and
- `infra/params.dev.json`.

Update these files in a seperate branch and then merge via Pull Request to trigger the initial deployment.

### 2.1. Configure `dataProductDeployment.yml`

To begin, please open the [.github/workflows/dataProductDeployment.yml](/.github/workflows/dataProductDeployment.yml). In this file you need to update the environment variables section. Just click on [.github/workflows/dataProductDeployment.yml](/.github/workflows/dataProductDeployment.yml) and edit the following section:

```yaml
env:
  AZURE_SUBSCRIPTION_ID: "2150d511-458f-43b9-8691-6819ba2e6c7b" # Update to '{dataLandingZoneSubscriptionId}'
  AZURE_RESOURCE_GROUP_NAME: "dlz01-dev-dp001"                  # Update to '{dataLandingZoneName}-rg'
  AZURE_LOCATION: "northeurope"                                 # Update to '{regionName}'
```

The following table explains each of the parameters:

| Parameter                                | Description  | Sample value |
|:-----------------------------------------|:-------------|:-------------|
| **AZURE_SUBSCRIPTION_ID**             | Specifies the subscription ID of the Data Management Zone where all the resources will be deployed | <div style="width: 36ch">`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`</div> |
| **AZURE_LOCATION**                                 | Specifies the region where you want the resources to be deployed. Please check [Supported Regions](#supported-regions)  | `northeurope` |
| **AZURE_RESOURCE_GROUP_NAME** | Specifies the name of an existing resource group in your data landing zone, where the resources will be deployed. | `my-rg-name` |
| **AZURE_RESOURCE_MANAGER _CONNECTION_NAME**   | Specifies the resource manager connection name in Azure DevOps. You can leave the default value if you want to use GitHub Actions for your deployment. More details on how to create the resource manager connection in Azure DevOps can be found in step 4. b) or [here](https://docs.microsoft.com/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-with-an-existing-service-principal). | `my-connection-name` |

### 2.2. Configure `params.dev.json`

To begin, please open the [infra/params.dev.json](/infra/params.dev.json). In this file you need to update the variable values. Just click on [infra/params.dev.json](/infra/params.dev.json) and edit the values. An explanation of the values is given in the table below:

| Parameter                                | Description  | Sample value |
|:-----------------------------------------|:-------------|:-------------|
| location | Specifies the location for all resources. | `northeurope` |
| environment | Specifies the environment of the deployment. | `dev`, `tst` or `prd` |
| prefix | Specifies the prefix for all resources created in this deployment. | `prefi` |
| processingService | Specifies the data engineering service that will be deployed (Data Factory, Synapse). | `dataFactory` or `synapse` |
| aksId | Specifies the object ID of the user who gets assigned to compute instance 001 in the Machine Learning Workspace. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.ContainerService/managedClusters/{aks-name}` |
| machineLearningComputeInstance001AdministratorObjectId | Specifies the object ID of the user who gets assigned to compute instance 001 in the Machine Learning Workspace. | `my-aad--user-object-id` |
| machineLearningComputeInstance001AdministratorPublicSshKey | Specifies the public ssh key for compute instance 001 in the Machine Learning Workspace. Use a secret for this parameter and overwrite as part of the deployment pipelines. | `my-aad--user-object-id` |
| administratorPassword | Specifies the administrator password of the sql servers. Will be automatically set in the workflow. **Leave this value as is.** | `<your-secure-password>` |
| synapseDefaultStorageAccountFileSystemId | Specifies the resource ID of the default storage account file system for synapse. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-name}/blobServices/default/containers/{container-name}` |
| subnetId | Specifies the resource ID of the subnet to which all services will connect. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/virtualNetworks/{vnet-name}/subnets/{subnet-name}` |
| purviewId | Specifies the resource ID of the central purview instance. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Purview/accounts/{purview-name}` |
| databricksWorkspaceId | Specifies the resource ID of the Databricks workspace that will be connected to the Machine Learning Workspace. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Databricks/workspaces/{databricks-name}` |
| databricksWorkspaceUrl | Specifies the workspace URL of the Databricks workspace that will be connected to the Machine Learning Workspace. | `adb-{databricks-workspace-id}.azuredatabricks.net` |
| databricksAccessToken | Specifies the access token of the Databricks workspace that will be connected to the Machine Learning Workspace. Use a secret for this parameter and overwrite as part of the deployment pipelines. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Purview/accounts/{purview-name}` |
| enableRoleAssignments | Specifies whether role assignments should be enabled. **Leave this value as is.** | `true` or `false` |
| privateDnsZoneIdKeyVault | Specifies the resource ID of the private DNS zone for KeyVault. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net` |
| privateDnsZoneIdSynapseDev | Specifies the resource ID of the private DNS zone for Synapse Dev. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.dev.azuresynapse.net` |
| privateDnsZoneIdSynapseSql | Specifies the resource ID of the private DNS zone for Synapse Sql. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.sql.azuresynapse.net` |
| privateDnsZoneIdDataFactory | Specifies the resource ID of the private DNS zone for Data Factory. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.datafactory.azure.net` |
| privateDnsZoneIdDataFactoryPortal | Specifies the resource ID of the private DNS zone for Data Factory Portal. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.adf.azure.com` |
| privateDnsZoneIdCognitiveService | Specifies the resource ID of the private DNS zone for Cognitive Services. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com` |
| privateDnsZoneIdContainerRegistry | Specifies the resource ID of the private DNS zone for Container Registry. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io` |
| privateDnsZoneIdSearch | Specifies the resource ID of the private DNS zone for Azure Search. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net` |
| privateDnsZoneIdBlob | Specifies the resource ID of the private DNS zone for Blob Storage. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net` |
| privateDnsZoneIdFile | Specifies the resource ID of the private DNS zone for File Storage. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net` |
| privateDnsZoneIdMachineLearningApi | Specifies the resource ID of the private DNS zone for Machine Learning API. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms` |
| privateDnsZoneIdMachineLearningNotebooks | Specifies the resource ID of the private DNS zone for Machine Learning Notebooks. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net` |

### 3. Merge these changes back to the `main` branch of your repo

After following the instructions and updating the parameters and variables in your repository in a separate branch and opening the pull request, you can merge the pull request back into the `main` branch of your repository by clicking on **Merge pull request**. Finally, you can click on **Delete branch** to clean up your repository. By doing this, you trigger the deployment workflow.

### 4. Follow the workflow deployment

**Congratulations!** You have successfully executed all steps to deploy the template into your environment through GitHub Actions.

You can navigate to the **Actions** tab of the main page of the repository, where you will see a workflow with the name `Data Product Deployment` running. Click on it to see how it deploys one service after another. If you run into any issues, please open an issue [here](https://github.com/Azure/data-landing-zone/issues).

<p align="right">  Next: <a href="./ESA-ProductAnalytics-CodeStructure.md">Code structure</a> > </p>

< Previous: [Prepare the deployment](./ESA-ProductAnalytics-PrepareDeployment.md)
