"use strict";

const { dump_to_s3 } = require('./dump-file-to-s3');
const cw = require('./cloudwatch');

cw.config({
    REGION: process.env.LOG_REGION,
    GROUP_NAME: process.env.LOG_GROUP_NAME,
    LOG_STREAM_PERIOD_MINUTES: process.env.LOG_STREAM_PERIOD_MINUTES
});

(async () => {

    const result = await dump_to_s3();
    cw.log(JSON.stringify(result))

    console.log('Done');
})();

