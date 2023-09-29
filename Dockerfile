FROM ghcr.io/plc-lang/rust-llvm:latest

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

#Update repos
RUN apt-get update && apt-get upgrade -y

# Install tmux and other deps
RUN apt-get -y install tmux zsh git golang

# Install Starship
RUN curl -LO https://starship.rs/install.sh && sh install.sh --yes

# Remove the cargo cache and let everyone access cargo
RUN rm -rf /usr/local/cargo/registry && chmod ugo+rwx -R /usr/local/cargo 

#Install fira code hack
RUN curl -o hack.ttf.zip -L https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip && unzip hack.ttf.zip && cp -r ttf/ /usr/share/fonts/ 

#Update rust
RUN rustup update

#Install rust source
RUN rustup component add rust-src rust-analyzer

# Switch to a new local user
RUN useradd -ms /bin/zsh dev && mkdir -p /home/dev/
USER dev
WORKDIR /home/dev
RUN mkdir -p ~/.local/bin

# Install Helix
RUN \
	curl -LO https://github.com/helix-editor/helix/releases/download/23.05/helix-23.05-x86_64.AppImage \
	&& chmod +x helix-23.05-x86_64.AppImage && ./helix-23.05-x86_64.AppImage --appimage-extract \
	&& cp -r squashfs-root/usr ~/.local/ \
	&& rm -rf helix-23.05-x86_64.AppImage  squashfs-root

# Dowload neovim
RUN \
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
	&& chmod +x nvim.appimage && ./nvim.appimage --appimage-extract && cp -r squashfs-root/usr ~/.local/ \
	&& rm -rf nvim.appimage squashfs-root

#Insall binintall
# RUN cargo install cargo-binstall

# Install cargo-watch and cargo-insta and dotter for dotfile access
RUN cargo binstall -y cargo-watch cargo-insta eza bat ripgrep

# Install the dotfiles
ADD https://api.github.com/repos/ghaith/dotfiles/git/refs/heads/master version.json
RUN git clone https://github.com/ghaith/dotfiles.git
WORKDIR /home/dev/dotfiles
COPY local.toml .dotter/local.toml

# Dowload and run dotter
RUN cargo binstall -y dotter --no-symlinks && dotter

ENV PATH="${PATH}:/home/dev/.local/bin:/home/dev/.local/usr/bin"

RUN mkdir -p /home/dev/work
WORKDIR /home/dev/work

#Switch to zsh to install the zsh dependency
#Run a headless nvim with the packer sync command
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

RUN /usr/bin/zsh -c "echo 'Done initializing zsh'"

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

ENTRYPOINT ["/usr/bin/zsh"]

