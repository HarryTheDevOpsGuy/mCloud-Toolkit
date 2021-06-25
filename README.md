#### mCloud Toolkit

docker build --build-arg TERRAFORM_VERSION=0.15.5 -t mcloud:v1  .

docker run -itd --name mcloud --hostname mcloud-toolkit harry97/mcloud-toolkit:latest
