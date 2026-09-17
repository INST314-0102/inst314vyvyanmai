"""Custom classroom50 autograder for the intro.R assignment.

Place this file at:
    CLASSROOM/autograders/ASSIGNMENT/autograder.py
in your `classroom50` config repo (replace CLASSROOM/ASSIGNMENT with your
actual classroom short name and assignment slug). No runtime block is
needed -- every check here is plain text/regex parsing, no R required.

Checks (each worth WEIGHTS[name] points, edit freely):
  1. file_exists            -- source-code/intro.R exists
  2. first_line_format      -- first line is `# LastName, FirstName`
  3. has_rm_list_ls         -- contains rm(list = ls())
  4. has_library_tidyverse  -- contains library(tidyverse)
  5. fscore_values          -- fscore <- c(...) has the 6 required numbers
"""

import datetime
import json
import os
import re
from decimal import Decimal
from pathlib import Path

FILE = "source-code/intro.R"
REQUIRED_FSCORE = ["0.025", "0.037", "0.123", "0.218", "0.115", "0.254"]

# Point value for each test -- adjust weighting here.
WEIGHTS = {
    "file_exists": 1,
    "first_line_format": 1,
    "has_rm_list_ls": 1,
    "has_library_tidyverse": 1,
    "fscore_values": 1,
}

tests = []


def add_test(name, passed, detail=None):
    entry = {
        "test-name": name,
        "passed": passed,
        "score": WEIGHTS[name] if passed else 0,
        "max-score": WEIGHTS[name],
    }
    if detail:
        entry["detail"] = detail
    tests.append(entry)


def strip_r_comments(text):
    """Remove '# ...' comments from R source, respecting quoted strings."""
    out = []
    in_single = in_double = False
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == "'" and not in_double:
            in_single = not in_single
            out.append(ch)
        elif ch == '"' and not in_single:
            in_double = not in_double
            out.append(ch)
        elif ch == "#" and not in_single and not in_double:
            while i < len(text) and text[i] != "\n":
                i += 1
            out.append("\n")
        else:
            out.append(ch)
        i += 1
    return "".join(out)


path = Path(FILE)

if not path.is_file():
    add_test(
        "file_exists",
        False,
        f"Missing required file: {FILE}. Create the folder 'source-code' "
        "and put your file there with the exact name intro.R.",
    )
    for name in (
        "first_line_format",
        "has_rm_list_ls",
        "has_library_tidyverse",
        "fscore_values",
    ):
        add_test(name, False, "Skipped: source file was missing.")
else:
    add_test("file_exists", True)

    raw = path.read_text(encoding="utf-8", errors="replace")
    text = raw.replace("\r\n", "\n")

    # --- 2. First line ---
    first_line = text.split("\n", 1)[0].rstrip("\r")
    placeholder = first_line == "# LastName, FirstName"
    first_line_regex = re.compile(
        r"^#\s*[A-Za-z][A-Za-z' -]*,\s*[A-Za-z][A-Za-z' -]*\s*$"
    )
    if placeholder:
        add_test(
            "first_line_format",
            False,
            "Replace the placeholder with your actual name, e.g. "
            f"'# Smith, Jane'. Found: {first_line!r}",
        )
    elif not first_line_regex.match(first_line):
        add_test(
            "first_line_format",
            False,
            "First line must be a comment in the format "
            f"'# LastName, FirstName'. Found: {first_line!r}",
        )
    else:
        add_test("first_line_format", True)

    code = strip_r_comments(text)

    # --- 3. rm(list = ls()) ---
    has_rm = re.search(r"rm\s*\(\s*list\s*=\s*ls\s*\(\s*\)\s*\)", code) is not None
    add_test(
        "has_rm_list_ls",
        has_rm,
        None if has_rm else "Missing required line: rm(list = ls())",
    )

    # --- 4. library(tidyverse) ---
    has_lib = re.search(r"library\s*\(\s*tidyverse\s*\)", code) is not None
    add_test(
        "has_library_tidyverse",
        has_lib,
        None if has_lib else "Missing required line: library(tidyverse)",
    )

    # --- 5. fscore values ---
    m = re.search(r"\bfscore\b\s*(?:<-|=)\s*c\s*\((.*?)\)", code, re.S)
    if not m:
        add_test(
            "fscore_values", False, "Could not find `fscore <- c(...)` in the file."
        )
    else:
        nums = re.findall(r"[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?", m.group(1))
        if not nums:
            add_test(
                "fscore_values",
                False,
                "Found `fscore <- c(...)` but no numeric values inside.",
            )
        else:
            got = sorted(Decimal(x) for x in nums)
            required = sorted(Decimal(x) for x in REQUIRED_FSCORE)
            if got == required:
                add_test("fscore_values", True)
            else:
                add_test(
                    "fscore_values",
                    False,
                    "fscore does not contain the required values. "
                    f"Found: {[str(x) for x in got]}, "
                    f"Expected: {[str(x) for x in required]}",
                )

result = {
    "schema": "classroom50/result/v1",
    "classroom": os.environ["CLASSROOM"],
    "assignment": os.environ["ASSIGNMENT"],
    # owner + assignment_type are stamped authoritatively by the runner.
    "submission": os.environ["SUBMISSION_TAG"],
    "commit": os.environ["COMMIT_URL"],
    "release": os.environ["RELEASE_URL"],
    "review": os.environ.get("REVIEW_URL") or os.environ["COMMIT_URL"],
    "datetime": datetime.datetime.now(datetime.timezone.utc).strftime(
        "%Y-%m-%dT%H:%M:%SZ"
    ),
    "score": sum(t["score"] for t in tests),
    "max-score": sum(t["max-score"] for t in tests),
    "tests": tests,
}

Path("result.json").write_text(json.dumps(result, indent=2))