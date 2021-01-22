namespace parallelcluster

@readonly
@http(method: "GET", uri: "/amis", code: 200)
@tags(["AMI"])
@documentation("Describe ParallelCluster AMIs.")
@paginated
operation DescribeOfficialAmis {
    input: DescribeOfficialAmisInput,
    output: DescribeOfficialAmisOutput,
    errors: [
        InternalServiceException,
        BadRequestException,
        UnauthorizedClientError,
        LimitExceededException,
    ]
}

structure DescribeOfficialAmisInput {
    @httpQuery("version")
    @documentation("ParallelCluster version to retrieve AMIs for.")
    version: Version,
    @httpQuery("region")
    @required
    region: Region,
    @httpQuery("os")
    @documentation("Filter by OS distribution")
    os: String,
    @httpQuery("architecture")
    @documentation("Filter by architecture")
    architecture: String,
    @httpQuery("nextToken")
    nextToken: String,
    @httpQuery("pageSize")
    pageSize: Integer,
    @httpHeader("x-parallelcluster-version")
    @documentation("Forces a specific ParallelCluster version to be used when handling this request.")
    version: Version,
}

structure DescribeOfficialAmisOutput {
    nextToken: String,

    @required
    items: AmisInfo,
}

list AmisInfo {
    member: AmiInfo
}

structure AmiInfo {
    @required
    architecture: String,
    @required
    imageId: String,
    @required
    name: String,
    @required
    os: String,
}
