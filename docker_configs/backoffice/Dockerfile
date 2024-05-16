FROM node:20.13.1-alpine3.19

ARG user=node

RUN mkdir -p /usr/src/backoffice/node_modules && chown -R $user:$user /usr/src/backoffice

WORKDIR /usr/src/backoffice

RUN npm install --location=global @angular/cli@17.3.7

COPY --chown=$user:$user . .

USER $user

EXPOSE 5000