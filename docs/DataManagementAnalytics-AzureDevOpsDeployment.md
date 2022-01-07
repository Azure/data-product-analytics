# Data Product Analytics - Azure DevOps Deployment

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

## Create Service Connection

First, you need to create an Azure Resource Manager service connection. To do so, execute the following steps:

1. First, you need to create an Azure DevOps Project. Instructions can be found [here](https://docs.microsoft.com/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page).
1. In Azure DevOps, open the **Project settings**.
1. Now, select the **Service connections** page from the project settings page.
1. Choose **New service connection** and select **Azure Resource Manager**.

   ![ARM Connection](/docs/images/ARMConnectionDevOps.png)

1. On the next page select **Service principal (manual)**.
1. Select the appropriate environment to which you would like to deploy the templates. Only the default option **Azure Cloud** is currently supported.
1. For the **Scope Level**, select **Subscription** and enter your `subscription Id` and `name`.
1. Enter the details of the service principal that we have generated in step 3. (**Service Principal ID** = **clientId**, **Service Principal Key** = **clientSecret**, **Tenant ID** = **tenantId**) and click on **Verify** to make sure that the connection works.
1. Enter a user-friendly **Connection name** to use when referring to this service connection. Take note of the name because this will be required in the parameter update process.
1. Optionally, enter a **Description**.
1. Click on **Verify and save**.

    ![Connection DevOps](/docs/images/ConnectionDevOps.png)

More information can be found [here](https://docs.microsoft.com/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-with-an-existing-service-principal).

## Update Parameters

In order to deploy the Infrastructure as Code (IaC) templates to the desired Azure subscription, you will need to modify some parameters in the forked repository. Therefore, **this step should not be skipped for neither Azure DevOps/GitHub options**. There are two files that require updates:

- `.ado/workflows/dataProductDeployment.yml` and
- `infra/params.dev.json`.

Update these files in a separate branch and then merge via Pull Request to trigger the initial deployment.

### Configure `dataProductDeployment.yml`

To begin, please open the [.ado/workflows/dataProductDeployment.yml](/.ado/workflows/dataProductDeployment.yml). In this file you need to update the variables section. Just click on [.ado/workflows/dataProductDeployment.yml](/.ado/workflows/dataProductDeployment.yml) and edit the following section:

```yaml
variables:
  AZURE_RESOURCE_MANAGER_CONNECTION_NAME: "integration-product-service-connection" # Update to '{resourceManagerConnectionName}'
  AZURE_SUBSCRIPTION_ID: "2150d511-458f-43b9-8691-6819ba2e6c7b"                    # Update to '{dataLandingZoneSubscriptionId}'
  AZURE_RESOURCE_GROUP_NAME: "dlz01-dev-dp001"                                     # Update to '{dataLandingZoneName}-rg'
  AZURE_LOCATION: "North Europe"                                                   # Update to '{regionName}'
```

The following table explains each of the parameters:

| Parameter                                   | Description | Sample value |
|:--------------------------------------------|:------------|:-------------|
| **AZURE_SUBSCRIPTION_ID**                   | Specifies the subscription ID of the Data Management Landing Zone where all the resources will be deployed | <div style="width: 36ch">`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`</div> |
| **AZURE_LOCATION**                          | Specifies the region where you want the resources to be deployed. Please check [Supported Regions](/docs/DataManagementAnalytics-Prerequisites.md#supported-regions)  | `northeurope` |
| **AZURE_RESOURCE_GROUP_NAME** | Specifies the name of an existing resource group in your data landing zone, where the resources will be deployed. | `my-rg-name` |
| **AZURE_RESOURCE_MANAGER _CONNECTION_NAME** | Specifies the resource manager connection name in Azure DevOps. You can leave the default value if you want to use GitHub Actions for your deployment. More details on how to create the resource manager connection in Azure DevOps can be found further above or [here](https://docs.microsoft.com/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-with-an-existing-service-principal). | `my-connection-name` |

### Configure `params.dev.json`

To begin, please open the [infra/params.dev.json](/infra/params.dev.json). In this file you need to update the variable values. Just click on [infra/params.dev.json](/infra/params.dev.json) and edit the values. An explanation of the values is given in the table below:

| Parameter                                | Description  | Sample value |
|:-----------------------------------------|:-------------|:-------------|
| `location` | Specifies the location for all resources. | `northeurope` |
| `environment` | Specifies the environment of the deployment. | `dev`, `tst` or `prd` |
| `prefix` | Specifies the prefix for all resources created in this deployment. | `prefi` |
| `tags` | Specifies the tags that you want to apply to all resources. | {`key`: `value`} |
| `processingService` | Specifies the data engineering service that will be deployed (Data Factory, Synapse). | `dataFactory` or `synapse` |
| `datalakeFileSystemIds` | Specifies the list of Resource IDs of Data Lake Gen2 containers which will be connected as datastores in the Machine Learning workspace. If you do not want to connect any datastores, provide an empty list. | [`/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-name}/blobServices/default/containers/{container-name}`] |
| `aksId` | Specifies the object ID of the user who gets assigned to compute instance 001 in the Machine Learning Workspace. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.ContainerService/managedClusters/{aks-name}` |
| `externalContainerRegistryId` | Specifies the resource ID of a Conatiner Registry to which the Machine Learning MSI can be assigned. If you do not want to connect an external Container Registry, leave this value empty as is. Also set `enableRoleAssignments` to `true` to enable this. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.ContainerRegistry/registries/{containerRegistry-name}` |
| `machineLearningComputeInstance001AdministratorObjectId` | Specifies the object ID of the user who gets assigned to compute instance 001 in the Machine Learning Workspace. | `my-aad--user-object-id` |
| `machineLearningComputeInstance001AdministratorPublicSshKey` | Specifies the public SSH key for compute instance 001 in the Machine Learning Workspace. Use a secret for this parameter and overwrite as part of the deployment pipelines. | `my-aad--user-object-id` |
| `administratorPassword` | Specifies the administrator password of the sql servers. Will be automatically set in the workflow. **Leave this value as is.** | `<your-secure-password>` |
| `synapseDefaultStorageAccountFileSystemId` | Specifies the Resource ID of the default Storge Account file system for Synapse. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-name}/blobServices/default/containers/{container-name}` |
| `purviewId` | Specifies the Resource ID of the central Purview instance. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Purview/accounts/{purview-name}` |
| `purviewManagedStorageId` | Specifies the Resource ID of the managed storage of the central purview instance. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}` |
| `purviewManagedEventHubId` | Specifies the Resource ID of the managed event hub of the central purview instance. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.EventHub/namespaces/{eventhub-namespace-name}` |
| `databricksWorkspaceId` | Specifies the Resource ID of the Databricks workspace that will be connected to the Machine Learning Workspace. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Databricks/workspaces/{databricks-name}` |
| `databricksWorkspaceUrl` | Specifies the workspace URL of the Databricks workspace that will be connected to the Machine Learning Workspace. | `adb-{databricks-workspace-id}.azuredatabricks.net` |
| `databricksAccessToken` | Specifies the access token of the Databricks workspace that will be connected to the Machine Learning Workspace. Use a secret for this parameter and overwrite as part of the deployment pipelines. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Purview/accounts/{purview-name}` |
| `enableRoleAssignments` | Specifies whether role assignments should be enabled. | `true` or `false` |
| `cognitiveServiceKinds` | Specifies the cognitive service kind that will be deployed. | [`FormRecognizer`, `LUIS`] |
| `enableSearch` | Specifies whether Azure Search should be deployed as part of the template. | `true` or `false` |
| `subnetId` | Specifies the resource ID of the subnet to which all services will connect. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/virtualNetworks/{vnet-name}/subnets/{subnet-name}` |
| `privateDnsZoneIdKeyVault` | Specifies the Resource ID of the private DNS zone for KeyVault. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net` |
| `privateDnsZoneIdSynapseDev` | Specifies the Resource ID of the private DNS zone for Synapse Dev. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.dev.azuresynapse.net` |
| `privateDnsZoneIdSynapseSql` | Specifies the Resource ID of the private DNS zone for Synapse Sql. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.sql.azuresynapse.net` |
| `privateDnsZoneIdDataFactory` | Specifies the Resource ID of the private DNS zone for Data Factory. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.datafactory.azure.net` |
| `privateDnsZoneIdDataFactoryPortal` | Specifies the Resource ID of the private DNS zone for Data Factory Portal. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.adf.azure.com` |
| `privateDnsZoneIdCognitiveService` | Specifies the Resource ID of the private DNS zone for Cognitive Services. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com` |
| `privateDnsZoneIdContainerRegistry` | Specifies the Resource ID of the private DNS zone for Container Registry. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io` |
| `privateDnsZoneIdSearch` | Specifies the Resource ID of the private DNS zone for Azure Search. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net` |
| `privateDnsZoneIdBlob`| Specifies the resource ID of the private DNS zone for Blob Storage. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net` |
| `privateDnsZoneIdFile` | Specifies the resource ID of the private DNS zone for File Storage. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net` |
| `privateDnsZoneIdMachineLearningApi` | Specifies the Resource ID of the private DNS zone for Machine Learning API. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms` |
| `privateDnsZoneIdMachineLearningNotebooks` | Specifies the Resource ID of the private DNS zone for Machine Learning Notebooks. | `/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net` |

### Install Azure DevOps Pipelines GitHub Application

First you need to add and install the Azure Pipelines GitHub App to your GitHub account. To do so, execute the following steps:

1. Click on **Marketplace** in the top navigation bar on GitHub.
1. In the Marketplace, search for **Azure Pipelines**. The Azure Pipelines offering is free for anyone to use for public repositories and free for a single build queue if you're using a private repository.

    ![Install Azure Pipelines on GitHub](/docs/images/AzurePipelinesGH.png)

1. Select it and click on **Install it for free**.

    ![GitHub Template repository](/docs/images/InstallButtonGH.png)

1. If you are part of multiple **GitHub** organizations, you may need to use the **Switch billing account** dropdown to select the one into which you forked this repository.
1. You may be prompted to confirm your GitHub password to continue.
1. You may be prompted to log in to your Microsoft account. Make sure you log in with the one that is associated with your Azure DevOps account.

### Configuring the Azure Pipelines project

As a last step, you need to create an Azure DevOps pipeline in your project based on the pipeline definition YAML file that is stored in your GitHub repository. To do so, execute the following steps:

1. Select the Azure DevOps project where you have setup your `Resource Manager Connection`.
1. Select **Pipelines** and then **New Pipeline** in order to create a new pipeline.

    ![Create Pipeline in DevOps](/docs/images/CreatePipelineDevOps.png)

1. Choose **GitHub YAML** and search for your repository (e.g. "`GitHubUserName/RepositoryName`").

    ![Choose code source in DevOps Pipeline](/docs/images/CodeDevOps.png)

1. Select your repository.
1. Click on **Existing Azure Pipelines in YAML file**
1. Select `main` as branch and `/.ado/workflows/dataHubDeployment.yml` as path.

    ![Configure Pipeline in DevOps](/docs/images/ConfigurePipelineDevOps.png)

1. Click on **Continue** and then on **Run**.

## Merge these changes back to the `main` branch of your repository

After following the instructions and updating the parameters and variables in your repository in a separate branch and opening the pull request, you can merge the pull request back into the `main` branch of your repository by clicking on **Merge pull request**. Finally, you can click on **Delete branch** to clean up your repository. By doing this, you trigger the deployment workflow.

## Follow the workflow deployment

**Congratulations!** You have successfully executed all steps to deploy the template into your environment through Azure DevOps.

Now, you can navigate to the pipeline that you have created as part of step 5 and monitor it as each service is deployed. If you run into any issues, please check the [Known Issues](/docs/DataManagementAnalytics-KnownIssues.md) first and open an [issue](https://github.com/Azure/data-product-analytics/issues) if you come across a potential bug in the repository.

>[Previous](/docs/DataManagementAnalytics-ServicePrincipal.md)
>[Next](/docs/DataManagementAnalytics-KnownIssues.md)
