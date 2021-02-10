#!/bin/bash

# tests.sh
# Any tests put in this file will get run on deployment

# Check if test url is running
make healthz

if [ -z "$?" ]; then
  echo "Exiting tests as site is not running"
  exit 0
fi

run_e2e=$(echo docker-compose run --rm --name cypress-e2e e2e)

# Cypress info
$run_e2e npx cypress info

# All tests
#echo "Running all cypress tests"
#docker-compose run --rm --name cypress-e2e e2e

# Running a specific test suite
$run_e2e npx cypress run --headless --spec "cypress/integration/recipes-spec.js"
