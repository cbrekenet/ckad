#!/bin/bash

which -s podman || (echo "podman is not installed"; exit 1)
which -s go || (echo "go is not installed"; exit 1)
which -s jq || (echo "jq is not installed"; exit 1)
which -s curl || (echo "curl is not installed"; exit 1)

OUT=$(podman ps --format json | jq '.[] | select(.Names.[0]=="hello-world")')
if [ -z "$OUT" ]; then
  echo "Container hello-world is not running"
  exit 1
fi

if echo $OUT | jq '.Image' | grep -q :ckad; then
  echo "Container hello-world is running with the correct image"
else
  echo "Container hello-world is not running with the correct image"
  exit 1
fi

OUT=$(curl -s http://localhost:9000)
if [ "$OUT" == "Hello World" ]; then
  echo "Port 9000 is open and responding correctly"
else
  echo "Test failed"
  exit 1
fi

