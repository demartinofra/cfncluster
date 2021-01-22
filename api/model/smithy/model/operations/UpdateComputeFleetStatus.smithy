namespace parallelcluster

@http(method: "PATCH", uri: "/clusters/{clusterId}/computefleet/status", code: 202)
@tags(["Cluster ComputeFleet"])
@documentation("Update the status of the cluster compute fleet.")
operation UpdateComputeFleetStatus {
    input: UpdateComputeFleetStatusInput,
    output: UpdateComputeFleetStatusOutput,
    errors: [
        InternalServiceException,
        BadRequestException,
        NotFoundException,
        UnauthorizedClientError,
        LimitExceededException,
    ]
}

structure UpdateComputeFleetStatusInput {
    @httpLabel
    @required
    clusterId: ClusterId,

    @httpQuery("region")
    @required
    region: Region,

    @required
    status: ComputeFleetStatusInput,

    @httpHeader("x-parallelcluster-version")
    @documentation("Forces a specific ParallelCluster version to be used when handling this request.")
    version: Version,
}

structure UpdateComputeFleetStatusOutput {
    @required
    status: ComputeFleetStatus,
}

@enum([
    {value: "START_REQUESTED"},
    {value: "STOP_REQUESTED"},
    {value: "ENABLED"},  // works only with AWS Batch
    {value: "DISABLED"},  // works only with AWS Batch
])
string ComputeFleetStatusInput
