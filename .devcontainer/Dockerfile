#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM debian:bookworm

# Default to bash shell (other shells available at /usr/bin/fish and /usr/bin/zsh)
ENV LANG="C.UTF-8" \
    SHELL=/bin/bash \
    DOCKER_BUILDKIT=1

# Install basic build tools
RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        make \
        unzip \
        build-essential \
        swig \
        unixodbc-dev \
        libpq-dev \
        default-libmysqlclient-dev \
        moreutils \
        rsync \
        zip \
        libgdiplus \
        jq \
        python3-setuptools-whl \
        python3-pip-whl \
        python3-pip \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libncurses5 \
        lttng-tools \
        libssl-dev \
        libstdc++6 \
        zlib1g \
        libuuid1 \
        libunwind8 \
        sqlite3 \
        libsqlite3-dev \
        software-properties-common \
        tk-dev \
        uuid-dev \
        curl \
        gettext \
        fish \
    && apt-get -yq install build-essential cmake cppcheck valgrind clang lldb llvm gdb python3-dev \
    && apt-get install -yq vim vim-doc xtail software-properties-common libsecret-1-dev \
    && apt-get install -yq libnss3 libnspr4 libatk-bridge2.0-0 libatk1.0-0 libx11-6 libpangocairo-1.0-0 libx11-xcb1 libcups2 libxcomposite1 libxdamage1 libxfixes3 libpango-1.0-0 libgbm1 libgtk-3-0 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/

# Mount for docker-in-docker 
VOLUME [ "/var/lib/docker" ]

# Fire Docker/Moby script if needed
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "/usr/local/share/ssh-init.sh"]
CMD [ "sleep", "infinity" ]

# [Optional] Install debugger for development of Codespaces - Not in resulting image by default
ARG DeveloperBuild
RUN if [ -z "$DeveloperBuild" ]; then \
        echo "not including debugger" ; \
    else \
        curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg ; \
    fi
