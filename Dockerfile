FROM node

RUN apt-get update
RUN apt-get -y install make nodejs unoconv

WORKDIR /app

COPY package.json /app/package.json
RUN npm install

COPY . /app

CMD /usr/bin/unoconv --listener && make pdf
