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
let fail_healthcheck = false;

app.get('/', (req, res) => {
    console.log(`Method called - ${Date.now()}` )
    res.status(200).send(`OK - AAA - ${os.hostname()} - ${++access_ct}\n`);
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

// Call this method to fail the healthcheck
app.get('/fail-healthcheck', (req, res) => {
    fail_healthcheck = true;
    res.status(200).send(`The fail_healthcheck is set to ${fail_healthcheck}\n`);
});

app.get('/healthcheck', (req, res) => {

    if (fail_healthcheck) {
        throw 'The healthcheck is set to fail';
    }

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