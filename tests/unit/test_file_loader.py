from pathlib import Path

from src.ingestion.file_loader import load_crm_relationships


def test_load_crm_relationships_reads_expected_columns() -> None:
    frame = load_crm_relationships(Path("sample_data") / "crm_relationships.csv")
    assert "investor_name" in frame.columns
    assert "relationship_owner" in frame.columns
    assert len(frame) >= 1
