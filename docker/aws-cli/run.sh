#!/bin/bash

run () {
  ${RUN_DOCKER} -it \
    -e AWS_REGION \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_ACCOUNT \
    -e AWS_ROLE \
    -e AWS_ROLE_ARN \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SECURITY_TOKEN \
    -e AWS_SESSION_TOKEN \
    -e AWS_SESSION_EXPIRES \
    "${CONTAINER_NAME}" /.local/lib/aws/bin/aws --region=us-east-1 ecs "${CMD}"
}
