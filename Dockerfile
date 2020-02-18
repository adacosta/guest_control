FROM amberframework/amber:0.33.0

RUN echo "Using Dockefile"

RUN apt-get update -qq -y
RUN apt-get install libsodium-dev -y

WORKDIR /app

COPY shard.* /app/
RUN shards install

COPY . /app

ENV PATH="/app/node_modules/.bin:${PATH}"

# RUN rm -rf /app/node_modules

# Use abstracted app start because dokku detects the last line in Dockerfile
#  and uses this value to override the start even if a different Dockerfile
#  arg is specified in the build; make sure to set AMBER_ENV="production" in dokku

CMD ./app-start.sh