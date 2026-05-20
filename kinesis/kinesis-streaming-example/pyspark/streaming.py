from pyspark.sql import SparkSession
from pyspark import RDD
from pyspark.streaming import StreamingContext
from pyspark.streaming.kinesis import KinesisUtils, InitialPositionInStream, StorageLevel
import time


def run():
    APP_NAME = 'kinesis-stream-test'

    STREAM_NAME = 'aws-glue-kinesis-test'
    ENDPOINT_URL = 'https://kinesis.us-east-1.amazonaws.com'
    REGION = 'us-east-1'

    # The time interval to get a new RDD in seconds
    batchInterval = 5

    spark = SparkSession.builder.appName(APP_NAME).getOrCreate()
    sc = spark.sparkContext
    sc.setLogLevel('ERROR')

    ssc = StreamingContext(sc, batchInterval)

    stream = KinesisUtils.createStream(
        ssc=ssc,
        kinesisAppName=APP_NAME,
        streamName=STREAM_NAME,
        endpointUrl=ENDPOINT_URL,
        regionName=REGION,
        initialPositionInStream=InitialPositionInStream.LATEST,
        checkpointInterval=batchInterval,
        storageLevel=StorageLevel.MEMORY_ONLY,
    )

    def esink(f):
        def func(*args, **kwargs):
            try:
                f(*args, **kwargs)
            except Exception as e:
                print(f'{f.__name__} raised exception {str(e)}')
        return func

    @esink
    def get_output(_, rdd: RDD):

        if (len(rdd.take(1)) == 0):
            print('No record')
            return

        print('New RDD is coming ...')
        print(f'No. of RDD partitions - {rdd.getNumPartitions()}')
        data = rdd.collect()
        for e in data:
            print(e)

        print(f'Data entry count = {len(data)}')

        # Test the case when processing time longer than the interval
        # T = 10
        # print(f'Sleep for {T} seconds ...')
        # time.sleep(T)
        # print('Done sleep!')

    # Exception in the get_output function can stop the streaming
    stream.foreachRDD(get_output)

    print('Start streaming ...')
    ssc.start()
    ssc.awaitTermination()


if __name__ == '__main__':
    run()
