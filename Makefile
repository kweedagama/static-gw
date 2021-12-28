PREFIX=nginx
CONF=conf/nginx.conf
OPENSSL_DIR ?= /usr/local/Cellar/openresty-openssl111/1.1.1l_1
CODE_DIR=/Users/kevinweedagama/code/kevinweedagamaio/gateway
CONTAINER_NAME=gateway
PORT=8000

start: 
	openresty -p $(PREFIX) -c $(CONF)

stop:
	openresty -p $(PREFIX)  -c $(CONF) -s stop

status:
	ps aux | grep nginx

install-deps:
	luarocks install --only-deps gateway*.rockspec \
	CRYPTO_INCDIR=${OPENSSL_DIR}/include/ \
	OPENSSL_INCDIR=${OPENSSL_DIR}/include/ \
	OPENSSL_DIR=${OPENSSL_DIR} \
	OPENSSL_LIBDIR=${OPENSSL_DIR}/lib/ \
	CRYPTO_LIBDIR=${OPENSSL_DIR}/lib/

reload:
	openresty  -p $(PREFIX)  -c $(CONF) -s reload

docker-start: clean
	docker build -t kevinweedagamaio . \
	&& \
    docker run -d -v $(CODE_DIR)/nginx/conf.d:/usr/local/openresty/nginx/conf/conf.d \
    -v $(CODE_DIR)/nginx/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf \
    -v $(CODE_DIR)/nginx/logs:/usr/local/openresty/nginx/logs \
    -v $(CODE_DIR)/src/lua:/lua \
    -v $(HOME)/.aws:/.aws \
	--env-file ./env/.env-dev \
    -p 8000:80 --name $(CONTAINER_NAME) kevinweedagamaio

docker-stop:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)

docker-reload:
	docker exec $(CONTAINER_NAME) sh -c "nginx -s reload"

docker-status:
	docker exec $(CONTAINER_NAME) sh -c "ps aux | grep nginx"

docker-health:
	curl -v http://localhost:$(PORT)/health

clean:
	@rm -rf nginx/logs/*.log
