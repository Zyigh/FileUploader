FROM swift:5.1

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get update -yq && apt-get upgrade -yq && \
    apt-get install -yq libpq-dev libssl-dev zlib1g-dev libz-dev libevent-dev libicu-dev libcurl4-openssl-dev sqlite3 libsqlite3-dev

WORKDIR /fileuploader
ADD / .

RUN swift build -c release -Xlinker -L/usr/local/lib -Xlinker -L/usr/include
RUN cp /fileuploader/.build/x86_64-unknown-linux/release/fileuploader /usr/local/bin
RUN chown -R $(whoami) $PWD

EXPOSE 80

CMD fileuploader
