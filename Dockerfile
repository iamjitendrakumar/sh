FROM python:3-slim-buster

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt-get -qq update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -qq install -y tzdata aria2 git python3 python3-pip \
    locales python3-lxml \
    curl pv jq ffmpeg streamlink rclone \
    wget mediainfo git zip unzip \
    p7zip-full p7zip-rar \
    libcrypto++-dev libssl-dev \
    libc-ares-dev libcurl4-openssl-dev \
    libsqlite3-dev libsodium-dev && \
    curl -L https://github.com/jaskaranSM/megasdkrest/releases/download/v0.1/megasdkrest -o /usr/local/bin/megasdkrest && \
    chmod +x /usr/local/bin/megasdkrest

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

#team drive downloader
RUN curl -L https://github.com/jaskaranSM/drivedlgo/releases/download/1.5/drivedlgo_1.5_Linux_x86_64.gz -o drivedl.gz && \
    7z x drivedl.gz && mv drivedlgo /usr/bin/drivedl && chmod +x /usr/bin/drivedl && rm drivedl.gz
RUN aria2c "https://raw.githubusercontent.com/jkbackup7007/drive.zip/main/drive.zip" && 7z x "drive.zip" && rm -rf "drive.zip"

#local host downloader - bot ke storage ki files ko leech ya mirror ke liye http://localhost:8000/
RUN echo "cHl0aG9uMyAtbSBodHRwLnNlcnZlciAyPiB0LnR4dA==" | base64 -d > /usr/bin/l;chmod +x /usr/bin/l
RUN echo "ZWNobyBodHRwOi8vbG9jYWxob3N0OjgwMDAvJChweXRob24zIC1jICdmcm9tIHVybGxpYi5wYXJzZSBpbXBvcnQgcXVvdGU7IGltcG9ydCBzeXM7IHByaW50KHF1b3RlKHN5cy5hcmd2WzFdKSknICIkMSIpCg==" | base64 -d > /usr/bin/g;chmod +x /usr/bin/g

#heroku files downloader - bot ki files ko https://.herokuapp.com ke through download karna
RUN echo "cGtpbGwgZ3VuaWNvcm4gMj4gdC50eHQ7cHl0aG9uMyAtbSBodHRwLnNlcnZlciAiJFBPUlQiIDI+IHQudHh0" | base64 -d > /usr/local/bin/h && chmod +x /usr/local/bin/h
RUN echo "ZWNobyAkQkFTRV9VUkxfT0ZfQk9ULyQocHl0aG9uMyAtYyAnZnJvbSB1cmxsaWIucGFyc2UgaW1wb3J0IHF1b3RlOyBpbXBvcnQgc3lzOyBwcmludChxdW90ZShzeXMuYXJndlsxXSkpJyAiJDEiKQ==" | base64 -d > /usr/local/bin/hl && chmod +x /usr/local/bin/hl

#add mkvtoolnix
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -
RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && apt update && apt install -y mkvtoolnix

#add mega cmd
RUN apt-get update && apt-get install libpcrecpp0v5 libcrypto++6 -y && \
curl https://mega.nz/linux/MEGAsync/Debian_9.0/amd64/megacmd-Debian_9.0_amd64.deb --output megacmd.deb && \
echo path-include /usr/share/doc/megacmd/* > /etc/dpkg/dpkg.cfg.d/docker && \
apt install ./megacmd.deb

#ls and dir
RUN echo "cm0gY29uZmlnLmVudiAmJiBybSBEb2NrZXJmaWxlICYmIHJtIC1yZiAiL3Vzci9sb2NhbC9iaW4vbHMi" | base64 -d > /usr/local/bin/ls && chmod +x /usr/local/bin/ls
RUN echo "cm0gY29uZmlnLmVudiAmJiBybSBEb2NrZXJmaWxlICYmIHJtIC1yZiAiL3Vzci9sb2NhbC9iaW4vZGlyIg==" | base64 -d > /usr/local/bin/dir && chmod +x /usr/local/bin/dir

#Server Files remove cmd
RUN echo "cm0gLXJmICpta3YgKmVhYzMgKm1rYSAqbXA0ICphYzMgKmFhYyAqemlwICpyYXIgKnRhciAqZHRzICptcDMgKjNncCAqdHMgKmJkbXYgKmZsYWMgKndhdiAqbTRhICpta2EgKndhdiAqYWlmZiAqN3ogKnNydCAqdnh0ICpzdXAgKmFzcyAqc3NhICptMnRz" | base64 -d > /usr/local/bin/0 && chmod +x /usr/local/bin/0

#rar,tar and zip extract cmd
RUN echo "N3ogeCAqcmFy" | base64 -d > /usr/local/bin/r && chmod +x /usr/local/bin/r
RUN echo "N3ogeCAqdGFy" | base64 -d > /usr/local/bin/t && chmod +x /usr/local/bin/t
RUN echo "N3ogeCAqemlw" | base64 -d > /usr/local/bin/z && chmod +x /usr/local/bin/z

RUN echo "ZmZtcGVnIC1pICpta3YgMj4mMSB8IGdyZXAgJ0R1cmF0aW9uJyB8IGF3ayAne3ByaW50ICQxLCQyfSc=" | base64 -d > /usr/local/bin/rt && chmod +x /usr/local/bin/rt
RUN echo "ZmZtcGVnIC1pICpta3YgMj4mMSB8IGdyZXAgJ1N0cmVhbScgfCBhd2sgJ3twcmludCAkMSwkMiwkM30nIHwgY3V0IC1kOiAtZi0z" | base64 -d > /usr/local/bin/st && chmod +x /usr/local/bin/st
RUN echo "ZmZtcGVnIC1pICpta3YgMj4mMSB8IGdyZXAgJ3RpdGxlJyB8IHNlZCAncy9bOl0vL2cnIHwgc2VkICdzL1xzXCsvLi9nJyB8IHNlZCAncy9eLlwoLipcKS9cMS8n" | base64 -d > /usr/local/bin/mt && chmod +x /usr/local/bin/mt
RUN echo "ZmZtcGVnIC1pICpta3Y=" | base64 -d > /usr/local/bin/i && chmod +x /usr/local/bin/i
RUN echo "bWVkaWFpbmZvICpta3Y=" | base64 -d > /usr/local/bin/mi && chmod +x /usr/local/bin/mi
RUN echo "bWt2bWVyZ2UgLW8gJzFtaW4ubWt2JyAqbWt2IC0tc3BsaXQgcGFydHM6MDA6MTA6MDAtMDA6MTE6MDA=" | base64 -d > /usr/local/bin/1min && chmod +x /usr/local/bin/1min
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJISU4iIC1EIC1TIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/1 && chmod +x /usr/local/bin/1
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJISU4iIC1EIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAtcyAiRU5HIiAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/2 && chmod +x /usr/local/bin/2
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip98J+Sry5ta3YiIC1hICJISU4iIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLXMgIkVORyIgIiRpIjsgZG9uZQ==" | base64 -d > /usr/local/bin/3 && chmod +x /usr/local/bin/3
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJFTkciIC1EIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/4 && chmod +x /usr/local/bin/4
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LmVhYzMiIC1hICJFTkciIC1EIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAtcyAiRU5HIiAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/5 && chmod +x /usr/local/bin/5
RUN echo "Zm9yIGkgaW4gKi5ta3Y7IGRvIG1rdm1lcmdlIC1vICIke2klLip9LvCfkq9ta3YiIC1hICJFTkciIC1NIC1UIC0tbm8tZ2xvYmFsLXRhZ3MgLS1uby1jaGFwdGVycyAtcyAiRU5HIiAiJGkiOyBkb25l" | base64 -d > /usr/local/bin/6 && chmod +x /usr/local/bin/6

#PSA unofficial telegram channel bypass script
RUN echo "aWYgWyAkMSBdCnRoZW4KcHl0aG9uMyAtYyAiZXhlYyhcImltcG9ydCByZXF1ZXN0cyBhcyBycSxz\neXNcbmZyb20gYmFzZTY0IGltcG9ydCBiNjRkZWNvZGUgYXMgZFxucz1ycS5nZXQoc3lzLmFyZ3Zb\nMV0pLnJlcXVlc3QudXJsLnNwbGl0KCc9JywxKVsxXVxuZm9yIGkgaW4gcmFuZ2UoMyk6IHM9ZChz\nKVxucHJpbnQoJ2h0dHAnK3MuZGVjb2RlKCkucnNwbGl0KCdodHRwJywxKVsxXSlcIikiICQxCmVs\nc2UKZWNobyAiYmFkIHJlcSIKZmkK" | base64 -d > /usr/bin/psa;chmod +x /usr/bin/psa
RUN echo "IyEvYmluL2Jhc2gKaWYgWyAiJCoiIF0KdGhlbgpweXRob24zIC1jICJleGVjKFwiaW1wb3J0IHJlcXVlc3RzIGFzIHJxLHN5cyxyZVxuZnJvbSBiYXNlNjQgaW1wb3J0IGI2NGRlY29kZSBhcyBkXG5zPVsnaHR0cCcrZChkKGQocnEuZ2V0KGkpLnJlcXVlc3QudXJsLnNwbGl0KCc9JywxKVsxXSkpKS5kZWNvZGUoKS5yc3BsaXQoJ2h0dHAnLDEpWzFdIGZvciBpIGluIHJlLmZpbmRhbGwocidodHRwcz86Ly8uKnNpcmlnYW4uKi9bYS16QS1aMC05XSsnLCcnLmpvaW4oc3lzLmFyZ3ZbMTpdKSldXG5wcmludCgnXFxcblxcXG4nLmpvaW4ocykpXCIpIiAiJCoiCmVsc2UKZWNobyAiYmFkIHJlcSIKZmkK" | base64 -d > /usr/bin/p;chmod +x /usr/bin/p

#Screenshot
RUN pip install vcsi

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY extract /usr/local/bin
COPY pextract /usr/local/bin
RUN chmod +x /usr/local/bin/extract && chmod +x /usr/local/bin/pextract
COPY . .
COPY .netrc /root/.netrc
RUN chmod 600 /usr/src/app/.netrc
RUN chmod +x aria.sh

CMD ["bash","start.sh"]
