FROM node:14

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get update \
    && apt-get -y install \
    --no-install-recommends \
    curl \
    wget \
    aria2 \
    python3 \
    python3-pip \
    make \
    g++ \
    build-essential \
    gnupg2 \
    openssl \
    ffmpeg \
    youtube-dl \
    zip \
    ca-certificates \
    && update-ca-certificates \
    && curl  \
    https://mega.nz/linux/MEGAsync/Debian_9.0/i386/megacmd-Debian_9.0_i386.deb \
    --output /tmp/megacmd.deb \
    && apt install /tmp/megacmd.deb -y --allow-remove-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/megacmd.*

#gdrive downloader
RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz
RUN rm /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get github.com/Jitendra7007/gdrive
RUN echo "KGdkcml2ZSB1cGxvYWQgIiQxIikgMj4gL2Rldi9udWxsIHwgZ3JlcCAtb1AgJyg/PD1VcGxvYWRlZC4pW2EtekEtWl8wLTktXSsnID4gZztnZHJpdmUgc2hhcmUgJChjYXQgZykgPi9kZXYvbnVsbCAyPiYxO2VjaG8gImh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvJChjYXQgZykiCg==" | base64 -d > /usr/local/bin/gup && \
chmod +x /usr/local/bin/gup

#add mega cmd
RUN apt-get update && apt-get install libpcrecpp0v5 libcrypto++6 -y && \
curl https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megacmd-Debian_9.0_amd64.deb --output megacmd.deb && \
echo path-include /usr/share/doc/megacmd/* > /etc/dpkg/dpkg.cfg.d/docker && \
apt install ./megacmd.deb

#Rclone
RUN curl https://rclone.org/install.sh | bash
# setup workdir
WORKDIR /bot
RUN chmod 777 /bot

# Copies config(if it exists)
COPY . .

# Install requirements and start the bot
RUN npm install
CMD ["node", "server"]
