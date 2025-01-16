FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y zsh git curl tmux btop neovim language-pack-en && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN update-locale

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

WORKDIR /root

COPY .zshrc .zshrc

# CMD ["zsh"]
