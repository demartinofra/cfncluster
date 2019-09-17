# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance
# with the License. A copy of the License is located at
#
# http://aws.amazon.com/apache2.0/
#
# or in the "LICENSE.txt" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions and
# limitations under the License.
import logging
import re
import sys
import webbrowser

import boto3
from botocore.exceptions import ClientError

from pcluster import cfnconfig
from pcluster.commands import command
from pcluster.dcv.utils import DCV_CONNECT_SCRIPT
from pcluster.utils import get_stack_output_value, get_stack_param_value

LOGGER = logging.getLogger(__name__)


def _get_stack(args):
    stack = "parallelcluster-" + args.cluster_name
    config = cfnconfig.ParallelClusterConfig(args)
    cfn = boto3.client(
        "cloudformation",
        region_name=config.region,
        aws_access_key_id=config.aws_access_key_id,
        aws_secret_access_key=config.aws_secret_access_key,
    )
    try:
        stack_result = cfn.describe_stacks(StackName=stack).get("Stacks")[0]
        status = stack_result.get("StackStatus")
        valid_status = "CREATE_COMPLETE"

        if status != valid_status:
            LOGGER.error("Stack status: {0}. Can't connect until the status become {1}".format(status, valid_status))
            sys.exit(1)
        else:
            return stack_result
    except ClientError as e:
        LOGGER.critical(e.response.get("Error").get("Message"))
        sys.stdout.flush()
        sys.exit(1)


def _generate_ssh_command(commands):
    return " ".join(commands).split(" ")


def dcv_connect(args):
    args.command = None
    args.dryrun = None
    commands = []

    # Append ssh key
    if args.key_path:
        commands.append("-i {0}".format(args.key_path))

    # Prepare ssh command to execute in the master instance to activate DCV session
    stack_result = _get_stack(args)
    shared_dir = get_stack_param_value(stack_result["Parameters"], "SharedDir")
    command_to_execute = "{0} {1}".format(DCV_CONNECT_SCRIPT, shared_dir)
    commands.append(command_to_execute)
    ssh_command = _generate_ssh_command(commands)

    # Connect by ssh to the master instance and prepare DCV session
    master_ip = get_stack_output_value(stack_result["Outputs"], "MasterPublicIP")
    try:
        output = command(args, ssh_command, return_output=True).decode("utf-8").strip().split(" ")
        # At first ssh connection, the ssh command alerts it is adding the host to the known hosts list
        if re.search("Permanently added .* to the list of known hosts.", " ".join(output)):
            output = command(args, ssh_command, return_output=True).decode("utf-8").strip().split(" ")
        session_id, port, token = output
    except ValueError:
        LOGGER.error(
            "Something went wrong during DCV connection. Please try again. If the problem persists, "
            "please check the logs in the /var/log/parallelcluster/ folder of the master instance."
        )
        sys.exit(1)

    # Open web browser
    url = "https://{IP}:{PORT}?authToken={TOKEN}#{SESSION_ID}".format(
        IP=master_ip, PORT=port, TOKEN=token, SESSION_ID=session_id
    )
    try:
        webbrowser.open_new(url)
    except webbrowser.Error:
        LOGGER.info(
            "Unable to open the Web browser. "
            "Please use the following URL in your browser within 30 seconds:\n{0}".format(url)
        )
