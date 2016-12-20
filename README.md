# ecs-utils

Scripts to assist/automate AWS ECS usage



'update-ecs-service-task.bash

Shell Script used to update an ECS service whenever an image is pushed to ECR. It needs to be executed sending the following arguments: cluster service task_definition region.

Instructions:

1) Download the shell script update-ecs-service-task.bash

2) chmod a+x update-ecs-service-task.bash

3) ./update-ecs-service-task.bash cluster_name service_name task_definition_family region

   i.e.:

   ./update-ecs-service-task.bash dockerphp service_dockerphp1 task_dockerphp1 us-east-1
