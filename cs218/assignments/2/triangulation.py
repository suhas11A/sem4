from typing import Dict, List, Optional, Sequence, Set, Tuple

from geometry import *

def bridge_visibility(m: Point, p: Point, current_boundary: Sequence[Point], other_holes: Sequence[Sequence[Point]]) -> bool:
    if same_point(m, p):
        return False
    mid = Point((m.x + p.x) / 2.0, (m.y + p.y) / 2.0)
    if not point_in_simple_polygon(mid, current_boundary):
        return False

    n = len(current_boundary)
    for i in range(n):
        a = current_boundary[i]
        b = current_boundary[(i + 1) % n]
        if same_point(a, p) or same_point(b, p):
            continue
        if strict_segment_intersection(m, p, a, b):
            return False

    for hole in other_holes:
        k = len(hole)
        for i in range(k):
            a = hole[i]
            b = hole[(i + 1) % k]
            if same_point(a, m) or same_point(b, m):
                continue
            if strict_segment_intersection(m, p, a, b):
                return False
    return True


def hole_rightmost_vertex(hole: Sequence[Point]) -> int:
    best = 0
    for i in range(1, len(hole)):
        if hole[i].x > hole[best].x + EPS or (
            abs(hole[i].x - hole[best].x) <= EPS and hole[i].y < hole[best].y - EPS
        ):
            best = i
    return best


def choose_bridge_vertex(
    hole: Sequence[Point],
    current_boundary: Sequence[Point],
    remaining_holes: Sequence[Sequence[Point]],
) -> Tuple[int, int]:
    m_idx = hole_rightmost_vertex(hole)
    m = hole[m_idx]

    candidates: List[Tuple[float, float, int]] = []
    for i, p in enumerate(current_boundary):
        if bridge_visibility(m, p, current_boundary, remaining_holes):
            right_penalty = 0.0 if p.x >= m.x - EPS else 1.0
            candidates.append((right_penalty, dist2(m, p), i))

    if not candidates:
        raise ValueError("Could not find a visible bridge from a hole to the current boundary.")

    candidates.sort(key=lambda t: (t[0], t[1], current_boundary[t[2]].y, current_boundary[t[2]].x))
    return m_idx, candidates[0][2]


def merge_hole_into_boundary(
    current_boundary_geom: Sequence[Point],
    current_boundary_disp: Sequence[Point],
    hole_geom: Sequence[Point],
    hole_disp: Sequence[Point],
    boundary_idx: int,
    hole_idx: int,
) -> Tuple[List[Point], List[Point]]:
    outer_g = list(current_boundary_geom)
    outer_d = list(current_boundary_disp)
    hole_g = list(hole_geom)
    hole_d = list(hole_disp)
    m = len(outer_g)
    k = len(hole_g)

    P_g = outer_g[boundary_idx]
    P_d = outer_d[boundary_idx]
    M_g = hole_g[hole_idx]
    M_d = hole_d[hole_idx]

    merged_g: List[Point] = [P_g, M_g]
    merged_d: List[Point] = [P_d, M_d]
    for step in range(1, k + 1):
        idx = (hole_idx + step) % k
        merged_g.append(hole_g[idx])
        merged_d.append(hole_d[idx])
    merged_g.append(P_g)
    merged_d.append(P_d)
    for step in range(1, m):
        idx = (boundary_idx + step) % m
        merged_g.append(outer_g[idx])
        merged_d.append(outer_d[idx])

    if polygon_area(merged_g) < 0:
        merged_g.reverse()
        merged_d.reverse()
    return merged_g, merged_d


def bridge_holes_into_simple_polygon(outer: List[Point], holes: List[List[Point]]) -> Tuple[List[Point], List[Point]]:
    current_boundary_geom = ensure_ccw(normalize_input_polygon(outer))
    current_boundary_disp = current_boundary_geom[:]
    normalized_holes = [ensure_cw(normalize_input_polygon(h)) for h in holes]

    order = list(range(len(normalized_holes)))
    order.sort(key=lambda idx: max(p.x for p in normalized_holes[idx]), reverse=True)

    remaining: List[List[Point]] = [normalized_holes[idx] for idx in order]
    while remaining:
        hole = remaining.pop(0)
        hole_idx, boundary_idx = choose_bridge_vertex(hole, current_boundary_geom, remaining)
        current_boundary_geom, current_boundary_disp = merge_hole_into_boundary(
            current_boundary_geom,
            current_boundary_disp,
            hole,
            hole,
            boundary_idx,
            hole_idx,
        )
    return current_boundary_geom, current_boundary_disp



class TreapNode:
    __slots__ = ('edge_idx', 'prio', 'left', 'right')

    def __init__(self, edge_idx: int):
        self.edge_idx = edge_idx
        self.prio = RNG.random()
        self.left: Optional['TreapNode'] = None
        self.right: Optional['TreapNode'] = None


class SweepLineStatus:
    def __init__(self, poly: Sequence[Point]):
        self.poly = poly
        self.root: Optional[TreapNode] = None
        self.sweep_y = 0.0

    def set_sweep_y(self, y: float) -> None:
        self.sweep_y = y

    def edge_key(self, edge_idx: int) -> Tuple[float, float, float]:
        a = self.poly[edge_idx]
        b = self.poly[(edge_idx + 1) % len(self.poly)]
        x = edge_intersection_x_at_y(a, b, self.sweep_y)
        x2 = edge_intersection_x_at_y(a, b, self.sweep_y - 1e-7)
        return (x, x2, float(edge_idx))

    def less(self, e1: int, e2: int) -> bool:
        return self.edge_key(e1) < self.edge_key(e2)

    def rotate_left(self, x: TreapNode) -> TreapNode:
        y = x.right
        assert y is not None
        x.right = y.left
        y.left = x
        return y

    def rotate_right(self, y: TreapNode) -> TreapNode:
        x = y.left
        assert x is not None
        y.left = x.right
        x.right = y
        return x

    def _insert(self, node: Optional[TreapNode], edge_idx: int) -> TreapNode:
        if node is None:
            return TreapNode(edge_idx)
        if self.less(edge_idx, node.edge_idx):
            node.left = self._insert(node.left, edge_idx)
            if node.left and node.left.prio < node.prio:
                node = self.rotate_right(node)
        elif self.less(node.edge_idx, edge_idx):
            node.right = self._insert(node.right, edge_idx)
            if node.right and node.right.prio < node.prio:
                node = self.rotate_left(node)
        return node

    def insert(self, edge_idx: int) -> None:
        self.root = self._insert(self.root, edge_idx)

    def _delete(self, node: Optional[TreapNode], edge_idx: int) -> Optional[TreapNode]:
        if node is None:
            return None
        if self.less(edge_idx, node.edge_idx):
            node.left = self._delete(node.left, edge_idx)
        elif self.less(node.edge_idx, edge_idx):
            node.right = self._delete(node.right, edge_idx)
        else:
            if node.left is None:
                return node.right
            if node.right is None:
                return node.left
            if node.left.prio < node.right.prio:
                node = self.rotate_right(node)
                node.right = self._delete(node.right, edge_idx)
            else:
                node = self.rotate_left(node)
                node.left = self._delete(node.left, edge_idx)
        return node

    def delete(self, edge_idx: int) -> None:
        self.root = self._delete(self.root, edge_idx)

    def find_left_edge(self, x: float) -> Optional[int]:
        node = self.root
        best: Optional[int] = None
        while node is not None:
            kx = self.edge_key(node.edge_idx)[0]
            if kx < x - EPS:
                best = node.edge_idx
                node = node.right
            else:
                node = node.left
        return best

def find_left_edge_with_helper(status: SweepLineStatus, x: float, helper: Dict[int, int]) -> Optional[int]:
    while True:
        left = status.find_left_edge(x)
        if left is None:
            return None
        if left in helper:
            return left
        status.delete(left)

START = 'start'
END = 'end'
SPLIT = 'split'
MERGE = 'merge'
REGULAR = 'regular'


def vertex_type(poly: Sequence[Point], i: int) -> str:
    n = len(poly)
    prev = poly[(i - 1) % n]
    curr = poly[i]
    nxt = poly[(i + 1) % n]
    reflex = orient(prev, curr, nxt) < -EPS

    if vertex_below(prev, curr) and vertex_below(nxt, curr):
        return SPLIT if reflex else START
    if vertex_above(prev, curr) and vertex_above(nxt, curr):
        return MERGE if reflex else END
    return REGULAR


def regular_vertex_interior_right(poly: Sequence[Point], i: int) -> bool:
    curr = poly[i]
    nxt = poly[(i + 1) % len(poly)]
    return vertex_below(nxt, curr)


def add_diagonal(diagonals: Set[Tuple[int, int]], u: int, v: int, n: int) -> None:
    if u == v:
        return
    if (u + 1) % n == v or (v + 1) % n == u:
        return
    diagonals.add(tuple(sorted((u, v))))


def e_next(i: int) -> int:
    return i


def e_prev(i: int, n: int) -> int:
    return (i - 1) % n


def make_monotone(poly: Sequence[Point]) -> List[Tuple[int, int]]:
    n = len(poly)
    status = SweepLineStatus(poly)
    helper: Dict[int, int] = {}
    diagonals: Set[Tuple[int, int]] = set()
    vtype = [vertex_type(poly, i) for i in range(n)]

    order = list(range(n))
    order.sort(key=lambda i: (-poly[i].y, poly[i].x))

    for i in order:
        status.set_sweep_y(poly[i].y - 1e-7)
        t = vtype[i]

        if t == START:
            status.insert(e_next(i))
            helper[e_next(i)] = i
        elif t == END:
            ep = e_prev(i, n)
            if ep in helper and vtype[helper[ep]] == MERGE:
                add_diagonal(diagonals, i, helper[ep], n)
            status.delete(ep)
            helper.pop(ep, None)
        elif t == SPLIT:
            left = find_left_edge_with_helper(status, poly[i].x, helper)
            if left is not None:
                add_diagonal(diagonals, i, helper[left], n)
                helper[left] = i
            status.insert(e_next(i))
            helper[e_next(i)] = i
        elif t == MERGE:
            ep = e_prev(i, n)
            if ep in helper and vtype[helper[ep]] == MERGE:
                add_diagonal(diagonals, i, helper[ep], n)
            status.delete(ep)
            helper.pop(ep, None)
            left = find_left_edge_with_helper(status, poly[i].x, helper)
            if left is not None:
                if vtype[helper[left]] == MERGE:
                    add_diagonal(diagonals, i, helper[left], n)
                helper[left] = i
        else:
            if regular_vertex_interior_right(poly, i):
                ep = e_prev(i, n)
                if ep in helper and vtype[helper[ep]] == MERGE:
                    add_diagonal(diagonals, i, helper[ep], n)
                status.delete(ep)
                helper.pop(ep, None)
                status.insert(e_next(i))
                helper[e_next(i)] = i
            else:
                left = find_left_edge_with_helper(status, poly[i].x, helper)
                if left is not None:
                    if vtype[helper[left]] == MERGE:
                        add_diagonal(diagonals, i, helper[left], n)
                    helper[left] = i

    return sorted(diagonals)


def monotone_chains(poly_indices: List[int], points: Sequence[Point]) -> Tuple[List[int], Dict[int, str]]:
    m = len(poly_indices)
    top_pos = min(range(m), key=lambda t: (-points[poly_indices[t]].y, points[poly_indices[t]].x))
    bottom_pos = min(range(m), key=lambda t: (points[poly_indices[t]].y, -points[poly_indices[t]].x))

    chain1: List[int] = []
    i = top_pos
    while True:
        chain1.append(poly_indices[i])
        if i == bottom_pos:
            break
        i = (i + 1) % m

    chain2: List[int] = []
    i = top_pos
    while True:
        chain2.append(poly_indices[i])
        if i == bottom_pos:
            break
        i = (i - 1 + m) % m

    def first_below(chain: List[int]) -> Point:
        return points[chain[1]] if len(chain) > 1 else points[chain[0]]

    p1 = first_below(chain1)
    p2 = first_below(chain2)
    if p1.x < p2.x - EPS:
        left_chain, right_chain = chain1, chain2
    else:
        left_chain, right_chain = chain2, chain1

    label: Dict[int, str] = {}
    for v in left_chain:
        label[v] = 'left'
    for v in right_chain:
        label[v] = 'right'
    label[left_chain[0]] = 'both'
    label[left_chain[-1]] = 'both'
    return sorted(poly_indices, key=lambda idx: (-points[idx].y, points[idx].x)), label


def triangulate_monotone_polygon(poly_indices: List[int], points: Sequence[Point]) -> List[Tuple[int, int]]:
    if len(poly_indices) <= 3:
        return []
    order, chain = monotone_chains(poly_indices, points)
    stack: List[int] = [order[0], order[1]]
    diagonals: List[Tuple[int, int]] = []

    for j in range(2, len(order) - 1):
        curr = order[j]
        curr_chain = chain[curr]
        top_chain = chain[stack[-1]]
        different_chain = (curr_chain != top_chain) and curr_chain != 'both' and top_chain != 'both'
        if different_chain:
            while len(stack) > 1:
                diagonals.append(tuple(sorted((curr, stack[-1]))))
                stack.pop()
            stack.pop()
            stack = [order[j - 1], curr]
        else:
            last = stack.pop()
            while stack:
                top = stack[-1]
                val = orient(points[curr], points[last], points[top])
                if curr_chain == 'left' or (curr_chain == 'both' and chain[last] == 'left'):
                    ok = val < -EPS
                else:
                    ok = val > EPS
                if not ok:
                    break
                diagonals.append(tuple(sorted((curr, top))))
                last = stack.pop()
            stack.append(last)
            stack.append(curr)

    last_vertex = order[-1]
    stack.pop()
    while len(stack) > 1:
        diagonals.append(tuple(sorted((last_vertex, stack[-1]))))
        stack.pop()

    seen: Set[Tuple[int, int]] = set()
    out: List[Tuple[int, int]] = []
    for a, b in diagonals:
        if a != b and (a, b) not in seen:
            seen.add((a, b))
            out.append((a, b))
    return out


def planar_faces(num_vertices: int, points: Sequence[Point], extra_edges: Sequence[Tuple[int, int]]) -> List[List[int]]:
    adj: List[Set[int]] = [set() for _ in range(num_vertices)]
    for i in range(num_vertices):
        j = (i + 1) % num_vertices
        adj[i].add(j)
        adj[j].add(i)
    for u, v in extra_edges:
        if u == v:
            continue
        adj[u].add(v)
        adj[v].add(u)

    ordered_neighbors: List[List[int]] = []
    neighbor_pos: List[Dict[int, int]] = []
    for u in range(num_vertices):
        nbrs = sorted(adj[u], key=lambda v: angle_of(points[u], points[v]))
        ordered_neighbors.append(nbrs)
        neighbor_pos.append({v: i for i, v in enumerate(nbrs)})

    visited: Set[Tuple[int, int]] = set()
    faces: List[List[int]] = []
    for u in range(num_vertices):
        for v in ordered_neighbors[u]:
            if (u, v) in visited:
                continue
            start = (u, v)
            cu, cv = u, v
            face: List[int] = []
            while True:
                visited.add((cu, cv))
                face.append(cu)
                lst = ordered_neighbors[cv]
                idx = neighbor_pos[cv][cu]
                nw = lst[(idx - 1) % len(lst)]
                cu, cv = cv, nw
                if (cu, cv) == start:
                    break
            if len(face) >= 3:
                faces.append(face)

    inner_faces = [face for face in faces if cycle_area(face, points) > EPS]
    return inner_faces


def triangles_from_faces(faces: Sequence[List[int]]) -> List[Tuple[int, int, int]]:
    tris: List[Tuple[int, int, int]] = []
    for face in faces:
        if len(face) == 3:
            tris.append((face[0], face[1], face[2]))
    return tris


def triangle_adjacency(triangles: Sequence[Tuple[int, int, int]]) -> List[List[int]]:
    edge_to_tris: Dict[Tuple[int, int], List[int]] = {}
    for idx, tri in enumerate(triangles):
        a, b, c = tri
        for e in [(a, b), (b, c), (a, c)]:
            edge_to_tris.setdefault(tuple(sorted(e)), []).append(idx)
    adj = [[] for _ in triangles]
    for tris in edge_to_tris.values():
        if len(tris) == 2:
            u, v = tris
            adj[u].append(v)
            adj[v].append(u)
    return adj


def color_triangulation(num_vertices: int, triangles: Sequence[Tuple[int, int, int]]) -> List[int]:
    colors = [-1] * num_vertices
    if not triangles:
        return colors
    adj = triangle_adjacency(triangles)
    stack = [0]
    visited = [False] * len(triangles)
    a, b, c = triangles[0]
    colors[a], colors[b], colors[c] = 0, 1, 2

    while stack:
        t = stack.pop()
        if visited[t]:
            continue
        visited[t] = True
        tri = triangles[t]
        tri_set = set(tri)
        for nb in adj[t]:
            if visited[nb]:
                continue
            other = triangles[nb]
            common = list(tri_set.intersection(other))
            if len(common) != 2:
                continue
            third = next(v for v in other if v not in common)
            used = {colors[common[0]], colors[common[1]]}
            for col in range(3):
                if col not in used:
                    colors[third] = col
                    break
            stack.append(nb)

    for tri in triangles:
        for v in tri:
            if colors[v] == -1:
                used = {colors[u] for u in tri if u != v and colors[u] != -1}
                for c in range(3):
                    if c not in used:
                        colors[v] = c
                        break

    for i in range(num_vertices):
        if colors[i] == -1:
            colors[i] = 0
    return colors

def strictly_inside_triangle_local(p: Point, a: Point, b: Point, c: Point) -> bool:
            s1 = orient(a, b, p)
            s2 = orient(b, c, p)
            s3 = orient(c, a, p)
            if abs(s1) <= EPS or abs(s2) <= EPS or abs(s3) <= EPS:
                return False
            pos = (s1 > 0 and s2 > 0 and s3 > 0)
            neg = (s1 < 0 and s2 < 0 and s3 < 0)
            return pos or neg

def diagonal_valid_local(simple_polygon: List[Point], a_idx: int, b_idx: int, ring: List[int]) -> bool:
            if a_idx == b_idx or same_point(simple_polygon[a_idx], simple_polygon[b_idx]):
                return False

            a = simple_polygon[a_idx]
            b = simple_polygon[b_idx]
            m = len(ring)

            for k in range(m):
                u = ring[k]
                v = ring[(k + 1) % m]

                if u in (a_idx, b_idx) or v in (a_idx, b_idx):
                    continue

                if strict_segment_intersection(a, b, simple_polygon[u], simple_polygon[v]):
                    return False

                if on_segment(a, b, simple_polygon[u]) and not same_point(simple_polygon[u], a) and not same_point(simple_polygon[u], b):
                    return False
                if on_segment(a, b, simple_polygon[v]) and not same_point(simple_polygon[v], a) and not same_point(simple_polygon[v], b):
                    return False

            mid = Point((a.x + b.x) / 2.0, (a.y + b.y) / 2.0)
            poly = [simple_polygon[i] for i in ring]
            return point_in_simple_polygon(mid, poly)

def triangulate_gallery(outer: List[Point], holes: List[List[Point]]):
    simple_polygon, display_polygon = bridge_holes_into_simple_polygon(outer, holes)
    num_vertices = len(simple_polygon)

    monotone_diagonals = make_monotone(simple_polygon)
    monotone_faces = planar_faces(num_vertices, simple_polygon, monotone_diagonals)

    triangulation_diagonals: Set[Tuple[int, int]] = set()
    for face in monotone_faces:
        for e in triangulate_monotone_polygon(face, simple_polygon):
            triangulation_diagonals.add(tuple(sorted(e)))

    all_diagonals = sorted(set(monotone_diagonals).union(triangulation_diagonals))
    final_faces = planar_faces(num_vertices, simple_polygon, all_diagonals)
    triangles = triangles_from_faces(final_faces)

    if len(triangles) != num_vertices - 2:
        verts = list(range(num_vertices))
        if polygon_area(simple_polygon) < 0:
            verts.reverse()

        ear_triangles: List[Tuple[int, int, int]] = []
        ear_diagonals: Set[Tuple[int, int]] = set()

        guard = 0
        max_guard = max(1000, num_vertices * num_vertices * 20)

        while len(verts) > 3 and guard < max_guard:
            guard += 1
            clipped = False

            for i in range(len(verts)):
                prev_idx = verts[(i - 1) % len(verts)]
                cur_idx = verts[i]
                next_idx = verts[(i + 1) % len(verts)]

                if (
                    same_point(simple_polygon[prev_idx], simple_polygon[cur_idx]) or
                    same_point(simple_polygon[cur_idx], simple_polygon[next_idx]) or
                    same_point(simple_polygon[prev_idx], simple_polygon[next_idx])
                ):
                    continue

                if orient(simple_polygon[prev_idx], simple_polygon[cur_idx], simple_polygon[next_idx]) <= EPS:
                    continue

                if not diagonal_valid_local(simple_polygon,prev_idx, next_idx, verts):
                    continue

                ok = True
                for other in verts:
                    if other in (prev_idx, cur_idx, next_idx):
                        continue

                    if (
                        same_point(simple_polygon[other], simple_polygon[prev_idx]) or
                        same_point(simple_polygon[other], simple_polygon[cur_idx]) or
                        same_point(simple_polygon[other], simple_polygon[next_idx])
                    ):
                        continue

                    if strictly_inside_triangle_local(
                        simple_polygon[other],
                        simple_polygon[prev_idx],
                        simple_polygon[cur_idx],
                        simple_polygon[next_idx],
                    ):
                        ok = False
                        break

                if not ok:
                    continue

                ear_triangles.append((prev_idx, cur_idx, next_idx))
                if (prev_idx + 1) % num_vertices != next_idx and (next_idx + 1) % num_vertices != prev_idx:
                    ear_diagonals.add(tuple(sorted((prev_idx, next_idx))))
                del verts[i]
                clipped = True
                break

            if clipped:
                continue

            removed = False
            for i in range(len(verts)):
                prev_idx = verts[(i - 1) % len(verts)]
                cur_idx = verts[i]
                next_idx = verts[(i + 1) % len(verts)]

                if (
                    same_point(simple_polygon[prev_idx], simple_polygon[cur_idx]) or
                    same_point(simple_polygon[cur_idx], simple_polygon[next_idx]) or
                    abs(orient(simple_polygon[prev_idx], simple_polygon[cur_idx], simple_polygon[next_idx])) <= EPS
                ):
                    del verts[i]
                    removed = True
                    break

            if removed:
                continue

            for i in range(len(verts)):
                prev_idx = verts[(i - 1) % len(verts)]
                cur_idx = verts[i]
                next_idx = verts[(i + 1) % len(verts)]

                if orient(simple_polygon[prev_idx], simple_polygon[cur_idx], simple_polygon[next_idx]) <= EPS:
                    continue
                if not diagonal_valid_local(simple_polygon,prev_idx, next_idx, verts):
                    continue

                ear_triangles.append((prev_idx, cur_idx, next_idx))
                if (prev_idx + 1) % num_vertices != next_idx and (next_idx + 1) % num_vertices != prev_idx:
                    ear_diagonals.add(tuple(sorted((prev_idx, next_idx))))
                del verts[i]
                clipped = True
                break

            if not clipped:
                break

        if len(verts) == 3 and abs(orient(simple_polygon[verts[0]], simple_polygon[verts[1]], simple_polygon[verts[2]])) > EPS:
            ear_triangles.append((verts[0], verts[1], verts[2]))

        triangles = ear_triangles
        monotone_diagonals = []
        triangulation_diagonals = set(ear_diagonals)
        all_diagonals = sorted(triangulation_diagonals)
        final_faces = []

    colors = color_triangulation(num_vertices, triangles)

    color_classes = {0: [], 1: [], 2: []}
    for idx, col in enumerate(colors):
        color_classes[col].append(idx)
    best_class = min(color_classes.values(), key=len)

    guard_points: List[Point] = []
    seen_coords: Set[Tuple[float, float]] = set()
    for idx in best_class:
        pt = display_polygon[idx]
        key = (round(pt.x, 10), round(pt.y, 10))
        if key not in seen_coords:
            seen_coords.add(key)
            guard_points.append(pt)

    theoretical_bound = (len(outer) + sum(len(h) for h in holes) + 2 * len(holes)) // 3

    final_edges: Set[Tuple[int, int]] = set()
    for i in range(num_vertices):
        final_edges.add(tuple(sorted((i, (i + 1) % num_vertices))))
    for e in all_diagonals:
        final_edges.add(tuple(sorted(e)))

    return {
        'simple_polygon': simple_polygon,
        'display_polygon': display_polygon,
        'monotone_diagonals': monotone_diagonals,
        'triangulation_diagonals': sorted(triangulation_diagonals),
        'triangles': triangles,
        'colors': colors,
        'guard_points': guard_points,
        'theoretical_bound': theoretical_bound,
        'final_edges': final_edges,
    }


def MakeMonotone(P: Sequence[Point]) -> List[Tuple[int, int]]:
    return make_monotone(P)


def TriangulateMonotonePolygon(poly_indices: List[int], points: Sequence[Point]) -> List[Tuple[int, int]]:
    return triangulate_monotone_polygon(poly_indices, points)
