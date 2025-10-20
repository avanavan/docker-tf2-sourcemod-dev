# Docker-TF2-Sourcemod-Dev
This dockerfile will build the latest `Team Fortress 2` development environment for `Sourcemod` and `Metamod`.
Mainly use it for myself, the build for sourcemod and metamod are development build

The docker image will symlink the file and directories on top of the container from `tf/`.

> [!IMPORTANT]  
> You will also need to include your own `/cfg/server.cfg` inside the external volume, I've attached an example for template.

Example of deployment:
```docker
docker run -dit \
            --name dev \
            --net=host \
            -v $(pwd)/external:/external \
            ghcr.io/avanavan/docker-tf2-sourcemod-dev:latest
```

**Removed plugins:**
- nextmap.smx
- funcommands.smx
- funvotes.smx