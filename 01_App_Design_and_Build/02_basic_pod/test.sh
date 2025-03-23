#!/bin/bash

which kubectl 2>&1 > /dev/null || (echo "kubectl is not installed"; exit 1)
which jq      2>&1 > /dev/null || (echo "jq is not installed"; exit 1)

OUT=$(kubectl get pods -o json | jq '.items[] | select (.metadata.name=="my-hello-world")')
if [ -z "$OUT" ]; then
  echo "No pod named 'my-hello-world' is detected"
  exit 1
fi

if echo $OUT | jq '.spec.containers[0].image' | grep -q hello-world; then
  echo "Pod my-hello-world is running with the correct image"
else
  echo "Pod my-hello-world is not running with the correct image"
  exit 1
fi

if echo $OUT | jq '.spec.restartPolicy' | grep -q Never; then
  echo "Pod my-hello-world is running with correct restartPolicy"
else
  echo "Pod my-hello-world is not running with correct restartPolicy"
  exit 1
fi

if echo $OUT | jq '.status.containerStatuses[0].state.terminated.reason' | grep -q Completed; then
  echo "Pod my-hello-world has correct exit status"
else
  echo "Pod my-hello-world has incorrect exit status"
  exit 1
fi
