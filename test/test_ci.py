"""ci.yml: checks-pass is the one check branch protection requires, so it
must need every other job, or a job could fail without blocking a merge."""

import yaml

from helpers import REPO


def test_checks_pass_needs_every_other_job():
    jobs = yaml.safe_load((REPO / ".github/workflows/ci.yml").read_text())["jobs"]
    assert set(jobs["checks-pass"]["needs"]) == set(jobs) - {"checks-pass"}
