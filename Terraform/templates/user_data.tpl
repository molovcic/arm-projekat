#!/bin/bash

echo "Configuring ECS agent"
cat <<'EOF' | sudo tee /etc/ecs/ecs.config
ECS_CLUSTER=${cluster_name}
ECS_CONTAINER_INSTANCE_PROPAGATE_TAGS_FROM=ec2_instance
EOF
