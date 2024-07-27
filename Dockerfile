FROM ubuntu:latest AS pull-binary
SHELL ["/bin/bash", "-c"]
RUN apt update -y && apt install -y curl wget
RUN LATEST_TAG="$(curl -s https://api.github.com/repos/syncthing/relaysrv/releases/latest | grep -oE 'tag/.*' | awk -F/ '{print $NF}' |  head -c -3)"; \
    FILE_NAME_NO_EXT=strelaysrv-linux-amd64-"$LATEST_TAG"; \
    wget https://github.com/syncthing/relaysrv/releases/download/"$LATEST_TAG"/"$FILE_NAME_NO_EXT".tar.gz; \
    tar -xf "$FILE_NAME_NO_EXT".tar.gz; \
    mv "$FILE_NAME_NO_EXT" relaysrv;

FROM alpine:latest
COPY --from=pull-binary /relaysrv/strelaysrv /usr/bin/strelaysrv
VOLUME ["/keys"]
EXPOSE 22067/tcp 22070/tcp

ENTRYPOINT ["strelaysrv", "-keys=/keys"]