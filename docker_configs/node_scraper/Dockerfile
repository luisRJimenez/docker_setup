FROM node:20.15.1-alpine3.19

ARG user=node

RUN mkdir -p /usr/src/node_scraper/node_modules && chown -R $user:$user /usr/src/node_scraper

WORKDIR /usr/src/node_scraper

COPY --chown=$user:$user . .

RUN npm install --location=global express --save 
RUN npm install --location=global nodemon
RUN npm install --save-dev log-beautify

USER $user

EXPOSE 7000