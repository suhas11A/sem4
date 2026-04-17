import sys
import os
from typing import List, Sequence, Tuple

from geometry import Point, format_number
from triangulation import triangulate_gallery

import matplotlib.pyplot as plt

def plot_gallery(
    testcase_id: int,
    outer: Sequence[Point],
    holes: Sequence[Sequence[Point]],
    simple_polygon: Sequence[Point],
    triangles: Sequence[Tuple[int, int, int]],
    guard_points: Sequence[Point],
    out_path: str,
) -> None:
    polygon_color = "tab:blue"
    hole_color = "tab:red"

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 7))

    # ---------- LEFT: input polygon with holes ----------
    ox = [p.x for p in outer] + [outer[0].x]
    oy = [p.y for p in outer] + [outer[0].y]

    ax1.plot(ox, oy, color=polygon_color, linewidth=2.5, zorder=3)

    for hole in holes:
        hx = [p.x for p in hole] + [hole[0].x]
        hy = [p.y for p in hole] + [hole[0].y]
        ax1.plot(hx, hy, color=hole_color, linewidth=2.2, zorder=4)

    ax1.set_title(f"Test case {testcase_id}: Input polygon")
    ax1.set_aspect('equal', adjustable='box')
    ax1.grid(True, alpha=0.25)

    # ---------- RIGHT: triangulation ----------
    for a, b, c in triangles:
        tri = [simple_polygon[a], simple_polygon[b], simple_polygon[c]]
        tx = [p.x for p in tri] + [tri[0].x]
        ty = [p.y for p in tri] + [tri[0].y]

        ax2.fill(
            [p.x for p in tri],
            [p.y for p in tri],
            color=polygon_color,
            alpha=0.18,
            zorder=1,
        )
        ax2.plot(tx, ty, color=polygon_color, linewidth=1.0, zorder=2)

    ax2.plot(ox, oy, color=polygon_color, linewidth=2.5, zorder=4)

    for hole in holes:
        hx = [p.x for p in hole] + [hole[0].x]
        hy = [p.y for p in hole] + [hole[0].y]
        ax2.plot(hx, hy, color=hole_color, linewidth=2.2, zorder=6)

    if guard_points:
        ax2.scatter(
            [p.x for p in guard_points],
            [p.y for p in guard_points],
            s=55,
            marker='o',
            color='black',
            zorder=7,
        )

    ax2.set_title(f"Test case {testcase_id}: Triangulation")
    ax2.set_aspect('equal', adjustable='box')
    ax2.grid(True, alpha=0.25)

    all_pts = list(outer)
    for hole in holes:
        all_pts.extend(hole)

    min_x = min(p.x for p in all_pts)
    max_x = max(p.x for p in all_pts)
    min_y = min(p.y for p in all_pts)
    max_y = max(p.y for p in all_pts)

    pad_x = max(1.0, 0.08 * (max_x - min_x if max_x > min_x else 1.0))
    pad_y = max(1.0, 0.08 * (max_y - min_y if max_y > min_y else 1.0))

    for ax in (ax1, ax2):
        ax.set_xlim(min_x - pad_x, max_x + pad_x)
        ax.set_ylim(min_y - pad_y, max_y + pad_y)

    fig.tight_layout()
    fig.savefig(out_path, dpi=200, bbox_inches='tight')
    plt.close(fig)

def read_testcases(tokens: List[str]):
    idx = 0

    def nxt(label: str) -> str:
        nonlocal idx
        if idx >= len(tokens):
            raise ValueError(f"Input ended early while reading {label} at token index {idx}")
        val = tokens[idx]
        idx += 1
        return val

    t = int(nxt("T"))
    tests = []
    for tc in range(1, t + 1):
        v0 = int(nxt(f"v0 of testcase {tc}"))
        outer = []
        for j in range(v0):
            x = float(nxt(f"outer vertex {j} x of testcase {tc}"))
            y = float(nxt(f"outer vertex {j} y of testcase {tc}"))
            outer.append(Point(x, y))
        h = int(nxt(f"h of testcase {tc}"))
        holes = []
        for hi in range(1, h + 1):
            vi = int(nxt(f"v{hi} of hole {hi} in testcase {tc}"))
            hole = []
            for j in range(vi):
                x = float(nxt(f"hole {hi} vertex {j} x of testcase {tc}"))
                y = float(nxt(f"hole {hi} vertex {j} y of testcase {tc}"))
                hole.append(Point(x, y))
            holes.append(hole)
        tests.append((outer, holes))
    if idx != len(tokens):
        print(f"Warning: {len(tokens) - idx} extra tokens at end of input")
    return tests


def solve(stdin: str) -> str:
    tokens = stdin.strip().split()
    if not tokens:
        return ''
    tests = read_testcases(tokens)
    output_lines: List[str] = []
    for tc_id, (outer, holes) in enumerate(tests, start=1):
        # print(tc_id)
        result = triangulate_gallery(outer, holes)
        triangles = result['triangles']
        guard_points = result['guard_points']
        bound = result['theoretical_bound']

        # output_lines.append("Triangles:")
        for tri in triangles:
            pts = [result['simple_polygon'][idx] for idx in tri]
            output_lines.append(" ".join(f"({format_number(p.x)},{format_number(p.y)})" for p in pts))

        output_lines.append(f"{len(guard_points)}")
        if guard_points:
            output_lines.append("".join(f"({format_number(p.x)},{format_number(p.y)})\n" for p in guard_points))
            output_lines.append("")
        else:
            output_lines.append("")

        plot_gallery(
            testcase_id=tc_id,
            outer=outer,
            holes=holes,
            simple_polygon=result['simple_polygon'],
            triangles=triangles,
            guard_points=guard_points,
            out_path=f"plots/triangulation_case_{tc_id}.png",
        )
    return "\n".join(output_lines)


def main() -> None:
    data = sys.stdin.read()
    sys.stdout.write(solve(data))


if __name__ == '__main__':
    main()
