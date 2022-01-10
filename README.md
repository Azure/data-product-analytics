# Data Management & Analytics Scenario - Data Product Analytics

## Objective

The [Data Management & Analytics Scenario](https://aka.ms/adopt/datamanagement) provides a prescriptive data platform design coupled with Azure best practices and design principles. These principles serve as a compass for subsequent design decisions across critical technical domains. The architecture will continue to evolve alongside the Azure platform and is ultimately driven by the various design decisions that organizations must make to define their Azure data journey.

The Data Management & Analytics architecture consists of two core building blocks:

1. *Data Management Landing Zone* which provides all data management and data governance capabilities for the data platform of an organization.
1. *Data Landing Zone* which is a logical construct and a unit of scale in the Data Management & Analytics architecture that enables data retention and execution of data workloads for generating insights and value with data.

The architecture is modular by design and allows organizations to start small with a single Data Management Landing Zone and Data Landing Zone, but also allows to scale to a multi-subscription data platform environment by adding more Data Landing Zones to the architecture. Thereby, the reference design allows to implement different modern data platform patterns like data-mesh, data-fabric as well as traditional datalake architectures. Data Management & Analytics Scenario has been very well aligned with the data-mesh approach, and is ideally suited to help organizations build data products and share these across business units of an organization. If core recommendations are followed, the resulting target architecture will put the customer on a path to sustainable scale.

![Data Management & Analytics](/docs/images/DataManagementAnalytics.gif)

---

_The Data Management & Analytics Scenario represents the strategic design path and target technical state for your Azure data platform._

---

This repository describes a Data Product template for Data Analytics and Data Science. Data Products are another unit of scale inside a Data Landing Zone through the means of Resource Groups. Resource Groups inside the Data Landing Zone subscription are created and handed over to cross-functional teams to provide them an environment in which they can work on their own data use-cases. The ownership of this resource group and operation of services within is handed over to the Data Product teams. In order to enable self-service, the owning teams are free to deploy their own services within the guardrails set by Azure Policy. Repository templates can be used for these teams to more quickly scale within an organization and rollout common data analysis patterns not just once but multiple times across various use-cases. The ownership of templates is also handed over, which ultimately gives these teams a starting point while allowing them to enhance the template based on their specific requirements. This Data Product template deploys a set of services, which can be used for data analytics and data science. The template includes services such as Azure Machine Learning, Cognitive Services and Azure Search. The Data Product teams can then leverage these tools to generate insights and value with data.

> **Note:** Before getting started with the deployment, please make sure you are familiar with the [complementary documentation in the Cloud Adoption Framework](https://aka.ms/adopt/datamanagement). Also, before deploying your first Data Product, please make sure that you have deployed a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and at least one [Data Landing Zone](https://github.com/Azure/data-landing-zone). The minimal recommended setup consists of a single [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and a single [Data Landing Zone](https://github.com/Azure/data-landing-zone).

## Deploy Data Management & Analytics Scenario

The Data Management & Analytics architecture is modular by design and allows customers to start with a small footprint and grow over time. In order to not end up in a migration project, customers should decide upfront how they want to organize data domains across Data Landing Zones. All Data Management & Analytics architecture building blocks can be deployed through the Azure Portal as well as through GitHub Actions workflows and Azure DevOps Pipelines. The template repositories contain sample YAML pipelines to more quickly get started with the setup of the environments.

| Reference implementation   | Description | Deploy to Azure | Link |
|:---------------------------|:------------|:----------------|------|
| Data Management & Analytics Scenario | Deploys a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and one or multiple Data Landing Zones all at once. Provides less options than the the individual Data Management Landing Zone and Data Landing Zone deployment options. Helps you to quickly get started and make yourself familiar with the reference design. For more advanced scenarios, please deploy the artifacts individually. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-management-zone%2Fmain%2Fdocs%2Freference%2FdataManagementAnalytics.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-management-zone%2Fmain%2Fdocs%2Freference%2Fportal.dataManagementAnalytics.json) |  |
| Data Management Landing Zone       | Deploys a single Data Management Landing Zone to a subscription. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-management-zone%2Fmain%2Finfra%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-management-zone%2Fmain%2Fdocs%2Freference%2Fportal.dataManagementZone.json) | [Repository](https://github.com/Azure/data-management-zone) |
| Data Landing Zone          | Deploys a single Data Landing Zone to a subscription. Please deploy a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) first. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-landing-zone%2Fmain%2Finfra%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-landing-zone%2Fmain%2Fdocs%2Freference%2Fportal.dataLandingZone.json) | [Repository](https://github.com/Azure/data-landing-zone) |
| Data Product Batch     | Deploys a Data Workload template for Data Batch Analysis to a resource group inside a Data Landing Zone. Please deploy a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and [Data Landing Zone](https://github.com/Azure/data-landing-zone) first. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-batch%2Fmain%2Finfra%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-batch%2Fmain%2Fdocs%2Freference%2Fportal.dataProduct.json) | [Repository](https://github.com/Azure/data-product-batch) |
| Data Product Streaming | Deploys a Data Workload template for Data Streaming Analysis to a resource group inside a Data Landing Zone. Please deploy a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and [Data Landing Zone](https://github.com/Azure/data-landing-zone) first. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-streaming%2Fmain%2Finfra%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-streaming%2Fmain%2Fdocs%2Freference%2Fportal.dataProduct.json) | [Repository](https://github.com/Azure/data-product-streaming) |
| Data Product Analytics     | Deploys a Data Workload template for Data Analytics and Data Science to a resource group inside a Data Landing Zone. Please deploy a [Data Management Landing Zone](https://github.com/Azure/data-management-zone) and [Data Landing Zone](https://github.com/Azure/data-landing-zone) first. |[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-analytics%2Fmain%2Finfra%2Fmain.json/uiFormDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdata-product-analytics%2Fmain%2Fdocs%2Freference%2Fportal.dataProduct.json) | [Repository](https://github.com/Azure/data-product-analytics) |

## Deploy Data Product

To deploy the Data Product into your Data Landing Zone, please follow the step-by-step instructions:

1. [Prerequisites](/docs/DataManagementAnalytics-Prerequisites.md)
2. [Create repository](/docs/DataManagementAnalytics-CreateRepository.md)
3. [Setting up Service Principal](/docs/DataManagementAnalytics-ServicePrincipal.md)
4. Template Deployment
    1. [GitHub Action Deployment](/docs/DataManagementAnalytics-GitHubActionsDeployment.md)
    2. [Azure DevOps Deployment](/docs/DataManagementAnalytics-AzureDevOpsDeployment.md)
5. [Known Issues](/docs/DataManagementAnalytics-KnownIssues.md)

## Contributing

Please review the [Contributor's Guide](./CONTRIBUTING.md) for more information on how to contribute to this project via Issue Reports and Pull Requests.
