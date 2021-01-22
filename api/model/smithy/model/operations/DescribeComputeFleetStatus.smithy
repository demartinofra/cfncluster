namespace parallelcluster

@readonly
@http(method: "GET", uri: "/clusters/{clusterId}/computefleet/status", code: 200)
@tags(["Cluster ComputeFleet"])
@documentation("Describe the status of the compute fleet")
operation DescribeComputeFleetStatus {
    input: DescribeComputeFleetStatusInput,
    output: DescribeComputeFleetStatusOutput,
    errors: [
        InternalServiceException,
        BadRequestException,
        NotFoundException,
        UnauthorizedClientError,
        LimitExceededException,
    ]
}

structure DescribeComputeFleetStatusInput {
    @httpLabel
    @required
    clusterId: ClusterId,
    @httpQuery("region")
    @required
    region: Region,
    @httpHeader("x-parallelcluster-version")
    @documentation("Forces a specific ParallelCluster version to be used when handling this request.")
    version: Version,
}

structure DescribeComputeFleetStatusOutput {
    @required
    status: ComputeFleetStatus,
}
