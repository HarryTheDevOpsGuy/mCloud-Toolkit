FROM ubuntu:22.04
ARG TERRAFORM_VERSION=1.5.7
ARG USERNAME=harry
ARG PASSWORD=harry

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && \
	apt-get install -y software-properties-common && \
	add-apt-repository --yes --update ppa:ansible/ansible

	
RUN apt update && apt install -y openssh-server sudo vim awscli ansible net-tools curl unzip bsdmainutils git gcc software-properties-common shc gettext-base sshpass jq python python-pip

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
	unzip -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d "/usr/bin" 

#RUN yes | unminimize
RUN curl -L "https://github.com/HarryTheDevOpsGuy/msend/raw/master/$(uname -p)/msend" -o /usr/bin/msend  && \
	curl -L "https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack" -o /usr/bin/mslack && \
	curl -L "https://github.com/HarryTheDevOpsGuy/mCert/raw/master/$(uname -p)/mcert" -o /usr/bin/mcert && \
	curl -L "https://github.com/HarryTheDevOpsGuy/mWeb24x7/raw/master/$(uname -p)/mweb24x7" -o /usr/bin/mweb24x7 && \
	curl -L https://github.com/mikefarah/yq/releases/download/v4.35.1/yq_linux_amd64 -o /usr/bin/yq && \
	curl -L "https://github.com/HarryTheDevOpsGuy/msend/raw/master/$(uname -p)/tools/htmlgen" -o /usr/bin/htmlgen && \
    chmod +x /usr/bin/msend /usr/bin/mslack /usr/bin/mcert /usr/bin/yq /usr/bin/mweb24x7 /usr/bin/htmlgen /usr/bin/terraform 

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt 
RUN rm -rf /var/lib/apt/lists/*  terraform_${TERRAFORM_VERSION}_linux_amd64.zip *.zip

RUN python --version && pip freeze 


RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
