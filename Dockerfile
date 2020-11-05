FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
        && apt-get install -y --no-install-recommends jq \
        git \
        zip \
        unzip \
        nodejs \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        libssl1.0 \
        python3.8 \
        libffi-dev \
        openssl \
        wget \
        apt-transport-https

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
        && dpkg -i packages-microsoft-prod.deb \
        && curl -Ls -o azure-cli_xenial_all.deb https://aka.ms/InstallAzureCliXenialEdge \
        && dpkg -i azure-cli_xenial_all.deb \
        && apt-get update \
        && apt-get install software-properties-common \
        && add-apt-repository universe \
        && apt-get install -y powershell

RUN add-apt-repository ppa:git-core/ppa -y \
        && apt-get update \
        && apt-get install git -y \
        && git --version
RUN apt-get -y install gnupg2 \
        && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey \
        && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) \
        stable" \
        && apt-get update \
        && apt-get -y install docker-ce    

WORKDIR /azp
COPY ./AzurePowerShell.ps1 .

RUN pwsh -File AzurePowerShell.ps1
COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]