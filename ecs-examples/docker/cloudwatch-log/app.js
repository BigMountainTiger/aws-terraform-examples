const cw = require('./cloudwatch');

cw.config({
    REGION: 'us-east-1',
    GROUP_NAME: 'example-test-loggroup',
    LOG_STREAM_PERIOD_MINUTES: 30
});

(async () => {

    const err = await cw.log(`This is OK - ${Date.now()}`);
    if (err) {
        console.log(err);
    }

})();