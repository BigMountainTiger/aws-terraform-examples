from pyspark.context import SparkContext
from awsglue.context import GlueContext


def run():
    context = SparkContext.getOrCreate()
    context.setLogLevel('ERROR')

    data = ('This', 'is', 'is', 'cool', 'and', 'cool')
    rdd = context.parallelize(data, 2).cache()

    print('\ncountByValue:')
    wordCounts = rdd.countByValue()
    for word, count in wordCounts.items():
        print("{}: {}".format(word, count))

    print('\nreduceByKey:')
    new_rdd = rdd.map(lambda x: (x, 1), preservesPartitioning=True)
    result = new_rdd.reduceByKey(lambda a, b: a + b).collect()

    print(result)
    for word, count in result:
        print("{} : {}".format(word, count))


if __name__ == '__main__':
    run()
