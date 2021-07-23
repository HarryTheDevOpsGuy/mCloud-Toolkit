FROM ubuntu:latest
ARG TERRAFORM_VERSION=0.15.5
ARG USERNAME=harry
ARG PASSWORD=harry

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y openssh-server sudo vim awscli ansible net-tools curl unzip bsdmainutils git gcc software-properties-common shc gettext-base sshpass jq

RUN useradd -rm -d /home/${USERNAME} -s /bin/bash -g root -G sudo -u 1000 ${USERNAME}
RUN  echo "${USERNAME}:${PASSWORD}" | chpasswd
# No password required
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

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

#RUN yes | unminimize
RUN curl -L "https://github.com/HarryTheDevOpsGuy/msend/raw/master/$(uname -p)/msend" -o /usr/bin/msend  && \
	curl -L "https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack" -o /usr/bin/mslack && \
	curl -L "https://github.com/HarryTheDevOpsGuy/mCert/raw/master/$(uname -p)/mcert" -o /usr/bin/mcert && \
	curl -L "https://github.com/HarryTheDevOpsGuy/mWeb24x7/raw/master/$(uname -p)/mweb24x7" -o /usr/bin/mweb24x7 && \
	curl -L https://github.com/mikefarah/yq/releases/download/v4.2.0/yq_linux_amd64 -o /usr/bin/yq && \
        chmod +x /usr/bin/msend /usr/bin/mslack /usr/bin/mcert /usr/bin/yq

RUN rm -rf /var/lib/apt/lists/*  terraform_${TERRAFORM_VERSION}_linux_amd64.zip



RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
