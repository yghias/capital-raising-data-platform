from pathlib import Path
import re


MARKDOWN_LINK = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


def test_repo_markdown_links_point_to_existing_files() -> None:
    docs = [
        Path("README.md"),
        Path("ARCHITECTURE.md"),
        Path("DATA_MODEL.md"),
        Path("PIPELINES.md"),
        Path("API_INTEGRATIONS.md"),
        Path("GOVERNANCE.md"),
        Path("OBSERVABILITY.md"),
        Path("CI_CD.md"),
        Path("SECURITY.md"),
        Path("TESTING.md"),
        Path("RUNBOOK.md"),
        Path("ROADMAP.md"),
        Path("USE_CASES.md"),
    ]
    for doc in docs:
        content = doc.read_text(encoding="utf-8")
        for target in MARKDOWN_LINK.findall(content):
            if target.startswith("http://") or target.startswith("https://"):
                continue
            assert not target.startswith("/"), f"Absolute path link in {doc}: {target}"
            assert "/Users/" not in target, f"Filesystem path link in {doc}: {target}"
            assert Path(target).exists(), f"Broken link in {doc}: {target}"
