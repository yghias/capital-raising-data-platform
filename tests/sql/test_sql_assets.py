from pathlib import Path


def test_expected_sql_files_exist() -> None:
    expected = [
        Path("sql/schema.sql"),
        Path("sql/marts.sql"),
        Path("sql/tests.sql"),
        Path("sql/semantic_metrics.sql"),
        Path("sql/reconciliation.sql"),
        Path("sql/canonicalization.sql"),
    ]
    for path in expected:
        assert path.exists(), f"Missing SQL asset: {path}"
