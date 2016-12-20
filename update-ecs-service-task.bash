#!/bin/bash

#$1 cluster
#$2 service
#$3 task_definition

CLUSTER=$1
SERVICE=$2
TASK_DEFINITION=$3
REGION=$4

ERR_MSG="Invalid execution. Ensure all arguments are informed. (cluster service task_definition region)"

echo "Validating input arguments..."

if [ ! $# -eq 4 ]; then
    echo $ERR_MSG
    exit 1
fi

echo "describing task definition $TASK_DEFINITION..."

OUTPUT=$(aws ecs describe-task-definition --task-definition $TASK_DEFINITION --region $REGION --query "taskDefinition.containerDefinitions")

if [ $? -ne 0 ]; then
    echo "Error during describe-task-definition. Review arguments."
    exit 1
fi

CONTENTS="{ \"containerDefinitions\": $OUTPUT, \"family\": \"$TASK_DEFINITION\"}"
echo $CONTENTS > ./my_task_container_definition_details.json

echo "registering a new task revision for $TASK_DEFINITION..."

REVISION=$(aws ecs register-task-definition --cli-input-json file://my_task_container_definition_details.json --family $TASK_DEFINITION --region $REGION --query "taskDefinition.revision")

if [ $? -ne 0 ]; then
    echo "Error during register-task-definition. Review arguments."
    exit 1
fi

echo "Updating cluster $CLUSTER service $SERVICE with task definition $TASK_DEFINITION:$REVISION..."

OUTPUT=$(aws ecs update-service --cluster $CLUSTER --service $SERVICE --task-definition $TASK_DEFINITION:$REVISION --region $REGION)

if [ $? -ne 0 ]; then
    echo "Error during update-service. Review arguments."
    exit 1
fi

echo "New Task definition has been requested."
echo " Cluster : $CLUSTER"
echo " Service : $SERVICE"
echo " Task    : $TASK_DEFINITION"
echo " Revision: $REVISION"

exit 0