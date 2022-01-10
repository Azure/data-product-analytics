# Data Product Analytics - Prerequisites

This template repository contains all templates to deploy a Data Product for Analytics and Data Science inside a Data Landing Zone of the Data Management & Analytics Scenario. Data Products are another unit of scale inside a Data Landing Zone and provide environments to cross-functional teams to work on individual data use-cases. Hence, this template qualifies for the following usage:

| Scenario         | Applicability      |
|:-----------------|:-------------------|
| Data Product     | :heavy_check_mark: |
| Data Integration | :x:                |

## What will be deployed?

By navigating through the deployment steps, you will deploy the following setup in a subscription:

> **Note:** Before deploying the resources, we recommend to check registration status of the required resource providers in your subscription. For more information, see [Resource providers for Azure services](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types).

![Data Product Analytics](/docs/images/ProductAnalytics.png)

The deployment and code artifacts include the following services:

- [Machine Learning](https://azure.microsoft.com/services/machine-learning/)
- [Key Vault](https://docs.microsoft.com/azure/key-vault/general)
- [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Storage](https://azure.microsoft.com/services/storage/)
- [Container Registry](https://azure.microsoft.com/services/container-registry/)
- [Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) (optional)
- [Data Factory](https://docs.microsoft.com/azure/data-factory/) (select between Data Factory and Synapse)
- [Synapse Workspace](https://docs.microsoft.com/azure/synapse-analytics/) (select between Data Factory and Synapse)
- [Azure Search](https://azure.microsoft.com/services/search/) (optional)
- [SQL Pool](https://docs.microsoft.com/azure/synapse-analytics/sql-data-warehouse/sql-data-warehouse-overview-what-is) (optional)
- [BigData Pool](https://docs.microsoft.com/sql/big-data-cluster/concept-data-pool?view=sql-server-ver15) (optional)

## Security Mechanisms of the Data Product Analytics

The Data Product Analytics template and deployment will provide users with a secure Data Science environment that follows a multi-layered security approach by using a Private Endpoint driven network design, an identity driven access model as well as service-specific security properties and settings.

On the networking layer, all services come with Private Endpoints enabled as well as public network access disabled. This ensures that network traffic never leaves the corporate network and that services cannot be accessed from the public internet. In addition, encryption in transit is enforced by setting the minimum TLS version to 1.2 for all services where such a parameter is exposed and by enforcing HTTPS traffic on the default storage account of the Azure Machine Learning workspace. For Data Factory and Synapse, managed virtual networks are created by default to also ensure secure network traffic within these services. For Synapse, we also enable the data exfiltration risk protection to block managed private endpoints connecting to services hosted in other tenants. Thereby, we secure the users from any data-exfiltration risk within Synapse.

All services that get deployed as part of this Data Product are configured in a highly secure way. For instance, the Azure Machine Learning workspaces is flagged as a high business impact workspace in order to reduce the metadata and diagnostic data collected by the service. Also, the public access is fully disabled for the workspace and the user needs to be connected to the same virtual network in order to connect to the workspace via the Azure Machine Learning studio interface successfully. The default storage account of the workspace also comes pre-configured with disabled public blob access and cross-tenant replication and a retention policy for storage account containers protects the users from accidental data deletion and allows them to recover data, if necessary. The default Key Vault also has soft-delete and purge protection enabled to protect users from loss of secrets and certificates and the default container registry has a number of policies enabled to make sure the environment is secure against harmful images (quarantine policy).

## Code Structure

To help you more quickly understand the structure of the repository, here is an overview of what the respective folders contain:

| File/folder                   | Description                                |
| ----------------------------- | ------------------------------------------ |
| `.ado/workflows`              | Folder for ADO workflows. The `dataProductDeployment.yml` workflow shows the steps for an end-to-end deployment of the architecture. |
| `.github/workflows`           | Folder for GitHub workflows. The `dataProductDeployment.yml` workflow shows the steps for an end-to-end deployment of the architecture. |
| `code`                        | Sample password generation script that will be run in the deployment workflow for resources that require a password during the deployment. |
| `docs`                        | Resources for this README.                 |
| `infra`                       | Folder containing all the ARM and Bicep templates for each of the resources that will be deployed. |
| `CODE_OF_CONDUCT.md`          | Microsoft Open Source Code of Conduct.     |
| `LICENSE`                     | The license for the sample.                |
| `README.md`                   | This README file.                          |
| `SECURITY.md`                 | Microsoft Security README.                 |

## Supported Regions

For now, we are recommending to select one of the regions mentioned below. The list of regions is limited for now due to the fact that not all services and features are available in all regions. This is mostly related to the fact that we are recommending to leverage at least the zone-redundant storage replication option for all your central Data Lakes in the Data Landing Zones. Since zone-redundant storage is not available in all regions, we are limiting the regions in the Deploy to Azure experience. If you are planning to deploy the Data Management Landing Zone and Data Landing Zone to a region that is not listed below, then please change the setting in the corresponding bicep files in this repository. Deployment has been tested in the following regions:

- (Africa) South Africa North
- (Asia Pacific) Southeast Asia
- (Asia Pacific) Australia East
- (Asia Pacific) Central India
- (Asia Pacific) Japan East
- (Asia Pacific) Southeast Asia
- (Asia Pacific) South India
- (Canada) Canada Central
- (Europe) North Europe
- (Europe) West Europe
- (Europe) France Central
- (Europe) Germany West Central
- (Europe) North Europe
- (Europe) UK South
- (Europe) West Europe
- (South America) Brazil South
- (US) Central US
- (US) East US
- (US) East US 2
- (US) South Central US
- (US) West Central US
- (US) West US 2

**Please open a pull request if you want to deploy the artifacts into a region that is not listed above.**

## Prerequisites

> **Note:** Please make sure you have successfully deployed a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and a [Data Landing Zone](https://github.com/Azure/data-landing-zone) beforehand. Also, this template requires subnets as specified in the prerequisites. The Data Landing Zone already creates a few subnets, which can be used for this Data Product. If you have not deployed a Data Management Landing Zone and/or Data Landing Zone, please make sure that you have all Private DNS Zones deployed for the [services mentioned here](#what-will-be-deployed). If all outbound traffic is routed through a Firewall, please also make sure that you define [these network rules](https://github.com/Azure/data-management-zone/blob/f28583eee93afb893f6f31a0a8fbf8691c3c8324/infra/modules/services/firewallPolicyRules.bicep#L18-L54) and [these application rules](https://github.com/Azure/data-management-zone/blob/f28583eee93afb893f6f31a0a8fbf8691c3c8324/infra/modules/services/firewallPolicyRules.bicep#L247-L290) in the central network virtual appliance.

Before we start with the deployment, please make sure that you have the following available:

- An Azure subscription. If you don't have an Azure subscription, [create your Azure free account today](https://azure.microsoft.com/free/).
- Access to a resource group within an Azure subscription.
- A **Data Management Landing Zone** and a **Data Landing Zone** deployed. For more information, check the [Data Management Landing Zone repository](https://github.com/Azure/data-management-zone) and [Data Landing Zone repository](https://github.com/Azure/data-landing-zone). Alternatively, please make sure that you have deployed all required Private DNS Zones for the [services mentioned here](#what-will-be-deployed) and if all outbound traffic is routed through a Firewall, please make sure that you define [these network rules](https://github.com/Azure/data-management-zone/blob/f28583eee93afb893f6f31a0a8fbf8691c3c8324/infra/modules/services/firewallPolicyRules.bicep#L18-L54) and [these application rules](https://github.com/Azure/data-management-zone/blob/f28583eee93afb893f6f31a0a8fbf8691c3c8324/infra/modules/services/firewallPolicyRules.bicep#L247-L290) in the central network virtual appliance.
- [User Access Administrator](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner) access to the resource group and virtual network to be able to create a service principal and role assignments for it.
- Access to a subnet with `privateEndpointNetworkPolicies` and `privateLinkServiceNetworkPolicies` set to disabled as well as the `Microsoft.Storage` [service endpoint](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview#:~:text=%20Service%20endpoints%20provide%20the%20following%20benefits%3A%20,public%20IP%20addresses%20in%20your%20virtual...%20More%20) enabled in the region of the data product deployment. The Data Landing Zone deployment already creates a few subnets with `privateEndpointNetworkPolicies` and `privateLinkServiceNetworkPolicies` set to disabled (subnets with name `DataProduct00{x}Subnet` or `DataIntegration00{x}Subnet`.). However, these subnets do not have the `Microsoft.Storage` service endpoint enabled by default and therefore this must be [configured manually in the Azure Portal or by using Azure CLI or PowerShell](https://docs.microsoft.com/en-us/azure/virtual-network/tutorial-restrict-network-access-to-resources#enable-a-service-endpoint). Today, the service endpoint is required for compute clusters and compute instances in Azure Machine Learning.
- For the deployment, please choose one of the **Supported Regions**.

## Deployment

Now you have two options for the deployment of the Data Landing Zone:

1. Deploy to Azure Button
2. GitHub Actions or Azure DevOps Pipelines

To use the Deploy to Azure Button, please click on the button below:

| Reference implementation   | Description | Deploy to Azure |
|:---------------------------|:------------|:----------------|
| Data Product Analytics     | Deploys a Data Workload template for Data Analytics and Data Science to a resource group inside a Data Landing Zone. Please deploy a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and [Data Landing Zone](https://github.com/Azure/data-landing-zone) first. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-analytics%2Fmain%2Finfra%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-analytics%2Fmain%2Fdocs%2Freference%2Fportal.dataProduct.json) | [Repository](https://github.com/Azure/data-product-analytics) |

Alternatively, click on `Next` to follow the steps required to successfully deploy the Data Landing Zone through GitHub Actions or Azure DevOps.

>[Next](/docs/DataManagementAnalytics-CreateRepository.md)
