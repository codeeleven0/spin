FROM --platform=linux/arm64 debian:latest AS fedora-build
WORKDIR /root/
RUN apt-get update && apt-get install -y xz-utils build-essential sudo wget git tar dosfstools e2fsprogs parted squashfs-tools bash
COPY . .
CMD [ "/root/spin-run-container" ]