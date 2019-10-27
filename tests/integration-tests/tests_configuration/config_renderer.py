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

import yaml
from jinja2 import Environment, FileSystemLoader


def read_config_file(config_file):
    logging.info("Parsing config file: %s", config_file)
    rendered_config = _render_config_file(config_file)
    try:
        return yaml.load(rendered_config, Loader=yaml.SafeLoader)
    except Exception:
        logging.exception("Failed when reading config file %s", config_file)
        logging.info("Dumping rendered template:\n%s", rendered_config)
        raise


def dump_rendered_config_file(config):
    return yaml.dump(config, default_flow_style=False)


def _render_config_file(config_file):
    # Keep a cache of rendered configs so that rendered values are consistent across multiple invocations
    if not hasattr(_render_config_file, "rendered_configs"):
        _render_config_file.rendered_configs = {}
    if config_file not in _render_config_file.rendered_configs:
        try:
            config_dir = os.path.dirname(config_file)
            config_name = os.path.basename(config_file)
            file_loader = FileSystemLoader(config_dir)
            _render_config_file.rendered_configs[config_file] = (
                Environment(loader=file_loader).get_template(config_name).render()
            )
        except Exception:
            logging.error("Failed when rendering config file %s", config_file)
            raise

    return _render_config_file.rendered_configs[config_file]
