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
