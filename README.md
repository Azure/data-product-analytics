# Enterprise Scale Analytics and AI - Data Product: Analytics & Data Science

> **General disclaimer** Please be aware that this template is in private preview. Therefore, expect smaller bugs and issues when working with the solution. Please submit an Issue in GitHub if you come across any issues that you would like us to fix.

**DO NOT COPY - UNDER DEVELOPMENT - MS INTERNAL ONLY - Please be aware that this template is in private preview without any SLA.**

## Description

[**Enterprise Scale Analytics and AI**](https://github.com/Azure/Enterprise-Scale-Analytics) solution pattern emphasizes self-service and follows the concept of creating landing zones for cross-functional teams. Operation and responsibility of these landing zones is handed over to the responsible teams inside the data node. The teams are free to deploy their own services within the guardrails set by Azure Policy. To scale across the landing zones more quickly and allow a shorter time to market, we use the concept of Data Domain and Data Product templates. `Data Domain` and `Data Product` templates are blueprints, which can be used to quickly spin up environments for these cross-functional teams. The teams can fork these repositories to quickly spin up environments based on their requirements. This Data Product template deploys a set of services, which can be used for data analytics and data science. The template includes tools such as Azure Machine Learning, Cognitive Services and Azure Search, which allows the teams to choose their tools based on their requirements and preferences.

## What will be deployed?

By default, all the services which come under Data Product Analytics are enabled, and you must explicitly disable services that you don't want to be deployed.

> **Note:** Before deploying the resources, we recommend to check registration status of the required resource providers in your subscription. For more information, see [Resource providers for Azure services](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types).

![Data Product Analytics](./docs/images/ProductAnalytics.png)

For each Data Product Analytics template, the following services are created:

- [Key Vault](https://docs.microsoft.com/azure/key-vault/general)
- [Data Factory](https://docs.microsoft.com/azure/data-factory/)
- [Cognitive Services](https://azure.microsoft.com/services/cognitive-services/)
- [Synapse Workspace](https://docs.microsoft.com/azure/synapse-analytics/)
- [Azure Search](https://azure.microsoft.com/services/search/)
- [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Machine Learning](https://azure.microsoft.com/services/machine-learning/)
- [Container Registry](https://azure.microsoft.com/services/container-registry/)
- [SQL Pool](https://docs.microsoft.com/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is)
- [SQL Server](https://docs.microsoft.com/sql/sql-server/?view=sql-server-ver15)
- [Storage](https://azure.microsoft.com/services/storage/)
- [BigData Pool](https://docs.microsoft.com/sql/big-data-cluster/concept-data-pool?view=sql-server-ver15)

For more details regarding the services that will be deployed, please read the [Products](https://github.com/Azure/Enterprise-Scale-Analytics/blob/main/docs/03-datalandingzones/06-dataproducts.md) guide in the Enterprise Scale Analytics documentation.

You have two options for deploying this reference architecture:

1. Use the `Deploy to Azure` button for an immediate deployment
2. Use GitHub Actions or Azure DevOps Pipelines for an automated, repeatable deployment

## Prerequisites

> **Note:** Please make sure you have successfully deployed a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and a [Data Landing Zone](https://github.com/Azure/data-landing-zone). The Data Product relies on the Private DNS Zones that are deployed in the Data Management Template. If you have Private DNS Zones deployed elsewhere, you can also point to these. If you do not have the Private DNS Zones deployed for the respective services, this template deployment will fail. Also, this template requires subnets as specified in the prerequisites. The Data Landing Zone already creates a few subnets, which can be used for this Data Product. 

The following prerequisites are required to make this repository work:

- A **Data Management Landing Zone** deployed. For more information, check the [Data Management Landing Zone](https://github.com/Azure/data-management-zone) repo.
- A **Data Landing Zone** deployed. For more information, check the [Data Landing Zone](https://github.com/Azure/data-landing-zone) repo.
- A resource group within an Azure subscription
- [User Access Administrator](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner) access to a resource group to be able to create a service principal and role assignments for it.
- Access to a subnet with `privateEndpointNetworkPolicies` and `privateLinkServiceNetworkPolicies` set to disabled. The Data Landing Zone deployment already creates a few subnets with this configuration (subnets with suffix `-privatelink-subnet`).
- For deployment, please choose one of the below **Supported Regions** list.

### **Supported Regions:**

- Asia Southeast
- Europe North
- Europe West
- France Central
- Japan East
- South Africa North
- UK South
- US Central
- US East
- US East 2
- US West 2

## Option 1: Deploy to Azure - Quickstart (Coming soon ...)

| Data Product Analytics |
|:-----------------------------|
<!-- [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-analytics%2Fmain%2Fdocs%2Freference%2Fdeploy.dataProduct.json) -->
![Deploy to Azure](docs/images/deploytoazuregrey.png)

## Option 2: GitHub Actions or Azure DevOps Pipelines

### 1. Create repository from a template

1. On GitHub, navigate to the main page of this repository.
1. Above the file list, click **Use this template**

  ![GitHub Template repository](docs/images/UseThisTemplateGH.png)

1. Use the **Owner** drop-down menu and select the account you want to own the repository.

  ![Create Repository from Template](docs/images/CreateRepoGH.png)

1. Type a name for your repository and an optional description.
1. Choose a repository visibility. For more information, see "[About repository visibility](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/about-repository-visibility)."
1. Optionally, to include the directory structure and files from all branches in the template and not just the default branch, select **Include all branches**.
1. Click **Create repository from template**.

### 2. Setting up the required Service Principal and access

A service principal with *Contributor* role needs to be generated for authentication and authorization from GitHub or Azure DevOps to your Azure **Data Landing Zone** subscription, where the data-product-analytics services will be deployed. Just go to the Azure Portal to find the ID of your subscription. Then start the Cloud Shell or Azure CLI, login to Azure, set the Azure context and execute the following commands to generate the required credentials:

> **Note:** The purpose of this new **Service Principal** is to assign least-privilege rights. Therefore, it requires the **Contributor** role at a resource group scope in order to deploy the resources inside the resource group dedicated to a specific data product. The **Network Contributor** role assignment is required as well in this repository in order to assign the resources to the dedicated subnet.

#### Azure CLI

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

Now that the new Service Principal is created, as mentioned,  role assignments are required for this service principal in order to be able to successfully deploy all services. Required role assignments which will be added on a later step include:

| Role Name | Description | Scope |
|:----------|:------------|:------|
| [Private DNS Zone Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#private-dns-zone-contributor) | We expect you to deploy all Private DNS Zones for all data services into a single subscription and resource group. Therefor, the service principal needs to be Private DNS Zone Contributor on the global dns resource group which was created during the Data Management Zone deployment. This is required to deploy A-records for the respective private endpoints.| <div style="width: 36ch">(Resource Group Scope) `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`</div> |
| [Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor) | We expect you to deploy all data-product-analytics services into a single resource group within the Data Landing Zone subscription. The service principal requires a **Contributor** role-assignment on that resource group.| <div style="width: 36ch">(Resource Group Scope) `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}`</div> |
| [Network Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#network-contributor) | In order to deploy Private Endpoints to the specified privatelink-subnet which was created during the Data Landing Zone deployment, the service principal requires **Network Contributor** access on that specific subnet.| <div style="width: 36ch">(Child-Resource Scope) `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName} /providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}"`</div> |

To add these role assignments, you can use the [Azure Portal](https://portal.azure.com/) or run the following commands using Azure CLI/Azure Powershell:

#### Azure CLI - Add role assignments

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

# For Child-Resource Scope level assignment
# TBD
```

#### Azure Powershell - Add role assignments

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

#### GitHub Actions

If you want to use GitHub Actions for deploying the resources, add the previous JSON output as a [repository secret](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) with the name `AZURE_CREDENTIALS` in your GitHub repository:

![GitHub Secrets](docs/images/AzureCredentialsGH.png)

To do so, execute the following steps:

1. On GitHub, navigate to the main page of the repository.
2. Under your repository name, click on the **Settings** tab.
3. In the left sidebar, click **Secrets**.
4. Click **New repository secret**.
5. Type the name `AZURE_CREDENTIALS` for your secret in the Name input box.
6. Enter the JSON output from above as value for your secret.
7. Click **Add secret**.

#### Azure DevOps

If you want to use Azure DevOps Pipelines for deploying the resources, you need to create an Azure Resource Manager service connection. To do so, execute the following steps:

1. First, you need to create an Azure DevOps Project. Instructions can be found [here](https://docs.microsoft.com/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page).
1. In Azure DevOps, open the **Project settings**.
1. Now, select the **Service connections** page from the project settings page.
1. Choose **New service connection** and select **Azure Resource Manager**.
  ![ARM Connection](docs/images/ARMConnectionDevOps.png)

1. On the next page select **Service principal (manual)**.
1. Select the appropriate environment to which you would like to deploy the templates. Only the default option **Azure Cloud** is currently supported.
1. For the **Scope Level**, select **Subscription** and enter your `subscription Id` and `name`.
1. Enter the details of the service principal that we have generated in step 3. (**Service Principal Id** = **clientId**, **Service Principal Key** = **clientSecret**, **Tenant ID** = **tenantId**) and click on **Verify** to make sure that the connection works.
1. Enter a user-friendly **Connection name** to use when referring to this service connection. Take note of the name because this will be required in the parameter update process.
1. Optionally, enter a **Description**.
1. Click on **Verify and save**.

  ![Connection DevOps](docs/images/ConnectionDevOps.png)

More information can be found [here](https://docs.microsoft.com/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-with-an-existing-service-principal).

### 4. Parameter Update Process

> **Note:** This section applies for both **Azure DevOps** and **GitHub** Deployment

In order to deploy the ARM templates in this repository to the desired Azure subscription, you will need to modify some parameters in the forked repository, which will be used for updating the files which will be used during the deployment. Therefor, **this step should not be skipped for neither Azure DevOps/GitHub options**. As updating each parameter file manually is a time-consuming and potentially error-prone process, we have simplified the task with a GitHub Action workflow. You can update your deployment parameters by completing three steps:

  1. Configure the `updateParameters` workflow
  1. Execute the `updateParameters` workflow
  1. Configure the deployment pipeline
  1. Merge these changes back to the `main` branch of your repo

#### Configure the `updateParameters` workflow

> **Note:** There is only one 'updateParameters.yml', which can be found under the '.github' folder and this one will be used also for setting up the Azure DevOps Deployment

To begin, please open [.github/workflows/updateParameters.yml](/.github/workflows/updateParameters.yml) and update the following environment variables:

```yaml
env:
  GLOBAL_DNS_RESOURCE_GROUP_ID: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}'
  DATA_LANDING_ZONE_SUBSCRIPTION_ID: '{dataLandingZoneSubscriptionId}'
  DATA_PRODUCT_NAME: '{dataProductName}' # Choose max. 11 characters. They will be used as a prefix for all services. If not unique, deployment can fail for some services.
  LOCATION: '{regionName}'               # Specifies the region for all services (e.g. 'northeurope', 'eastus', etc.)
  SUBNET_ID: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}' # Resource ID of the dedicated privatelink-subnet which was created during the Data Landing Zone deployment. Choose one which has the suffix **private-link**.
  ML_COMPUTE_INSTANCE_USER_OBJECT_ID: '{mlComputeInstanceObjectId}'
  DATABRICKS_WORKSPACE_ID: '{databricksWorkspaceId}'
  SYNAPSE_STORAGE_ACCOUNT_NAME: '{synapseStorageAccountName}' # Choose a storage account which was previously deployed in the Data Landing Zone.
  SYNAPSE_STORAGE_ACCOUNT_FILE_SYSTEM_NAME: '{synapseStorageAccountFileSystemName}' # Choose the name of the container inside the Storage Account which was referenced in the above SYNAPSE_STORAGE_ACCOUNT_NAME variable.
  PURVIEW_ID: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Purview/accounts/{purviewName}' # If no Purview account is deployed, leave it empty string.
  AZURE_RESOURCE_MANAGER_CONNECTION_NAME: '{resourceManagerConnectionName}' # This is needed just for ADO Deployments.
```

The following table explains each of the parameters:
| Parameter                                | Description  | Sample value |
|:-----------------------------------------|:-------------|:-------------|
| **GLOBAL_DNS_RESOURCE_GROUP_ID**             | Specifies the global DNS resource group resource ID which gets deployed with the [Data Management Landing Zone](https://github.com/Azure/data-management-zone)| <div style="width: 36ch">`/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group`</div> |
| **DATA_LANDING_ZONE_SUBSCRIPTION_ID**        | Specifies the subscription ID of the Data Landing Zone where all the resources will be deployed | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| **DATA_PRODUCT_NAME**                        | Specifies the name of your Data Product. The value should consist of alphanumeric characters (A-Z, a-z, 0-9) and should not contain any special characters like `-`, `_`, `.`, etc. Special characters will be removed in the renaming process. | `myproduct01` |
| **LOCATION**                                 | Specifies the region where you want the resources to be deployed. Please use the same region as for your Data Landing Zone. Otherwise the deployment will fail, since the Vnet and the Private Endpoints have to be in the same region. Also Check [Supported Regions](#supported-regions) | `northeurope` |
| **SUBNET_ID**                                | Specifies the resource ID of the dedicated privatelink-subnet which was created during the Data Landing Zone deployment. Choose one which has the suffix **private-link**. The subnet is already configured with `privateEndpointNetworkPolicies` and `privateLinkServiceNetworkPolicies` set to `Disabled`, as mentioned in the *Prerequisites* | `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-network-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/{my}-privatelink-subnet` |
|**ML_COMPUTE_INSTANCE_USER_OBJECT_ID**        | Specifies the [object ID of a user account](https://docs.microsoft.com/en-us/azure/marketplace/find-tenant-object-id#find-user-object-id) for which an Azure Machine Learning Compute Instance should be created (on-behalf CI creation). The deployment of a compute instance is disabled by default. If you don't have a user object ID, then please leave this parameter as is.  | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
|**DATABRICKS_WORKSPACE_ID**        | Specifies the resource ID of a Databricks workspace to which your Azure Machine Learning workspace should be connected to. The deployment of this connection is disabled by default. Leave this parameter as is, if you don' have a Databricks workspace that you want to connect to the Machine Learning workspace. In general, we are recommending to use the shared Databricks workspace with the name `{my-prefix}-databricks002-processing` that gets deployed into the resource group `{myprefix}-shared-product` as part of the Data Landing Zone deployment.  | <div style="width: 36ch">`/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myrgname/providers/Microsoft.Databricks/workspaces/mydatabricksworkspace`</div> |
|**SYNAPSE_STORAGE_ACCOUNT_NAME**| Specifies the name of the Azure Synapse Storage Account, which was previously deployed in the Data Landing Zone. Go to the `{DataLandingZoneName}-storage` resource group in your Data Landing Zone and copy the resource name (`{DataLandingZoneName}worksa`).  | `mydlzworksa` |
|**SYNAPSE_STORAGE_ACCOUNT_FILE_SYSTEM_NAME**| Specifies the name of the Synapse Account filesystem, which is the name of the container inside the Storage Account that was referenced in the above SYNAPSE_STORAGE_ACCOUNT_NAME variable. | `data`|
| **PURVIEW_ID**                               | Specifies the resource ID of the Purview account to which the Synapse workspaces and Data Factories should connect to share data lineage and other metadata. In case you do not have a Purview account deployed at this stage, leave it empty string. | <div style="width: 36ch">`/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-governance-rg/providers/Microsoft.Purview/accounts/my-purview`</div> |
| **AZURE_RESOURCE_MANAGER_CONNECTION_NAME**   | Specifies the resource manager connection name in Azure DevOps. You can leave the default value if you want to use GitHub Actions for your deployment. More details on how to create the resource manager connection in Azure DevOps can be found in step 4. b) or [here](https://docs.microsoft.com/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-with-an-existing-service-principal). | `my-connection-name` |

#### Execute the `updateParameters` workflow

After updating the values, please commit the updated version to the `main` branch of your repository. This will kick off a GitHub Action workflow, which will appear under the **Actions** tab of the main page of the repository. The `Update Parameter Files` workflow will update all parameters in your repository according to a pre-defined naming convention.

#### Configure the deployment pipeline

The workflow above will make changes to all of the ARM config files.  These changes will be stored in a new branch. Once the process has finished, it will open a new pull request in your repository where you can review the changes made by the workflow.  The pull request will also provide the values you need to use to configure the deployment pipeline. Please follow the instructions in the pull request to complete the parameter update process.

If you are using GitHub Actions for your deployment, you will need to modify the `.github/workflows/dataProductDeployment.yml` file.  If you are using Azure Pipelines, you only need to modify the `.ado/workflows/dataProductDeployment.yml` file.  **You only need to modify one of these files. You do not need to modify both of them.**
Please follow the instructions in the pull request to complete the parameter update process. The instructions will guide towards the following steps:

- create a new `resource group` where all the resources specific to this Data Product Analytics template will be deployed;
- add the required role assignments for the Service Principal created at step [2. Setting up the required Service Principal and access](#2-setting-up-the-required-service-principal-and-access)
- change the environment variables in the deployment workflow file

> **Note:** We are not renaming the environment variables in the workflow files because this could lead to an infinite loop of workflow runs being started.

#### Merge these changes back to the `main` branch of your repo

After following the instructions in the pull request, you can merge the pull request back into the `main` branch of your repository by clicking on **Merge pull request**. Finally, you can click on **Delete branch** to clean up your repository.

### 5. (not applicable for GH Actions) Reference pipeline from GitHub repository in Azure DevOps Pipelines

#### Install Azure DevOps Pipelines GitHub Application

First you need to add and install the Azure Pipelines GitHub App to your GitHub account. To do so, execute the following steps:

1. Click on **Marketplace** in the top navigation bar on GitHub.
1. In the Marketplace, search for **Azure Pipelines**. The Azure Pipelines offering is free for anyone to use for public repositories and free for a single build queue if you're using a private repository.

  ![Install Azure Pipelines on GitHub](docs/images/AzurePipelinesGH.png)

1. Select it and click on **Install it for free**.

  ![GitHub Template repository](docs/images/InstallButtonGH.png)

1. If you are part of multiple **GitHub** organizations, you may need to use the **Switch billing account** dropdown to select the one into which you forked this repository.
1. You may be prompted to confirm your GitHub password to continue.
1. You may be prompted to log in to your Microsoft account. Make sure you log in with the one that is associated with your Azure DevOps account.

#### Configuring the Azure Pipelines project

As a last step, you need to create an Azure DevOps pipeline in your project based on the pipeline definition YAML file that is stored in your GitHub repository. To do so, execute the following steps:

1. Select the Azure DevOps project where you have setup your `Resource Manager Connection`.
1. Select **Pipelines** and then **New Pipeline** in order to create a new pipeline.

  ![Create Pipeline in DevOps](docs/images/CreatePipelineDevOps.png)

1. Choose **GitHub YAML** and search for your repository (e.g. "`GitHubUserName/RepositoryName`").

  ![Configure Pipeline in DevOps](docs/images/CodeDevOps.png)

1. Select your repository.
1. Click on **Existing Azure Pipelines in YAML file**
1. Select `main` as branch and `/.ado/workflows/dataProductDeployment.yml` as path.

  ![Configure Pipeline in DevOps](docs/images/ConfigurePipelineDevOps.png)

1. Click on **Continue** and then on **Run**.

### 6. Follow the workflow deployment

**Congratulations!** You have successfully executed all steps to deploy the template into your environment through GitHub Actions or Azure DevOps.

If you are using GitHub Actions, you can navigate to the **Actions** tab of the main page of the repository, where you will see a workflow with the name `Data Product Deployment` running. Click on it to see how it deploys one service after another. If you run into any issues, please open an issue [here](https://github.com/Azure/data-landing-zone/issues).

If you are using Azure DevOps Pipelines, you can navigate to the pipeline that you have created as part of step 6 and monitor it as each service is deployed. If you run into any issues, please open an issue [here](https://github.com/Azure/data-landing-zone/issues).

### Documentation

### Code Structure

| File/folder                   | Description                                |
| ----------------------------- | ------------------------------------------ |
| `.ado/workflows`              | Folder for ADO workflows. The `dataProductDeployment.yml` workflow shows the steps for an end-to-end deployment of the architecture. |
| `.github/workflows`           | Folder for GitHub workflows. The `updateParameters.yml` workflow is used for the parameter update process, while the `dataProductDeployment.yml` workflow shows the steps for an end-to-end deployment of the architecture. |
| `code`                        | Sample password generation script that will be run in the deployment workflow for resources that require a password during the deployment. |
| `configs`                     | Folder containing a script and configuration file that is used for the parameter update process. |
| `docs`                        | Resources for this README.                 |
| `infra`                       | Folder containing all the ARM templates for each of the resources that will be deployed (`deploy.{resource}.json`) together with their parameter files (`params.{resource}.json`). |
| `CODE_OF_CONDUCT.md`          | Microsoft Open Source Code of Conduct.     |
| `LICENSE`                     | The license for the sample.                |
| `README.md`                   | This README file.                          |
| `SECURITY.md`                 | Microsoft Security README.                 |

### Enterprise Scale Analytics and AI - Documentation and Implementation

- [Documentation](https://github.com/Azure/Enterprise-Scale-Analytics)
- [Implementation - Data Management](https://github.com/Azure/data-management-zone)
- [Implementation - Data Landing Zone](https://github.com/Azure/data-landing-zone)
- [Implementation - Data Domain - Batch](https://github.com/Azure/data-domain-batch)
- [Implementation - Data Domain - Streaming](https://github.com/Azure/data-domain-streaming)
- [Implementation - Data Product - Reporting](https://github.com/Azure/data-product-reporting)
- [Implementation - Data Product - Analytics & Data Science](https://github.com/Azure/data-product-analytics)

## Known issues

### Error: MissingSubscriptionRegistration

**Error Message:**

```sh
ERROR: Deployment failed. Correlation ID: ***
  "error": ***
    "code": "MissingSubscriptionRegistration",
    "message": "The subscription is not registered to use namespace 'Microsoft.DocumentDB'. See https://aka.ms/rps-not-found for how to register subscriptions.",
    "details": [
      ***
        "code": "MissingSubscriptionRegistration",
        "target": "Microsoft.DocumentDB",
        "message": "The subscription is not registered to use namespace 'Microsoft.DocumentDB'. See https://aka.ms/rps-not-found for how to register subscriptions."

```

**Solution:**

This error message appears, in case during the deployment it tries to create a type of resource which has never been deployed before inside the subscription. We recommend to check prior the deployment whether the required resource providers are registered for your subscription and if needed, register them through the `Azure Portal`, `Azure Powershell` or `Azure CLI` as mentioned [here](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types).

## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repositories using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

