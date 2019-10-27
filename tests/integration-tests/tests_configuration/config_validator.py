# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
# http://aws.amazon.com/apache2.0/
#
# or in the "LICENSE.txt" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.
import logging
import os
import sys

from pykwalify.core import Core
from tests_configuration.config_renderer import dump_rendered_config_file, read_config_file

CONFIG_SCHEMA = "tests_configuration/config_schema.yaml"


def assert_valid_config(config):
    _validate_against_schema(config)
    _check_declared_tests_exist(config)


def _validate_against_schema(config):
    try:
        c = Core(source_data=config, schema_files=[CONFIG_SCHEMA])
        c.validate(raise_exception=True)
    except Exception as e:
        logging.error("Failed when validating schema: %s", e)
        logging.info("Dumping rendered template:\n%s", dump_rendered_config_file(config))
        raise


def _check_declared_tests_exist(config):
    # TODO
    pass


if __name__ == "__main__":
    logging.basicConfig(format="%(levelname)s - %(message)s", level=logging.DEBUG)
    logging.getLogger("pykwalify").setLevel(logging.INFO)
    if len(sys.argv) != 2:
        logging.error("You need to specify the config dir or config file to validate")
        exit(1)

    if os.path.isfile(sys.argv[1]):
        assert_valid_config(read_config_file(sys.argv[1]))
    else:
        for filename in os.listdir(sys.argv[1]):
            if filename.endswith(".yaml.jinja2"):
                assert_valid_config(read_config_file(f"{sys.argv[1]}{filename}"))
