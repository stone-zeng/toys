'''812. Largest Triangle Area
https://leetcode.com/problems/largest-triangle-area/
'''

import itertools
from typing import List

class Solution:
    def largestTriangleArea(self, points: List[List[int]]) -> float:
        area = 0.0
        for p in itertools.combinations(points, 3):
            area = max(area, self.triangleArea(*p))
        return area

    def triangleArea(self, p0, p1, p2) -> float:
        y0, y1, y2 = p0[1], p1[1], p2[1]
        return 0.5 * abs(p0[0] * (y2 - y1) + p1[0] * (y0 - y2) + p2[0] * (y1 - y0))

if __name__ == '__main__':
    print(Solution().largestTriangleArea([[0,0],[0,1],[1,0],[0,2],[2,0]]))
