"""The VS Code extension lists. The two repo lists (what this repo needs, in
the container and as recommendations) must agree. The host list in
packages.toml is a different set: what the Mac installs globally."""

import pytest

from helpers import read_jsonc, read_toml

LISTS = {
    "devcontainer.json": lambda: read_jsonc(".devcontainer/devcontainer.json")["customizations"][
        "vscode"
    ]["extensions"],
    ".vscode/extensions.json": lambda: read_jsonc(".vscode/extensions.json")["recommendations"],
    "packages.toml": lambda: read_toml("home/.chezmoidata/packages.toml")["packages"]["vscode"][
        "extensions"
    ],
}


@pytest.mark.parametrize("name", LISTS)
def test_list_is_sorted_and_unique(name):
    ids = LISTS[name]()
    assert ids == sorted(ids, key=str.lower), f"{name}: not sorted"
    assert len({i.lower() for i in ids}) == len(ids), f"{name}: duplicate"


def test_repo_lists_agree():
    assert LISTS["devcontainer.json"]() == LISTS[".vscode/extensions.json"]()
