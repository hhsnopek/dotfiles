#!/bin/sh
if [[ -e package.json ]]; then # javascript linting
  if [[ "$(npm run-script)" =~ "test" ]]; then
    npm run-script test
  fi
fi
