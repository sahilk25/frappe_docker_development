# Frappe Bench Dockerfile
FROM debian:buster-slim

ENV NODE_VERSION=15
ARG GIT_REPO=https://github.com/frappe/bench.git
ARG GIT_BRANCH=develop
RUN apt-get update -y && apt-get install curl -y
LABEL author=frappé
RUN curl --silent --location https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -y && apt-get install  \
    git \
    wkhtmltopdf \
    mariadb-client \
    postgresql-client \
    gettext-base \
    wget \
    # for PDF
    libssl-dev \
    fonts-cantarell \
    xfonts-75dpi \
    xfonts-base \
    # to work inside the container
    locales \
    build-essential \
    cron \
    curl \
    vim \
    sudo \
    iputils-ping \
    watch \
    tree \
    nano \
    software-properties-common \
    bash-completion \
    # For psycopg2
    libpq-dev \
    # Other
    libffi-dev \
    liblcms2-dev \
    libldap2-dev \
    libmariadbclient-dev \
    libsasl2-dev \
    libtiff5-dev \
    libwebp-dev \
    redis-tools \
    rlwrap \
    tk8.6-dev \
    ssh-client \
    zsh \
    dialog apt-utils \
    nodejs\
    # VSCode container requirements
    net-tools \
    # PYTHON
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python-virtualenv \
    less -y \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales

# Detect arch, download and install wkhtmltox
RUN if [ `uname -m` = 'aarch64' ]; then export ARCH=arm64; fi \
    && if [ `uname -m` = 'x86_64' ]; then export ARCH=amd64; fi \
    && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_${ARCH}.deb \
    && dpkg -i wkhtmltox_0.12.6-1.buster_${ARCH}.deb && rm wkhtmltox_0.12.6-1.buster_${ARCH}.deb

# Create new user with home directory, improve docker compatibility with UID/GID 1000, add user to sudo group, allow passwordless sudo, switch to that user and change directory to user home directory
RUN groupadd -g 1000 frappe
RUN useradd --no-log-init -r -m -u 1000 -g 1000 -G  sudo frappe
RUN echo "frappe ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER frappe
WORKDIR /home/frappe

# Clone and install bench in the local user home directory
# For development, bench source is located in ~/.bench
RUN pip3 install frappe-bench icecream

# Export python executables for Dockerfile
ENV PATH=/home/frappe/.local/bin:$PATH
# Export python executables for interactive shell
RUN echo "export PATH=/home/frappe/.local/bin:\$PATH" >> /home/frappe/.bashrc
RUN sudo npm install -g yarn
# Print version and verify bashrc is properly sourced so that everything works in the Dockerfile
RUN bench --version
# Print version and verify bashrc is properly sourced so that everything works in the interactive shell
RUN bash -c "bench --version"

# Print version and verify bashrc is properly sourced so that everything works in the Dockerfile
RUN node --version \
    && npm --version \
    && yarn --version
# Print version and verify bashrc is properly sourced so that everything works in the interactive shell
RUN bash -c "node --version" \
    && bash -c "npm --version" \
    && bash -c "yarn --version"
# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
COPY zsh-in-docker.sh /tmp 
RUN  /tmp/zsh-in-docker.sh \
    -t amuse \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p https://github.com/djui/alias-tips \
    -p 'history-substring-search' \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

COPY setupbench.sh .
COPY bs_command.sh .
ADD .vscode /tmp/.vscode
RUN sudo chmod u+x setupbench.sh bs_command.sh && sudo chown frappe:frappe -R /tmp/.vscode
ENTRYPOINT ["bash","/home/frappe/setupbench.sh"]

EXPOSE 8000-8005 9000-9005 6787