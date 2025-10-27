FROM ubuntu:latest AS base

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates

FROM base AS wget

RUN apt-get update && apt-get install -y --no-install-recommends wget

ARG VERSION="1.105.1"

RUN wget --no-hsts -qO- https://update.code.visualstudio.com/${VERSION}/cli-linux-x64/stable | tar xvz -C /usr/bin/

FROM base

COPY --from=wget /usr/bin/code /usr/bin/code
RUN chmod +x /usr/bin/code

RUN userdel -r ubuntu && useradd -m -s /bin/bash -u 1000 vscode
USER vscode

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  git \
  python3

RUN \
  # git config --global user.name name \
  # git config --global user.email user@email \
  git config --global core.editor "code --wait"

ENTRYPOINT [ "/usr/bin/code", "serve-web", "--without-connection-token", "--accept-server-license-terms" ]

CMD [ "--host", "0.0.0.0", "--port", "8000", "--cli-data-dir", "/home/vscode/.vscode/cli-data", "--server-data-dir", "/home/vscode/.vscode/server-data" ]
