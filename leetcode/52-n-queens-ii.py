'''52. N-Queens II
https://leetcode.com/problems/n-queens-ii/
'''

from itertools import permutations

class Solution:
    def totalNQueens(self, n: int) -> int:
        d = {}
        return len(list(filter(lambda row: self.isSafe(row, d), permutations(range(n)))))

    def isSafe(self, row: list[int], d: dict[list[int], bool]) -> bool:
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
    for n in range(1, 10):
        print(n, Solution().totalNQueens(n))
