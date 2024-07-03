#/bin/bash

# Variables
RUN_DIR=`dirname -- "$0"` # Get directory of this bash script
VALUES_DIR=`realpath $RUN_DIR/../values` # Navigate to values dir using relative path & resolve

# Debug
#echo "$VALUES_DIR"

helm upgrade --install --values $VALUES_DIR/postgresql.yml pg-release oci://registry-1.docker.io/bitnamicharts/postgresql
