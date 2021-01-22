namespace parallelcluster

@paginated
@readonly
@http(method: "GET", uri: "/clusters/{clusterId}/configurations", code: 200)
@tags(["Cluster Configuration"])
@documentation("Retrieve the history of cluster configurations for a given cluster")
operation ListClusterConfigurations {
    input: ListClusterConfigurationsInput,
    output: ListClusterConfigurationsOutput,
    errors: [
        InternalServiceException,
        BadRequestException,
        UnauthorizedClientError,
        NotFoundException,
        LimitExceededException,
    ]
}

structure ListClusterConfigurationsInput {
    @httpLabel
    @required
    clusterId: ClusterId,
    @httpQuery("region")
    @documentation("List clusters deployed to a given AWS Region")
    @required
    region: Region,
    @httpQuery("nextToken")
    nextToken: String,
    @httpQuery("pageSize")
    pageSize: Integer,
    @httpHeader("x-parallelcluster-version")
    @documentation("Forces a specific ParallelCluster version to be used when handling this request.")
    version: Version,
}

structure ListClusterConfigurationsOutput {
    nextToken: String,

    @required
    items: ClusterConfigurationSummaries,
}

