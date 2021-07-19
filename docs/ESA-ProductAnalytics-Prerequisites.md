# Prerequisites

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

If you don't have an Azure subscription, [create your Azure free account today](https://azure.microsoft.com/free/).

<p align="right">  Next: <a href="./ESA-ProductAnalytics-PrepareDeployment.md">Prepare the deployment</a> > </p>

< Previous: [Data Product Analytics template](../README.md)
