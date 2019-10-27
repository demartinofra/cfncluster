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


def get_enabled_tests(config):
    enabled_test_suites = config.get("test-suites")
    enabled_tests = set()
    for suite, tests in enabled_test_suites.items():
        for test in tests.keys():
            enabled_tests.add("{0}/{1}".format(suite, test))

    return enabled_tests


def get_all_regions(config):
    regions = set()
    for tests in config.get("test-suites").values():
        for dimensions in tests.values():
            regions.update(dimensions["dimensions"].get("regions", []))
    return regions
