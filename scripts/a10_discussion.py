#!/usr/bin/env python3
"""Generate A-10 discussion assets for GitHub Actions."""

from __future__ import annotations

import datetime as _dt
import json
import os
import subprocess
from pathlib import Path
from typing import Iterable, List, Sequence


def _read_env(name: str, default: str = "") -> str:
    value = os.environ.get(name, "").strip()
    return value or default


def _git_command(args: Sequence[str], cwd: Path) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=str(cwd),
        check=True,
        text=True,
        stdout=subprocess.PIPE,
    )
    return result.stdout.strip()


def _list_changed_files(repo_root: Path, before: str, after: str) -> List[str]:
    zero_commit = "0" * 40
    if not after:
        raise ValueError("After SHA must be provided")

    if not before or before == zero_commit:
        # Initial push – gather all tracked files in the current tree.
        output = _git_command(["ls-tree", "--full-tree", "-r", after, "--name-only"], repo_root)
    else:
        output = _git_command(["diff", "--name-only", before, after], repo_root)

    files = [line.strip() for line in output.splitlines() if line.strip()]
    files.sort()
    return files


def _format_section(title: str, lines: Iterable[str]) -> List[str]:
    items = list(lines)
    if not items:
        return [f"## {title}", "- _No changes detected._", ""]

    body = [f"## {title}"]
    body.extend(f"- {item}" for item in items)
    body.append("")
    return body


def _make_commentary(files: Sequence[str], directories: Sequence[str]) -> List[str]:
    total_files = len(files)
    total_dirs = len(set(directories))
    focus = "steady" if total_files < 5 else "wide"
    effect = "tactical" if total_dirs <= 3 else "strategic"

    commentary = ["## A-10 Commentary"]
    commentary.append(
        "- **Tactical Overview:** The A-10 analysis pass locked onto "
        f"{total_files} file{'s' if total_files != 1 else ''} across "
        f"{total_dirs} director{'ies' if total_dirs != 1 else 'y'}, maintaining a {focus} sweep."
    )
    commentary.append(
        "- **Effect on Mission:** Updates signal a {effect} shift—"
        "adjust downstream workflows and documentation accordingly."
    )
    commentary.append(
        "- **Next Steps:** Review discussion feedback, confirm deployments, and align the next sortie if required."
    )
    commentary.append("")
    return commentary


def main() -> None:
    repo_root = Path(_read_env("GITHUB_WORKSPACE", Path(__file__).resolve().parents[1]))
    before = _read_env("BEFORE_SHA")
    after = _read_env("AFTER_SHA")
    repository = _read_env("GITHUB_REPOSITORY", repo_root.name)

    files = _list_changed_files(repo_root, before, after)
    directories = sorted({str(Path(f).parent) if Path(f).parent != Path('.') else '.' for f in files})

    timestamp = _dt.datetime.now(_dt.timezone.utc).replace(microsecond=0)
    timestamp_str = timestamp.isoformat().replace("+00:00", "Z")
    reports_dir = Path("/reports")
    reports_dir.mkdir(parents=True, exist_ok=True)

    summary_lines: List[str] = ["# A-10 Run Summary", ""]
    summary_lines.append(f"- **Timestamp:** {timestamp_str}")
    summary_lines.append(f"- **Repository:** {repository}")
    summary_lines.append(f"- **Commit:** {after}")
    summary_lines.append("")

    summary_lines.extend(_format_section("Changed Files", files))
    summary_lines.extend(_format_section("Changed Directories", directories))
    summary_lines.extend(_make_commentary(files, directories))

    filename_stamp = timestamp_str.replace(":", "-")
    summary_path = reports_dir / f"a10-summary-{filename_stamp}.md"
    summary_path.write_text("\n".join(summary_lines), encoding="utf-8")

    discussion_title = f"A-10 Main Run | {timestamp_str}"
    discussion_body_path = reports_dir / f"a10-discussion-body-{filename_stamp}.md"
    discussion_body_path.write_text("\n".join(summary_lines), encoding="utf-8")

    output_payload = {
        "summary_path": str(summary_path),
        "discussion_title": discussion_title,
        "discussion_body_path": str(discussion_body_path),
        "timestamp": timestamp_str,
    }

    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output:
        with open(github_output, "a", encoding="utf-8") as handle:
            for key, value in output_payload.items():
                handle.write(f"{key}={value}\n")

    print(json.dumps(output_payload, indent=2))


if __name__ == "__main__":
    main()
