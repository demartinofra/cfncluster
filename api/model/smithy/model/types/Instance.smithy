namespace parallelcluster

@enum([
    {value: "pending"},
    {value: "running"},
    {value: "shutting-down"},
    {value: "terminated"},
    {value: "stopping"},
    {value: "stopped"},
])
string InstanceState

@enum([
    {value: "HEAD"},
    {value: "COMPUTE"},
])
string NodeType

structure EC2Instance {
    @required
    instanceId: String,
    @required
    instanceType: String,
    @required
    launchTime: String,
    @required
    privateIpAddress: String, // only primary?
    publicIpAddress: String,
    @required
    state: InstanceState
}
