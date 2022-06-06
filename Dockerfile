FROM python:3-slim-buster

# Install all the required packages
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt-get -qq update
RUN apt-get -qq install -y --no-install-recommends curl git gnupg2 unzip wget pv jq

# add mkvtoolnix
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -
RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && apt update && apt install -y mkvtoolnix

# install required packages
RUN apt-get update && apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && apt-get -qq install -y --no-install-recommends \
    # this package is required to fetch "contents" via "TLS"
    apt-transport-https \
    # install coreutils
    coreutils aria2 jq pv gcc g++ \
    # install encoding tools
    mediainfo \
    # miscellaneous
    neofetch python3-dev git bash build-essential nodejs npm ruby \
    python-minimal locales python-lxml qbittorrent-nox nginx gettext-base xz-utils \
    # install extraction tools
    p7zip-full p7zip-rar rar unrar zip unzip \
    # miscellaneous helpers
    megatools mediainfo && \
    # clean up the container "layer", after we are done
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
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

#PSA unofficial telegram channel bypass script
RUN echo "aWYgWyAkMSBdCnRoZW4KcHl0aG9uMyAtYyAiZXhlYyhcImltcG9ydCByZXF1ZXN0cyBhcyBycSxz\neXNcbmZyb20gYmFzZTY0IGltcG9ydCBiNjRkZWNvZGUgYXMgZFxucz1ycS5nZXQoc3lzLmFyZ3Zb\nMV0pLnJlcXVlc3QudXJsLnNwbGl0KCc9JywxKVsxXVxuZm9yIGkgaW4gcmFuZ2UoMyk6IHM9ZChz\nKVxucHJpbnQoJ2h0dHAnK3MuZGVjb2RlKCkucnNwbGl0KCdodHRwJywxKVsxXSlcIikiICQxCmVs\nc2UKZWNobyAiYmFkIHJlcSIKZmkK" | base64 -d > /usr/bin/psa;chmod +x /usr/bin/psa
RUN echo "IyEvYmluL2Jhc2gKaWYgWyAiJCoiIF0KdGhlbgpweXRob24zIC1jICJleGVjKFwiaW1wb3J0IHJlcXVlc3RzIGFzIHJxLHN5cyxyZVxuZnJvbSBiYXNlNjQgaW1wb3J0IGI2NGRlY29kZSBhcyBkXG5zPVsnaHR0cCcrZChkKGQocnEuZ2V0KGkpLnJlcXVlc3QudXJsLnNwbGl0KCc9JywxKVsxXSkpKS5kZWNvZGUoKS5yc3BsaXQoJ2h0dHAnLDEpWzFdIGZvciBpIGluIHJlLmZpbmRhbGwocidodHRwcz86Ly8uKnNpcmlnYW4uKi9bYS16QS1aMC05XSsnLCcnLmpvaW4oc3lzLmFyZ3ZbMTpdKSldXG5wcmludCgnXFxcblxcXG4nLmpvaW4ocykpXCIpIiAiJCoiCmVsc2UKZWNobyAiYmFkIHJlcSIKZmkK" | base64 -d > /usr/bin/p;chmod +x /usr/bin/p

COPY requirements.txt .
COPY . .

CMD ["bash","start.sh"]
