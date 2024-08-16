FROM node:20.15.1-alpine3.19

ARG user=node

RUN mkdir -p /usr/src/angular_website/node_modules && chown -R $user:$user /usr/src/angular_website

WORKDIR /usr/src/angular_website

RUN npm install --location=global @angular/cli@17.3.7

COPY --chown=$user:$user . .

USER $user

EXPOSE 5000