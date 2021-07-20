# Data Product Analytics - Prerequisites

This template repsitory contains all templates to deploy a Data Product for Analytics and Data Science inside a Data Landing Zone of the Enterprise-Scale Analytics architecture. Data Products are another unit of scale inside a Data Landing Zone and provide environments to cross-functional teams to work on individual data use-cases.

## What will be deployed?

By navigating through the deployment steps, you will deploy the folowing setup in a subscription:

> **Note:** Before deploying the resources, we recommend to check registration status of the required resource providers in your subscription. For more information, see [Resource providers for Azure services](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types).

![Data Product Analytics](/docs/images/ProductAnalytics.png)

The deployment and code artifacts include the following services:

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

For now, we are recommending to select one of the regions mentioned below. The list of regions is limited for now due to the fact that not all services and features are available in all regions. This is mostly related to the fact that we are recommending to leverage at least the zone-redundant storage replication option for all your central Data Lakes in the Data Landing Zones. Since zone-redundant storage is not available in all regions, we are limiting the regions in the Deploy to Azure experience. If you are planning to deploy the Data Management Zone and Data Landing Zone to a region that is not listed below, then please change the setting in the corresponding bicep files in this repository. Officially supported regions are:

- (Africa) South Africa North
- (Asia Pacific) Southeast Asia
- (Asia Pacific) Australia East
- (Asia Pacific) Japan East
- (Canada) Canada Central
- (Europe) North Europe
- (Europe) West Europe
- (Europe) France Central
- (Europe) Germany West Central
- (Europe) UK South
- (South America) Brazil South
- (US) Central US
- (US) East US
- (US) East US 2
- (US) South Central US
- (US) West US 2

## Prerequisites

> **Note:** Please make sure you have successfully deployed a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and a [Data Landing Zone](https://github.com/Azure/data-landing-zone) beforehand. Also, this template requires subnets as specified in the prerequisites. The Data Landing Zone already creates a few subnets, which can be used for this Data Product.

Before we start with the deployment, please make sure that you have the following available:

- A **Data Management Landing Zone** deployed. For more information, check the [Data Management Landing Zone](https://github.com/Azure/data-management-zone) repo.
- A **Data Landing Zone** deployed. For more information, check the [Data Landing Zone](https://github.com/Azure/data-landing-zone) repo.
- A resource group within an Azure subscription
- An Azure subscription. If you don't have an Azure subscription, [create your Azure free account today](https://azure.microsoft.com/free/).
- [User Access Administrator](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) or [Owner](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner) access to the subscription to be able to create a service principal and role assignments for it.
- Access to a subnet with `privateEndpointNetworkPolicies` and `privateLinkServiceNetworkPolicies` set to disabled. The Data Landing Zone deployment already creates a few subnets with this configuration (subnets with name `DataProduct00{x}Subnet` or `DataIntegration00{x}Subnet`.).
- For the deployment, please choose one of the **Supported Regions**.

## Deployment

Now you have two options for the deployment of the Data Landing Zone:

1. Deploy to Azure Button
2. GitHub Actions or Azure DevOps Pipelines

To use the Deploy to Azure Button, please click on the button below:

| Reference implementation   | Description | Deploy to Azure |
|:---------------------------|:------------|:----------------|
| Data Product Analytics     | Deploys a Data Workload template for Data Analytics and Data Science to a resource group inside a Data Landing Zone. Please deploy a [Data Management Zone](https://github.com/Azure/data-management-zone) and [Data Landing Zone](https://github.com/Azure/data-landing-zone) first. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-analytics%2Fmain%2Finfra%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-analytics%2Fmain%2Fdocs%2Freference%2Fportal.dataProduct.json) | [Repository](https://github.com/Azure/data-product-analytics) |

Alternatively, click on `Next` to follow the steps required to successfully deploy the Data Landing Zone through GitHub Actions or Azure DevOps.

>[Next](/docs/EnterpriseScaleAnalytics-CreateRepository.md)
