namespace parallelcluster

@http(method: "POST", uri: "/clusters", code: 202)
@tags(["Cluster CRUD"])
@documentation("Create a ParallelCluster managed cluster in a given region.")
operation CreateCluster {
    input: CreateClusterInput,
    output: CreateClusterOutput,
    errors: [
      InternalServiceException,
      CreateClusterBadRequestException,
      ConflictException,
      UnauthorizedClientError,
      LimitExceededException,
    ]
}

structure CreateClusterInput {
    @httpQuery("version")
    @documentation("ParallelCluster version to use when creating the cluster. This option will only be available in case the API has support for multiple ParallelCluster versions")
    version: Version,
    @httpQuery("suppressValidators")
    @documentation("Identifies one or more config validators to suppress. Format: ALL|id:$value|level:(info|error|warning)|type:$value")
    suppressValidators: SuppressValidatorsList,
    @httpQuery("validationFailureLevel")
    @documentation("Min validation level that will cause the creation to fail. Defaults to 'error'.")
    validationFailureLevel: ValidationLevel,
    @httpQuery("dryrun")
    @documentation("Only perform request validation without creating any resource. It can be used to validate the cluster configuration. Response code: 200")
    dryrun: Boolean,

    @required
    name: ClusterId,
    @required
    region: Region,
    @required
    clusterConfiguration: ClusterConfigurationData,
}

structure CreateClusterOutput {
    @required
    cluster: ClusterInfoSummary,
    @required
    @documentation("List of messages collected during cluster config validation whose level is lower than the validationFailureLevel set by the user")
    validationMessages: ValidationMessages
}

list SuppressValidatorsList {
   member: SuppressValidatorExpression
}

string SuppressValidatorExpression
