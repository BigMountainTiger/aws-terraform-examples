"use strict";

const { dump_to_s3 } = require('./dump-file-to-s3');

(async () => {

    const result = await dump_to_s3();
    console.log(result);
})();

