#!/bin/bash
NODE_NAME=$(kubectl get nodes --no-headers | grep -v "control-plane" | awk 'NR==1 {print $1}')
if [ -z "$NODE_NAME" ]; then
  exit 1
fi
kubectl cordon $NODE_NAME &>/dev/null
POD_NAME=$(kubectl -n monitoring get pods -l app.kubernetes.io/name=node-exporter --field-selector spec.nodeName=$NODE_NAME -o jsonpath='{.items[0].metadata.name}')
if [ -z "$POD_NAME" ]; then
  exit 1
fi
kubectl -n monitoring delete pod $POD_NAME &>/dev/null
