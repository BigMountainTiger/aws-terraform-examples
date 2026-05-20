FROM node:18.8.0-alpine3.15

WORKDIR /step-app

COPY package.json ./

RUN npm --loglevel=error install

COPY cloudwatch.js ./
COPY dump-file-to-s3.js ./
COPY app.js ./

EXPOSE 8000
CMD ["node", "app.js"]
