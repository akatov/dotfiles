"""Tool versions agree across their three homes: mise.toml (host, CI), the
Dockerfile ARGs (devcontainer), and .chezmoiversion (chezmoi itself)."""

import pytest

from helpers import REPO, dockerfile_args, mise_tools

# Built from source in the image and not host tools, so no mise.toml entry.
NOT_HOST_TOOLS = {"EMACS", "TREE_SITTER"}

MISE = mise_tools()
ARGS = dockerfile_args()


def arg_name(tool: str) -> str:
    return tool.upper().replace("-", "_") + "_VERSION"


@pytest.mark.parametrize("tool", sorted(MISE))
def test_mise_tool_is_pinned_identically_in_the_dockerfile(tool):
    arg = arg_name(tool)
    assert arg in ARGS, f"mise.toml has {tool}, the Dockerfile has no ARG {arg}"
    assert ARGS[arg] == MISE[tool], f"{tool}: mise.toml {MISE[tool]}, Dockerfile {ARGS[arg]}"


def test_every_dockerfile_version_arg_is_a_mise_tool():
    version_args = {name for name in ARGS if name.endswith("_VERSION")}
    expected = {arg_name(tool) for tool in MISE} | {f"{t}_VERSION" for t in NOT_HOST_TOOLS}
    assert version_args - expected == set(), "Dockerfile ARGs missing from mise.toml"


def test_chezmoiversion_matches_mise():
    assert (REPO / ".chezmoiversion").read_text().strip() == MISE["chezmoi"]
