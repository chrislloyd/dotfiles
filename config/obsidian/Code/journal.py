from sys import argv
import os
from datetime import datetime
from pyjsoncanvas import (
    Canvas,
    TextNode,
    FileNode,
    Color,
)
from collections import defaultdict

vault = argv[1]

dir = os.path.join(vault, "Dailies")

files = [file for file in os.listdir(dir) if file.endswith(".md")]
dates = [datetime.strptime(os.path.splitext(file)[0], "%Y-%m-%d").date() for file in files]

grouped_dates = defaultdict(list)
for d in dates:
    year, week, _ = d.isocalendar()
    grouped_dates[(year, week)].append(d)

canvas = Canvas(nodes=[], edges=[])

GRID = 40
WIDTH = 9 * GRID
HEIGHT = 12 * GRID
GAP = 1 * GRID

for y, ((year, week), days) in enumerate(sorted(grouped_dates.items())):
    group = TextNode(
        x=0,
        y=y * (HEIGHT + GAP),
        width=WIDTH,
        height=HEIGHT,
        text=f"# {year} W{week}",
        color=Color("5"), # teal
    )
    canvas.add_node(group)

    for i, day in enumerate(sorted(days)):
        file = os.path.join("Dailies", day.strftime("%Y-%m-%d.md"))
        text_node = FileNode(
            x=(i+1) * (WIDTH + GAP),
            y=y * (HEIGHT + GAP),
            width=WIDTH,
            height=HEIGHT,
            file=file,
        )
        canvas.add_node(text_node)

print(canvas.to_json())
