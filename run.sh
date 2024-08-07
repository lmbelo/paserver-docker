#!/usr/bin/env bash

echo "PAServer Password: securepass"
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --platform linux/amd64 --name paserver -it -e PA_SERVER_PASSWORD=securepass -p 64211:64211 radstudio/paserver:latest
