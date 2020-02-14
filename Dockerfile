FROM amberframework/amber:v0.31.0

RUN apt-get update -qq -y
RUN apt-get install libsodium-dev -y

WORKDIR /app

COPY shard.* /app/
RUN shards install

COPY . /app

RUN rm -rf /app/node_modules

CMD amber watch
