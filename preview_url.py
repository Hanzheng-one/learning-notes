"""Print the local preview URL based on site_url in mkdocs.yml.

Why a separate file: quoting rules inside .bat are fragile. Keeping the
logic in Python avoids escaping problems entirely.
"""

import pathlib
import re
import urllib.parse

DEFAULT_PORT = 8000


def sub_path() -> str:
    try:
        text = pathlib.Path("mkdocs.yml").read_text(encoding="utf-8")
    except OSError:
        return ""
    match = re.search(r"site_url:\s*(\S+)", text)
    if not match:
        return ""
    return urllib.parse.urlparse(match.group(1)).path.strip("/")


def main() -> None:
    path = sub_path()
    if path:
        url = f"http://127.0.0.1:{DEFAULT_PORT}/{path}/"
    else:
        url = f"http://127.0.0.1:{DEFAULT_PORT}/"
    print(f"  >>> {url}")


if __name__ == "__main__":
    main()
