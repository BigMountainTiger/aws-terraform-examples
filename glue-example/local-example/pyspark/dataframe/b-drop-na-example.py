from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.ml.feature import Imputer

spark = SparkSession.builder.appName('drop-na-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel("ERROR")


def run():
    print()
    data = spark.createDataFrame([
        Row(col_1=1, col_2=1, col_3=1, col_4=1),
        Row(col_1=2, col_2=2, col_3=2, col_4=2),
        Row(col_1=3, col_2=3, col_3=3, col_4=3),
        Row(col_1=4, col_2=4, col_3=4, col_4=4),
        Row(col_1=5, col_2=5, col_3=5, col_4=5),
        Row(col_1=6, col_2=6, col_3=6, col_4=6),
        Row(col_1=7, col_2=7, col_3=7, col_4=None),
        Row(col_1=8, col_2=8, col_3=None, col_4=None),
        Row(col_1=9, col_2=None, col_3=None, col_4=None),
        Row(col_1=None, col_2=None, col_3=None, col_4=None),
    ])

    data.printSchema()
    data.show()

    print('Select columns')
    df = data.select('col_1', 'col_2')
    df.show()

    print('Drop columns')
    df = data.drop('col_3', 'col_4')
    df.show()

    print('Drop row with any n/a')
    df = data.na.drop(how='any')
    df.show()

    print('Drop row with all n/a')
    df = data.na.drop(how='all')
    df.show()

    threshold = 3
    print(
        f'Drop row with threshold = {threshold} => BUT keep the rows with at least {threshold} Non-null fields')
    df = data.na.drop(thresh=threshold)
    df.show()

    print('Drop row with any n/a but only check the subset')
    df = data.na.drop(subset=('col_1', 'col_2'))
    df.show()

    print('Drop row with any n/a but only check the subset => BUT keep the rows with at least 2 Non-null fields')
    print('The row 8 is dropped, because we are not counting col_1 (it is Non-null)')
    df = data.na.drop(subset=('col_2', 'col_3', 'col_4'), thresh=2)
    df.show()

    print('Drop row with all n/a but only check the subset')
    df = data.na.drop(how='all', subset=('col_2', 'col_3'))
    df.show()

    print('Missing values')
    print('Imputer')
    print('https://spark.apache.org/docs/latest/api/python/reference/api/pyspark.ml.feature.Imputer.html')
    cols = ['col_3', 'col_4']
    imputer = Imputer(inputCols=cols,
                      outputCols=["{}_imputed".format(c) for c in cols]).setStrategy('mean')
    df = imputer.fit(data).transform(data)
    df.show()

    print('Select the columns and rename them')
    df = df.selectExpr('col_1', 'col_2', 'col_3_imputed as col_3', 'col_4_imputed as col_4')
    df.show()


if __name__ == '__main__':
    run()
