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
    && apt-get -y install ranger fzf bat ddgr neofetch peco \
    && apt-get -y install asciinema \
    && apt-get -y install libevent-dev ncurses-dev build-essential bison pkg-config \
    && curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly \
    && wget 'https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb' \
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
    && wget -O "$TEMP_TAR" 'https://github.com/jonas/tig/releases/download/tig-2.5.6/tig-2.5.6.tar.gz' \
    && tar -zxf "$TEMP_TAR" -C "$TEMP_TIG_DIR" \
    && cd "${TEMP_TIG_DIR}/tig-2.5.6" \
    && make prefix=/usr/local && make install prefix=/usr/local \
    && cd - \
    && rm -rf "$TEMP_TAR" "$TEMP_TIG_DIR"

USER codespace

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN cargo install --locked broot exa starship navi

RUN go install github.com/jesseduffield/lazygit@latest \
    && go install github.com/jesseduffield/lazydocker@latest

RUN git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone --depth 1 https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z \
    && git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

ENV HOME /home/codespace
ENV SHELL /usr/bin/zsh

RUN git clone --depth 1 https://github.com/NvChad/NvChad $HOME/.config/nvim
# RUN sudo git clone --depth 1 https://github.com/radareorg/radare2 && radare2/sys/install.sh

COPY --chown=codespace:codespace dotfiles/.zshrc $HOME/.zshrc
COPY --chown=codespace:codespace dotfiles/.tmux.conf $HOME/.tmux.conf
COPY --chown=codespace:codespace dotfiles/starship.toml $HOME/.config/starship.toml
COPY --chown=codespace:codespace dotfiles/nvchad_custom/ $HOME/.config/nvim/lua/custom/

# ARG USERNAME=codespace

# RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history" \
#     && sudo mkdir /commandhistory \
#     && sudo touch /commandhistory/.zsh_history \
#     && sudo chown -R $USERNAME /commandhistory \
#     && echo "$SNIPPET" >> "/home/$USERNAME/.zshhrc"