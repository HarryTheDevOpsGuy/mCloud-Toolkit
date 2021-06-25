FROM ubuntu:latest
ARG TERRAFORM_VERSION=0.15.5
ARG USERNAME=harry
ARG PASSWORD=harry

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y openssh-server sudo vim awscli ansible net-tools curl unzip

RUN useradd -rm -d /home/${USERNAME} -s /bin/bash -g root -G sudo -u 1000 ${USERNAME}
RUN  echo "${USERNAME}:${PASSWORD}" | chpasswd

################################
# Install Terraform
################################

# Download terraform for linux
RUN wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN \
	# Unzip
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	# Move to local bin
	mv terraform /usr/local/bin/ && \
	# Make it executable
	chmod +x /usr/local/bin/terraform && \
	# Check that it's installed
	terraform --version

RUN rm -rf /var/lib/apt/lists/*


RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
