#!/usr/bin/env python
import json
import re
import sys

with open(sys.argv[1]) as f:
    data = f.read()

ruff_errors = json.loads(data)
stats = {}

for ruff_error in ruff_errors:
    if ruff_error["code"] not in stats:
        code = ruff_error["code"]
        if code.startswith("T10"):
            rule_family = "T10"
        elif code.startswith("T20"):
            rule_family = "T20"
        elif code.startswith("C4"):
            rule_family = "C4"
        elif code.startswith("C90"):
            rule_family = "C90"
        else:
            rule_family = re.match(r"^([A-Za-z]+)\d+$", code).groups()[0]

        rule_num = code[len(rule_family) :]
        stats[ruff_error["code"]] = {
            "rule_family": rule_family,
            "rule_num": rule_num,
            "name": ruff_error["url"].rsplit("/", 1)[1],
            "fixable-safe": 0,
            "fixable-unsafe": 0,
            "total": 0,
        }
    i_stat = stats[ruff_error["code"]]
    i_stat["total"] += 1
    if ruff_error["fix"]:
        if ruff_error["fix"]["applicability"] == "safe":
            i_stat["fixable-safe"] += 1
        elif ruff_error["fix"]["applicability"] == "unsafe":
            i_stat["fixable-unsafe"] += 1

print("rule_family,rule_num,name,fixable-safe,fixable-unsafe,total")
for code, details in stats.items():
    print(
        f"{details['rule_family']},{details['rule_num']},{details['name']},{details['fixable-safe']},{details['fixable-unsafe']},{details['total']}"
    )
