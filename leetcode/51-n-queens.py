"""51. N-Queens
https://leetcode.com/problems/n-queens/
"""

from itertools import permutations
from typing import Dict, List

class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        d = {}
        res = []
        for sol in filter(lambda row: self.isSafe(row, d), permutations(range(n))):
            r = [['.' for _ in range(n)] for _ in range(n)]
            for i, j in zip(range(n), sol):
                r[i][j] = 'Q'
            res.append([''.join(row) for row in r])
        return res

    def isSafe(self, row: List[int], d: Dict[List[int], bool]) -> bool:
        if len(row) <= 1:
            return True
        x, xs = row[0], row[1:]
        if xs in d:
            recur = d[xs]
        else:
            recur = self.isSafe(xs, d)
            d[xs] = recur
        return recur and all(abs(x - y) != yi + 1 for yi, y in enumerate(xs))

if __name__ == '__main__':
    for n in range(1, 5):
        print(n, Solution().solveNQueens(n))
