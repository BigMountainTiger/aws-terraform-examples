const logs = require("@aws-sdk/client-cloudwatch-logs");

const CONFIG = {
    REGION: 'us-east-1',
    GROUP_NAME: 'DEFAULT_LOG_GROUP',
    LOG_STREAM_PERIOD_MINUTES: 24 * 60
};

const stream_name = () => {
    const PERIOD = CONFIG.LOG_STREAM_PERIOD_MINUTES;

    const d = new Date();
    const Year = d.getFullYear();
    const Month = ('0' + (d.getMonth() + 1)).slice(-2);
    const Day = ('0' + d.getDate()).slice(-2);

    const m = Math.floor((d.getHours() * 60 + d.getMinutes()) / PERIOD) * PERIOD;
    const Hour = ('0' + Math.floor(m / 60)).slice(-2)
    const Minute = ('0' + (m % 60)).slice(-2)

    return `${Year}-${Month}-${Day}-${Hour}-${Minute}`;
}

const put_logevent = async (msg) => {
    const client = new logs.CloudWatchLogsClient({ region: CONFIG.REGION });

    cmd = new logs.PutLogEventsCommand({
        logGroupName: CONFIG.GROUP_NAME,
        logStreamName: stream_name(),
        logEvents: [{
            timestamp: Date.now(),
            message: msg
        }]
    });

    let err = null;
    try {
        await client.send(cmd);
    } catch (ex) {
        err = ex;
    }

    return err;
};

const create_loggroup = async () => {
    const client = new logs.CloudWatchLogsClient({ region: CONFIG.REGION });

    let err = null;
    try {
        await client.send(new logs.CreateLogGroupCommand({ logGroupName: CONFIG.GROUP_NAME }));
    } catch (ex) {
        err = ex;
    }

    return err;
};

const create_logstream = async () => {
    const client = new logs.CloudWatchLogsClient({ region: CONFIG.REGION });

    let err = null;
    try {
        await client.send(new logs.CreateLogStreamCommand({
            logGroupName: CONFIG.GROUP_NAME,
            logStreamName: stream_name()
        }));
    } catch (ex) {
        err = ex;
    }

    return err;
};

const log = async (msg) => {

    let err = null;
    err = await put_logevent(msg);
    if (!err || !(err instanceof logs.ResourceNotFoundException)) {
        return err;
    }

    err = await create_loggroup();
    if (err && !(err instanceof logs.ResourceAlreadyExistsException)) {
        return err;
    }

    err = await create_logstream();
    if (err && !(err instanceof logs.ResourceAlreadyExistsException)) {
        return err;
    }

    return await put_logevent(msg);
}

exports.config = (conf) => {
    CONFIG.REGION = conf?.REGION ?? CONFIG.REGION;
    CONFIG.GROUP_NAME = conf?.GROUP_NAME ?? CONFIG.GROUP_NAME;
    CONFIG.LOG_STREAM_PERIOD_MINUTES = conf?.LOG_STREAM_PERIOD_MINUTES ?? CONFIG.LOG_STREAM_PERIOD_MINUTES;
};

exports.log = async (msg) => {
    try {
        return log(msg);
    } catch (ex) {
        return ex;
    }
};
