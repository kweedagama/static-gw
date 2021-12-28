FROM openresty/openresty:bionic
COPY src/lua /lua
COPY gateway*.rockspec /lua
WORKDIR /lua
RUN luarocks install --only-deps gateway*.rockspec
EXPOSE 80
