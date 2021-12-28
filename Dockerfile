FROM openresty/openresty:bionic
COPY src/lua /lua
COPY gateway*.rockspec /lua
WORKDIR /lua
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git
RUN luarocks install --only-deps gateway*.rockspec
EXPOSE 80
