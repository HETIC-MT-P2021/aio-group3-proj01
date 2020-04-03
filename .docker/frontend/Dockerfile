FROM alpine:latest

LABEL maintainer="Edouin Vautier, Jason Gauvin, Jack Maarek <https://github.com/HETIC-MT-P2021/aio-group3-proj01>"

RUN mkdir /elm-app
WORKDIR /elm-app

# Install curl package
RUN apk update && apk add --update curl && apk add --update nodejs npm && \
    # Install elm
    curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz && \
    gunzip elm.gz && \
    chmod +x elm && \
    mv elm /usr/local/bin/

EXPOSE 8000