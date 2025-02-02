FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y zsh git curl tmux btop neovim language-pack-en openssh-server && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN update-locale

RUN useradd -m -s /usr/bin/zsh lohopupa && \
    echo "lohopupa:lohopupa" | chpasswd && \
    mkdir -p /home/lohopupa/.ssh && \
    chown -R lohopupa:lohopupa /home/lohopupa/.ssh

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

WORKDIR /root

COPY .zshrc /root/.zshrc

RUN cp -r /root/.oh-my-zsh /home/lohopupa/ && \
    cp /root/.zshrc /home/lohopupa/.zshrc && \
    chown -R lohopupa:lohopupa /home/lohopupa/.oh-my-zsh /home/lohopupa/.zshrc

RUN mkdir /run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
