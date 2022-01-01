echo "Enter QA or Dev for image type: "
read type
image_type=$(echo $type | tr '[:upper:]' '[:lower:]')
echo
docker build -f deployments/Dockerfile -t <service> .
#RELEASE=$(docker run <service> python -c "from <service> import release_info; print(release_info)")
DOCKER_VERSION=$(docker image inspect --format='{{.Config.Labels.version}}' <service>)
PACKAGE_VERSION=${RELEASE}.${DOCKER_VERSION}.${image_type}
echo $PACKAGE_VERSION
#
#$(aws ecr get-login --no-include-email --region us-east-1)
#docker tag service:latest <ecr-hub>/<service>:$PACKAGE_VERSION
#docker push <ecr-hub>/<service>:$PACKAGE_VERSION
#
#(git tag $PACKAGE_VERSION 2>/dev/null && git push origin $PACKAGE_VERSION) || true