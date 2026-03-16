from __future__ import annotations

from pyspark.sql import DataFrame, SparkSession, functions as F


def build_signal_features(signals: DataFrame) -> DataFrame:
    return (
        signals.withColumn("is_target_sector", F.col("sector").isin(["Fintech", "Data Infrastructure"]))
        .withColumn("is_target_stage", F.col("preferred_round_type").isin(["Series A", "Series B"]))
        .withColumn(
            "fit_signal_strength",
            F.when(F.col("is_target_sector") & F.col("is_target_stage"), F.lit(1.0)).otherwise(F.lit(0.55)),
        )
        .groupBy("investor")
        .agg(
            F.avg("signal_strength").alias("avg_signal_strength"),
            F.max("fit_signal_strength").alias("fit_signal_strength"),
            F.countDistinct("company_name").alias("distinct_companies_seen"),
        )
    )


def materialize_feature_example() -> None:
    spark = SparkSession.builder.master("local[*]").appName("capital-raising-features").getOrCreate()
    data = [
        ("North Harbor Growth Partners", "AtlasPay", "Fintech", "Series B", 0.92),
        ("North Harbor Growth Partners", "LedgerSpring", "Data Infrastructure", "Series A", 0.88),
        ("Summit Ridge Ventures", "GridForge", "Industrial AI", "Series A", 0.67),
    ]
    frame = spark.createDataFrame(
        data,
        ["investor", "company_name", "sector", "preferred_round_type", "signal_strength"],
    )
    build_signal_features(frame).show(truncate=False)
    spark.stop()


if __name__ == "__main__":
    materialize_feature_example()
