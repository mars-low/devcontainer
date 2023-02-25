# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.0/containers/codespaces-linux/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/universal:2-focal

COPY library-scripts/*.sh /tmp/library-scripts/
# ** [Optional] Uncomment this section to install additional packages. **
USER root

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && bash /tmp/library-scripts/rust-debian.sh "${CARGO_HOME}" "${RUSTUP_HOME}" "${USERNAME}" "true" "true" \
    && apt-get -y install gnupg ca-certificates \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update \
    && apt-get -y install mono-complete \
    && apt-get -y install policykit-1 libgtk2.0-0 uml-utilities gtk-sharp2 libc6-dev \
    && apt-get -y install screen \
    && apt-get -y install picocom minicom \
    && apt-get -y install tshark termshark \
    && apt-get -y install fzf bat neofetch \
    && apt-get -y install asciinema \
    && apt-get -y install telnet netcat gdb-multiarch \
    && apt-get -y install libevent-dev ncurses-dev build-essential bison pkg-config \
    && curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly \
    && wget 'https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb' \
    && apt-get -y install ./nvim-linux64.deb && rm -f ./nvim-linux64.deb \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN TEMP_DEB="$(mktemp)" \
    && wget -O "$TEMP_DEB" 'https://github.com/dandavison/delta/releases/download/0.13.0/git-delta_0.13.0_amd64.deb' \
    && dpkg -i "$TEMP_DEB" \
    && rm -f "$TEMP_DEB"

RUN TEMP_GZ="$(mktemp)" \
    TEMP_TMUX_DIR="$(mktemp -d)" \
    && wget -O "$TEMP_GZ" 'https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz' \
    && tar -zxf "$TEMP_GZ" -C "$TEMP_TMUX_DIR" \
    && cd "${TEMP_TMUX_DIR}/tmux-3.3a" \
    && ./configure && make && make install \
    && cd - \
    && rm -rf "$TEMP_GZ" "$TEMP_TMUX_DIR"

RUN TEMP_DEB="$(mktemp)" \
    && wget -O "$TEMP_DEB" 'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb' \
    && dpkg -i "$TEMP_DEB" \
    && rm -f "$TEMP_DEB"

RUN TEMP_TAR="$(mktemp)" \
    TEMP_TIG_DIR="$(mktemp -d)" \
    && wget -O "$TEMP_TAR" 'https://github.com/jonas/tig/releases/download/tig-2.5.8/tig-2.5.8.tar.gz' \
    && tar -zxf "$TEMP_TAR" -C "$TEMP_TIG_DIR" \
    && cd "${TEMP_TIG_DIR}/tig-2.5.8" \
    && make prefix=/usr/local && make install prefix=/usr/local \
    && cd - \
    && rm -rf "$TEMP_TAR" "$TEMP_TIG_DIR"

# These do not need sudo access to install

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    HOME=/home/codespace \
    SHELL=/usr/bin/zsh
RUN cargo install --locked broot exa starship fd-find

RUN go install github.com/jesseduffield/lazygit@latest \
    && go install github.com/jesseduffield/lazydocker@latest

RUN pipx install r2env \
    && r2env init \
    && r2env add radare2@git

RUN pipx install gdbgui

RUN chown -R codespace:codespace /home/codespace/
RUN chmod 755 /home/codespace/

# RUN wget https://github.com/Kitware/CMake/releases/download/v3.25.2/cmake-3.25.2-linux-x86_64.sh \
    # && chmod +x cmake-3.25.2-linux-x86_64.sh \
    # && ./cmake-3.25.2-linux-x86_64.sh --skip-license --include-subdir \
    # && rm -f cmake-3.25.2-linux-x86_64.sh

USER codespace

WORKDIR /home/codespace

# ARG USERNAME=codespace

ENV PATH="${PATH}:$HOME/.r2env/versions/radare2@git/bin/"

