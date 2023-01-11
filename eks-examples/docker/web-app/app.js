const express = require('express');
const cluster = require('cluster');
const process = require('process')
const os = require('os');

const AWS = require('aws-sdk');

process.on('SIGINT', () => {
    console.info("\nProcess stoped by interruption")
    process.exit(0)
})

const port = 8000;
const app = express();

let access_ct = 0;

app.get('/', (req, res) => {
    res.status(200).send(`OK - ${os.hostname()} - ${++access_ct}\n`);
});

app.get('/buckets', (req, res) => {

    s3 = new AWS.S3()
    s3.listBuckets(function (err, data) {
        let buckets = null;
        if (err)
            buckets = err;
        else
            buckets = data;

        res.status(200).send(buckets);
    });

});

app.get('/healthcheck', (req, res) => {
    res.status(200).send('OK\n');
});

app.get('/hello', (req, res) => {
    res.status(200).send('hello\n');
});

let numCPUs = require('os').cpus().length;
numCPUs = 1;
if (cluster.isMaster) {
    for (var i = 0; i < numCPUs; i++) {
        cluster.fork();
    }

    cluster.on('exit', (worker) => {
        if (!worker.suicide) {
            console.log('Worker ' + worker.id + ' died. Replacing it.');
            cluster.fork();
        }
    });

} else {
    app.listen(port, () => {
        console.log(`App listening on port ${port}`)
    });
}