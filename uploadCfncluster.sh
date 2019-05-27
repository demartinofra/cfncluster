#!/bin/bash
 
 #TODO better have params declared and not positional
 
 error_exit() {
   echo "$1"
   exit 1
 }
 
_bucket="cfncluster-fdm-build-artifacts-us-east-1"
_cfnclusterDir="."
_profile="fdm-isengard"
_region="us-east-1"

if [ -z "${_bucket}" ]; then
    error_exit "Bucket not specified"
fi

if [ -z "${_cfnclusterDir}" ]; then
    error_exit "CfnCluster dir not specified"
fi

if [ -z "${AWS_PROFILE}" ] && [ -z "${_profile}" ]; then
    error_exit "AWS profile not specified"
elif [ -n "${_profile}" ]; then
    _profile="--profile ${_profile}"
fi

if [ -z "${_region}" ]; then
    echo "Region not specified, using default us-east-1"
    _region="us-east-1"
fi

aws ${_profile} s3api head-bucket --bucket "${_bucket}" --region "${_region}"
if [ $? -ne 0 ]; then
  echo "Bucket ${_bucket} do not exist, trying to create it"
  aws ${_profile} s3api create-bucket --bucket "${_bucket}" --region "${_region}"
  if [ $? -ne 0 ]; then
    error_exit "Unable to create bucket ${_bucket}"
  fi
fi
 
_version=$(grep "VERSION = \"" ${_cfnclusterDir}/cli/setup.py |awk '{print $3}'| tr -d \")
if [ -z "${_version}" ]; then
  error_exit "Unable to detect cfncluster version, are you in the right directory?"
fi
echo "Detected version ${_version}"
 
 # Create node archive tarball
 _cwd=$(pwd)
 pushd "${_nodeDir}" > /dev/null
 _stashName=$(git stash create)
 
git archive --format tar --prefix="aws-parallelcluster-${_version}/" "${_stashName:-HEAD}" | gzip > "${_cwd}/aws-parallelcluster-${_version}.tgz"


 popd > /dev/null

 aws ${_profile} --region "${_region}" s3 cp --acl public-read aws-parallelcluster-${_version}.tgz s3://${_bucket}/cli/aws-parallelcluster-${_version}.tgz || error_exit 'Failed to push node to S3'

 _bucket_region=$(aws ${_profile} s3api get-bucket-location --bucket ${_bucket} --output text)
 
 echo ""
 echo "Add the following variable to the cfcncluster config file, under the [cluster ...] section"
 echo "extra_json = { \"cfncluster\" : { \"custom_awsbatchcli_package\" : \"https://s3.${_bucket_region}.amazonaws.com/${_bucket}/cli/aws-parallelcluster-${_version}.tgz\" } }"
