rm -fr fedora-flash.img*
CNAME=fedora-pi-builder-$RANDOM
docker rmi spin-pi-fedora-builder
docker build -t spin-pi-fedora-builder .
docker run -it --privileged=true --name $CNAME spin-pi-fedora-builder
docker cp $CNAME:/root/artifacts/fedora-flash.img .
docker rm $CNAME
docker rmi spin-pi-fedora-builder