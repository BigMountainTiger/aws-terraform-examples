from pyspark.sql import SparkSession

def get_spark_session():
    return SparkSession.builder \
        .appName("GlueLocalIceberg") \
        .config("spark.log.level", "ERROR") \
        .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions") \
        .config("spark.sql.catalog.glue_catalog", "org.apache.iceberg.spark.SparkCatalog") \
        .config("spark.sql.catalog.glue_catalog.catalog-impl", "org.apache.iceberg.aws.glue.GlueCatalog") \
        .config("spark.sql.catalog.glue_catalog.io-impl", "org.apache.iceberg.aws.s3.S3FileIO") \
        .config("spark.sql.catalog.glue_catalog.warehouse", "s3://your-iceberg-warehouse-bucket/path/") \
        .getOrCreate()