// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

// This template is used to create a dashboard.
targetScope = 'resourceGroup'

// Parameters
param location string
param dashbaordName string
param tags object
param datafactoryScope string
param datafactoryName string

// Variables

// Resources
resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: dashbaordName
  location: location
  tags: tags
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: datafactoryScope
                          }
                          name: 'PipelineFailedRuns'
                          aggregationType: 1
                          namespace: 'microsoft.datafactory/factories'
                          metricVisualization: {
                            displayName: 'Failed pipeline runs metrics'
                            resourceDisplayName: datafactoryName
                          }
                        }
                      ]
                      title: 'Count Failed activity runs metrics for ${datafactoryName}'
                      titleKind: 1
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                        disablePinning: true
                      }
                    }
                  }
                }
              }
            }
          }
          {
            position: {
              x: 6
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: datafactoryScope
                          }
                          name: 'PipelineSucceededRuns'
                          aggregationType: 1
                          namespace: 'microsoft.datafactory/factories'
                          metricVisualization: {
                            displayName: 'Succeeded pipeline runs metrics'
                            resourceDisplayName: datafactoryName
                          }
                        }
                      ]
                      title: 'Sum Succeeded pipeline runs metrics for ${datafactoryName}'
                      titleKind: 1
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                        disablePinning: true
                      }
                    }
                  }
                }
              }
            }
          }
        ]
      }
    ]
    metadata: {
      model: {}
    }
  }
}

// Outputs
