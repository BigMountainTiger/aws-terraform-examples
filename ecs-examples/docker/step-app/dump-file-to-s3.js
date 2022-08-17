"use strict";

const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

const BUCKET = 'example.huge.head.li.2023';

const dump_to_s3 = async () => {

    const time = new Date().toISOString();
    const TARGET_KEY = time.replace(/:/g, '-').replace(/\./g, '-');

    const params = {
        Bucket: BUCKET,
        Key: `F-${TARGET_KEY}`,
        Body: 'SOME TEXT'
    };

    const region = process.env.AWS_REGION
    console.log(region)

    const s3Client = new S3Client({
        region: 'us-east-1'
    });
    
    return await s3Client.send(new PutObjectCommand(params));
};

exports.dump_to_s3 = dump_to_s3;