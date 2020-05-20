from unittest.mock import patch

import sys

from jinja2 import Environment, FileSystemLoader
from cfnlint.__main__ import main as cfnlint

import importlib.util
spec = importlib.util.spec_from_file_location("cfn_formatter", "../utils/cfn_formatter.py")
cfn_formatter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cfn_formatter)


def test_hit_substack_rendering(tmp_path):
    test_config = {
        "queues_config": {
            "queue1": {
                "instances": [
                    {"type": "c5.xlarge", "static_size": 1, "dynamic_size": 2, "spot_price": 1.5},
                    {"type": "c5.2xlarge", "static_size": 1, "dynamic_size": 0},
                ],
                "placement_group": "AUTO",
                "enable_efa": False,
                "disable_hyperthreading": False,
                "compute_type": "spot",
            },
            "queue2": {
                "instances": [{"type": "g3.8xlarge", "static_size": 0, "dynamic_size": 2}],
                "placement_group": None,
                "enable_efa": True,
                "disable_hyperthreading": True,
                "compute_type": "ondemand",
            },
        },
        "scaling_config": {"scaledown_idletime": 10},
    }

    env = Environment(loader=FileSystemLoader(".."))
    template = env.get_template("hit-substack.cfn.yaml")
    output_from_parsed_template = template.render(hit_config=test_config)
    rendered_file = tmp_path / "hit-substack.cfn.yaml"
    rendered_file.write_text(output_from_parsed_template)

    # Run cfn-lint
    cfn_lint_args = ["--info", str(rendered_file)]
    with patch.object(sys, 'argv', cfn_lint_args):
        assert cfnlint() == 0

    # Run format check
    assert cfn_formatter.check_formatting([str(rendered_file)], "yaml")
