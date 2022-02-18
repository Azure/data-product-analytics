// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

// Parameters
param location string
param dashbaordName string
param tags object
param datafactoryScope string
param datafactoryName string
param synapseScope string
param synapseName string
param processingService string

// Resources

resource adfdashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = if (processingService == 'dataFactory'){
  name: 'adf-${dashbaordName}'
  location: location
  tags: tags
    properties  : {
      lenses  : [
        {
              order  : 0  
              parts  : [
                {
                      position  : {
                          x  : 0  
                          y  : 0  
                          rowSpan  : 4  
                          colSpan  : 6
                    }  
                      metadata  : {
                          inputs  : [
                            {
                              name: 'options'
                              isOptional: true
                            }
                            {
                              name: 'sharedTimeRange'
                              isOptional: true
                            }
                        ]  
                          type  : 'Extension/HubsExtension/PartType/MarkdownPart'
                          settings  : {
                              content  : {
                                options: {
                                 chart: {
                                   metrics: [
                                     {
                                       resourceMetadata: {
                                          id : datafactoryScope
                                       }
                                        name :  'PipelineFailedRuns' 
                                        aggregationType : 1
                                        namespace :  'microsoft.datafactory/factories' 
                                        metricVisualization : {
                                          displayName :  'Failed pipeline runs metrics' 
                                          resourceDisplayName : datafactoryName
                                       }
                                     }
                                   ]
                                    title :  'Count Failed activity runs metrics for ${datafactoryName}' 
                                    titleKind : 1
                                    visualization : {
                                      chartType : 2
                                      legendVisualization : {
                                        isVisible : true
                                        position : 2
                                        hideSubtitle : false
                                     }
                                      axisVisualization : {
                                        x : {
                                          isVisible : true
                                          axisType : 2
                                       }
                                        y : {
                                          isVisible : true
                                          axisType : 1
                                       }
                                     }
                                      disablePinning : true
                                   }
                                 }
                               }
                             }
                        }
                    }
                }
                {
                  position  : {
                      x  : 6  
                      y  : 0  
                      rowSpan  : 4  
                      colSpan  : 6
                }  
                  metadata  : {
                      inputs  : [
                        {
                          name: 'options'
                          isOptional: true
                        }
                        {
                          name: 'sharedTimeRange'
                          isOptional: true
                        }
                    ]  
                      type  :   'Extension/HubsExtension/PartType/MarkdownPart'    
                      settings  : {
                          content  : {
                            options: {
                             chart: {
                               metrics: [
                                 {
                                   resourceMetadata: {
                                      id : datafactoryScope
                                   }
                                    name :  'PipelineSucceededRuns' 
                                    aggregationType : 1
                                    namespace :  'microsoft.datafactory/factories' 
                                    metricVisualization : {
                                      displayName :  'Succeeded pipeline runs metrics' 
                                      resourceDisplayName : datafactoryName
                                   }
                                 }
                               ]
                                title :  'Sum Succeeded pipeline runs metrics for ${datafactoryName}' 
                                titleKind : 1
                                visualization : {
                                  chartType : 2
                                  legendVisualization : {
                                    isVisible : true
                                    position : 2
                                    hideSubtitle : false
                                 }
                                  axisVisualization : {
                                    x : {
                                      isVisible : true
                                      axisType : 2
                                   }
                                    y : {
                                      isVisible : true
                                      axisType : 1
                                   }
                                 }
                                  disablePinning : true
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
      metadata  : {
          model  : {}
    }
}
}

resource synapsedashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = if (processingService == 'synapse'){
  name: 'synapse-${dashbaordName}'
  location: location
  tags: tags
    properties  : {
      lenses  : [
        {
              order  : 0  
              parts  : [
                {
                      position  : {
                          x  : 0  
                          y  : 0  
                          rowSpan  : 4  
                          colSpan  : 6
                    }  
                      metadata  : {
                          inputs  : [
                            {
                              name: 'options'
                              isOptional: true
                            }
                            {
                              name: 'sharedTimeRange'
                              isOptional: true
                            }
                        ]  
                          type  : 'Extension/HubsExtension/PartType/MarkdownPart'
                          settings  : {
                              content  : {
                                options: {
                                 chart: {
                                   metrics: [
                                     {
                                       resourceMetadata: {
                                          id : synapseScope
                                       }
                                        name :  'PipelineFailedRuns' 
                                        aggregationType : 1
                                        namespace :  'Microsoft.Synapse/workspaces' 
                                        metricVisualization : {
                                          displayName :  'Failed integration pipeline runs metrics' 
                                          resourceDisplayName : synapseName
                                       }
                                     }
                                   ]
                                    title :  'Count Failed integration activity runs metrics for ${synapseName}' 
                                    titleKind : 1
                                    visualization : {
                                      chartType : 2
                                      legendVisualization : {
                                        isVisible : true
                                        position : 2
                                        hideSubtitle : false
                                     }
                                      axisVisualization : {
                                        x : {
                                          isVisible : true
                                          axisType : 2
                                       }
                                        y : {
                                          isVisible : true
                                          axisType : 1
                                       }
                                     }
                                      disablePinning : true
                                   }
                                 }
                               }
                             }
                        }
                    }
                }
                {
                  position  : {
                      x  : 6  
                      y  : 0  
                      rowSpan  : 4  
                      colSpan  : 6
                }  
                  metadata  : {
                      inputs  : [
                        {
                          name: 'options'
                          isOptional: true
                        }
                        {
                          name: 'sharedTimeRange'
                          isOptional: true
                        }
                    ]  
                      type  :   'Extension/HubsExtension/PartType/MarkdownPart'    
                      settings  : {
                          content  : {
                            options: {
                             chart: {
                               metrics: [
                                 {
                                   resourceMetadata: {
                                      id : synapseScope
                                   }
                                    name :  'IntegrationPipelineSucceededRuns' 
                                    aggregationType : 1
                                    namespace :  'Microsoft.Synapse/workspaces' 
                                    metricVisualization : {
                                      displayName :  'Succeeded integration pipeline runs metrics' 
                                      resourceDisplayName : synapseName
                                   }
                                 }
                               ]
                                title :  'Sum Succeeded pipeline runs metrics for ${synapseName}' 
                                titleKind : 1
                                visualization : {
                                  chartType : 2
                                  legendVisualization : {
                                    isVisible : true
                                    position : 2
                                    hideSubtitle : false
                                 }
                                  axisVisualization : {
                                    x : {
                                      isVisible : true
                                      axisType : 2
                                   }
                                    y : {
                                      isVisible : true
                                      axisType : 1
                                   }
                                 }
                                  disablePinning : true
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
      metadata  : {
          model  : {}
    }
}
}

// Outputs
