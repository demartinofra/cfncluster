namespace parallelcluster

@readonly
@http(method: "GET", uri: "/clusters/{clusterId}/configurations/{configVersion}", code: 200)
@tags(["Cluster Configuration"])
@documentation("Retrieve a specific cluster configuration version.")
operation DescribeClusterConfiguration {
    input: DescribeClusterConfigurationInput,
    output: DescribeClusterConfigurationOutput,
    errors: [
        InternalServiceException,
        BadRequestException,
        NotFoundException,
        UnauthorizedClientError,
        LimitExceededException,
    ]
}

structure DescribeClusterConfigurationInput {
    @httpLabel
    @required
    clusterId: ClusterId,
    @httpLabel
    @required
    @documentation("This can be either the version of the config to retrieve or the 'latest' keyword to fetch the latest configuration version.")
    configVersion: String,
    @httpQuery("region")
    @required
    region: Region,
    @httpHeader("x-parallelcluster-version")
    @documentation("Forces a specific ParallelCluster version to be used when handling this request.")
    version: Version,
}

structure DescribeClusterConfigurationOutput {
    @required
    clusterConfiguration: ClusterConfigurationStructure
}
