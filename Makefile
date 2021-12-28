PREFIX=nginx
CONF=conf/nginx.conf
OPENSSL_DIR ?= /usr/local/Cellar/openresty-openssl111/1.1.1l_1

start: 
	openresty -p $(PREFIX) -c $(CONF)

stop:
	openresty -p $(PREFIX)  -c $(CONF) -s stop

status:
	ps aux | grep nginx

# install-deps:
# 	luarocks install --only-deps gateway*.rockspec

install-deps:
	luarocks install --only-deps gateway*.rockspec \
	CRYPTO_INCDIR=${OPENSSL_DIR}/include/ \
	OPENSSL_INCDIR=${OPENSSL_DIR}/include/ \
	OPENSSL_DIR=${OPENSSL_DIR} \
	OPENSSL_LIBDIR=${OPENSSL_DIR}/lib/ \
	CRYPTO_LIBDIR=${OPENSSL_DIR}/lib/

reload:
	openresty  -p $(PREFIX)  -c $(CONF) -s reload
