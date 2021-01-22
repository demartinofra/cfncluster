namespace parallelcluster

@documentation("AWS Region")
string Region

@pattern("^[0-9]+\\.[0-9]+\\.[0-9]+$")
string Version

list Versions {
    member: Version
}

structure ConfigValidationMessage {
    @documentation("Id of the validator")
    id: String,
    @documentation("Type of the validator")
    type: String,
    @documentation("Validation level")
    level: ValidationLevel,
    @documentation("Validation message")
    message: String,
}

list ValidationMessages {
    member: ConfigValidationMessage
}

@enum([
    {name: "info", value: "INFO"},
    {name: "warning", value: "WARNING"},
    {name: "error", value: "ERROR"},
    {name: "critical", value: "CRITICAL"},
])
string ValidationLevel
