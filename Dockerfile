FROM ubuntu:latest AS base

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM base AS wget

RUN apt-get update && apt-get install -y --no-install-recommends wget

ARG VERSION="1.105.1"

RUN wget --no-hsts -qO- https://update.code.visualstudio.com/${VERSION}/cli-linux-x64/stable | tar xvz -C /usr/bin/

FROM zmkfirmware/zmk-dev-arm:stable

COPY --from=wget /usr/bin/code /usr/bin/code
RUN chmod +x /usr/bin/code

RUN userdel -r ubuntu && useradd -m -s /bin/bash -u 1000 vscode
USER vscode

ENTRYPOINT [ "/usr/bin/code", "serve-web", "--without-connection-token", "--accept-server-license-terms" ]

CMD [ "--host", "0.0.0.0", "--port", "8000", "--cli-data-dir", "/home/vscode/.vscode/cli-data", "--server-data-dir", "/home/vscode/.vscode/server-data" ]
