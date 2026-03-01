#!/usr/bin/python3
import json
import os.path
import urllib.request
import re
import shutil
import subprocess

package_dir = os.path.dirname(__file__)

all_releases = json.load(urllib.request.urlopen("https://api.github.com/repos/posit-dev/air/releases"))
all_releases.reverse()  # Old releases first

for i, rel in enumerate(all_releases):
    print("==== Version %s" % rel["name"])
    rv = subprocess.call((
        "git",
        "rev-parse",
        "--verify",
        "--quiet",
        "v%s" % rel["name"],
    ))
    if rv == 0:
        continue

    # Rewrite DESCRIPTION
    desc_path = os.path.join(package_dir, "DESCRIPTION")
    desc = []
    with open(desc_path, "r") as f:
        for l in f:
            # Replace Version with current version
            if re.match(r"^Version: [0-9_\.\-]+\n$", l) is not None:
                l = "Version: %s\n" % rel["name"]
            desc.append(l)
    with open(desc_path, "w") as f:
        for l in desc:
            f.write(l)

    # Populate asset directory with binaries
    releases_path = os.path.join(package_dir, "src", "releases.txt")
    with open(releases_path, "w") as f:
        f.write("name\turl\tdigest\n")
        for a in rel['assets']:
            if not a['name'].startswith("air-"):
                continue
            if a['name'].endswith('.sha256'):
                continue
            if a['name'].startswith("air-installer"):
                continue

            f.write("\t".join((
              a["name"],
              a["browser_download_url"],
              a.get("digest", "") or "",
            )))
            f.write("\n")

    # Fill NEWS.md with all history
    news_path = os.path.join(package_dir, "NEWS.md")
    with open(news_path, "w") as f:
        for j in reversed(range(i + 1)):
            f.write("# Version %s\n\n%s\n" % (
                all_releases[j]["name"],
                re.sub(r'## Install air.*', "", all_releases[j]["body"], flags=re.DOTALL),
            ))

    # Commit & tag release
    subprocess.call((
        "git",
        "add",
        desc_path,
        releases_path,
        news_path,
    ))
    subprocess.call((
        "git",
        "commit",
        "-m",
        "Version %s" % rel["name"]
    ))
    subprocess.call((
        "git",
        "tag",
        "-am",
        "Version %s" % rel["name"],
        "v%s" % rel["name"],
    ))
