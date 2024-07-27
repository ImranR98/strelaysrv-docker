LATEST_TAG="$(curl -s https://api.github.com/repos/syncthing/relaysrv/releases/latest | grep -oE 'tag/.*' | awk -F/ '{print $NF}' |  head -c -3)"

docker build . -t imranrdev/strelaysrv-docker
docker tag imranrdev/strelaysrv-docker:latest imranrdev/strelaysrv-docker:"$LATEST_TAG"

# docker push --all-tags imranrdev/strelaysrv-docker