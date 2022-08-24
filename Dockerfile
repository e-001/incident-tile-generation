FROM node:16

RUN yarn global add graphqurl
RUN apt-get update && apt-get install jq git build-essential -qq -y

WORKDIR /tmp/tippecanoe
RUN git clone https://github.com/mapbox/tippecanoe.git . \
  && git checkout 1.36.0 \
  && make -j \
  && make install \
  && cd .. \
  && rm -rf /tmp/tippecanoe

WORKDIR /app
COPY package.json yarn.lock tsconfig.json ./
RUN yarn install --frozen-lockfile

COPY . .
ENTRYPOINT ["sh", "/app/run.sh"]
