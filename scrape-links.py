#!/usr/bin/env python3

import sys

from bs4 import BeautifulSoup

html = sys.argv[1]

if html is None:
    html = "page.html"

with open(html, "r") as f:
    soup = BeautifulSoup(f.read(), "html.parser")
    for link in soup.find_all("a"):
        print(link.get('href'))
