#Run this on the worker node that will schedule the pod and then deploy the scenario

for i in {1..110}; do
    docker pull nginx:latest >/dev/null 2>&1
done

