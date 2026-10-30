"""Readers for the repo files the tests compare."""

import re
import tomllib
from pathlib import Path

import json5

REPO = Path(__file__).resolve().parent.parent


def read_toml(path: str) -> dict:
    return tomllib.loads((REPO / path).read_text())


def read_jsonc(path: str) -> dict:
    """JSON with comments (devcontainer.json, the .vscode files)."""
    return json5.loads((REPO / path).read_text())


def dockerfile_args() -> dict[str, str]:
    """Every `ARG NAME=value` in the Dockerfile, by name."""
    text = (REPO / "Dockerfile").read_text()
    return dict(re.findall(r"^ARG (\w+)=(\S+)$", text, re.MULTILINE))


def mise_tools() -> dict[str, str]:
    """Tool name to version from mise.toml, whether given inline or as a table."""
    tools = read_toml("mise.toml")["tools"]
    return {
        name: spec["version"] if isinstance(spec, dict) else spec
        for name, spec in tools.items()
    }
