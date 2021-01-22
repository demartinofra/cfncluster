#!/usr/bin/env bash
set -ex

pushd smithy && gradle build --rerun-tasks && popd
cp smithy/build/smithyprojections/smithy/source/openapi/ParallelCluster.openapi.json openapi/
