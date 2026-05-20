const express = require('express');
const cluster = require('cluster');
const process = require('process')

process.on('SIGINT', () => {
    console.info("\nProcess stoped by interruption")
    process.exit(0)
})

const port = 8000;
const app = express();

app.get('/healthcheck', (req, res) => {
    res.status(200).send('OK');
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