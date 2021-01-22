namespace parallelcluster

@readonly
@http(method: "GET", uri: "/versions", code: 200)
@tags(["ParallelCluster Versions"])
@documentation("Describe the supported ParallelCluster versions.")
operation DescribeParallelClusterVersions {
    input: DescribeParallelClusterVersionsInput,
    output: DescribeParallelClusterVersionsOutput,
    errors: [
        InternalServiceException,
        BadRequestException,
        UnauthorizedClientError,
        LimitExceededException,
    ]
}

structure DescribeParallelClusterVersionsInput {
}

structure DescribeParallelClusterVersionsOutput {
    @required
    @documentation("ParallelCluster versions supported by the API.")
    enabledParallelClusterVersions: Versions,
    @required
    @documentation("Default version used when version is not specified in the request.")
    defaultParallelClusterVersion: Version,
}
