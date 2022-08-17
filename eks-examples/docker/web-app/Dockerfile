FROM node:18.8.0-alpine3.15

WORKDIR /web-app

COPY package.json ./

RUN npm --loglevel=error install

COPY app.js ./

EXPOSE 8000
CMD ["node", "app.js"]
