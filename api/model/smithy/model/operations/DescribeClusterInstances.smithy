namespace parallelcluster

@http(method: "GET", uri: "/clusters/{clusterId}/instances", code: 200)
@tags(["Cluster Instances"])
@paginated
@readonly
@documentation("Describe the instances belonging to a given cluster.")
operation DescribeClusterInstances {
    input: DescribeClusterInstancesInput,
    output: DescribeClusterInstancesOutput,
    errors: [
        InternalServiceException,
        BadRequestException,
        NotFoundException,
        UnauthorizedClientError,
        LimitExceededException,
    ]
}

structure DescribeClusterInstancesInput {
    @httpLabel
    @required
    clusterId: ClusterId,
    @httpQuery("region")
    @required
    region: Region,
    @httpQuery("nextToken")
    nextToken: String,
    @httpQuery("pageSize")
    pageSize: Integer,
    @httpQuery("nodeType")
    nodeType: String,
    @httpQuery("queueName")
    queueName: String,
    @httpHeader("x-parallelcluster-version")
    @documentation("Forces a specific ParallelCluster version to be used when handling this request.")
    version: Version,
}

structure DescribeClusterInstancesOutput {
    nextToken: String,
    @required
    instances: InstanceSummaries,
}

list InstanceSummaries {
    member: EC2Instance
}
