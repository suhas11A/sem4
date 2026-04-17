import math
import random

from typing import List, Sequence

EPS = 1e-9
RNG = random.Random(0)

class Point:
    def __init__(self, x, y):
        self.x = float(x)
        self.y = float(y)


def orient(a: Point, b: Point, c: Point) -> float:
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)


def dist2(a: Point, b: Point) -> float:
    dx = a.x - b.x
    dy = a.y - b.y
    return dx * dx + dy * dy


def polygon_area(poly: Sequence[Point]) -> float:
    area = 0.0
    n = len(poly)
    for i in range(n):
        j = (i + 1) % n
        area += poly[i].x * poly[j].y - poly[j].x * poly[i].y
    return area / 2.0


def cycle_area(indices: Sequence[int], pts: Sequence[Point]) -> float:
    area = 0.0
    n = len(indices)
    for i in range(n):
        a = pts[indices[i]]
        b = pts[indices[(i + 1) % n]]
        area += a.x * b.y - b.x * a.y
    return area / 2.0


def ensure_ccw(poly: List[Point]) -> List[Point]:
    if polygon_area(poly) < 0:
        return list(reversed(poly))
    return poly[:]


def ensure_cw(poly: List[Point]) -> List[Point]:
    if polygon_area(poly) > 0:
        return list(reversed(poly))
    return poly[:]


def same_point(a: Point, b: Point) -> bool:
    return abs(a.x - b.x) <= EPS and abs(a.y - b.y) <= EPS


def on_segment(a: Point, b: Point, p: Point) -> bool:
    if abs(orient(a, b, p)) > EPS:
        return False
    return (
        min(a.x, b.x) - EPS <= p.x <= max(a.x, b.x) + EPS and
        min(a.y, b.y) - EPS <= p.y <= max(a.y, b.y) + EPS
    )


def segments_intersect(a: Point, b: Point, c: Point, d: Point) -> bool:
    oa = orient(c, d, a)
    ob = orient(c, d, b)
    oc = orient(a, b, c)
    od = orient(a, b, d)

    if ((oa > EPS and ob < -EPS) or (oa < -EPS and ob > EPS)) and ((oc > EPS and od < -EPS) or (oc < -EPS and od > EPS)):
        return True
    if abs(oa) <= EPS and on_segment(c, d, a):
        return True
    if abs(ob) <= EPS and on_segment(c, d, b):
        return True
    if abs(oc) <= EPS and on_segment(a, b, c):
        return True
    if abs(od) <= EPS and on_segment(a, b, d):
        return True
    return False


def strict_segment_intersection(a: Point, b: Point, c: Point, d: Point) -> bool:
    if not segments_intersect(a, b, c, d):
        return False
    for p in (a, b):
        for q in (c, d):
            if same_point(p, q):
                return False
    return True


def point_in_simple_polygon(pt: Point, poly: Sequence[Point]) -> bool:
    inside = False
    n = len(poly)
    for i in range(n):
        a = poly[i]
        b = poly[(i + 1) % n]
        if on_segment(a, b, pt):
            return True
        yi = (a.y > pt.y)
        yj = (b.y > pt.y)
        if yi != yj:
            xint = a.x + (pt.y - a.y) * (b.x - a.x) / (b.y - a.y)
            if xint >= pt.x - EPS:
                inside = not inside
    return inside


def point_in_triangle(p: Point, a: Point, b: Point, c: Point) -> bool:
    s1 = orient(a, b, p)
    s2 = orient(b, c, p)
    s3 = orient(c, a, p)
    pos = (s1 >= -EPS and s2 >= -EPS and s3 >= -EPS)
    neg = (s1 <= EPS and s2 <= EPS and s3 <= EPS)
    return pos or neg


def angle_of(u: Point, v: Point) -> float:
    return math.atan2(v.y - u.y, v.x - u.x)


def vertex_above(a: Point, b: Point) -> bool:
    return a.y > b.y + EPS or (abs(a.y - b.y) <= EPS and a.x < b.x - EPS)


def vertex_below(a: Point, b: Point) -> bool:
    return a.y < b.y - EPS or (abs(a.y - b.y) <= EPS and a.x > b.x + EPS)


def edge_intersection_x_at_y(a: Point, b: Point, y: float) -> float:
    if abs(a.y - b.y) <= EPS:
        return min(a.x, b.x)
    t = (y - a.y) / (b.y - a.y)
    return a.x + t * (b.x - a.x)


def normalize_input_polygon(poly: List[Point]) -> List[Point]:
    out = poly[:]
    if len(out) >= 2 and same_point(out[0], out[-1]):
        out.pop()
    return out


def format_number(x: float) -> str:
    if abs(x - round(x)) <= 1e-9:
        return str(int(round(x)))
    s = f"{x:.10f}".rstrip('0').rstrip('.')
    return '0' if s == '-0' else s
