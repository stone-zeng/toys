"""1239. Maximum Length of a Concatenated s with Unique Characters
https://leetcode.com/problems/maximum-length-of-a-concatenated-s-with-unique-characters/
"""

from typing import List
import itertools


class Solution:
    def maxLength(self, arr: List[str]) -> int:
        arr = list(filter(self.isUniqueChars, arr))
        res = 0
        for l in range(len(arr) + 1):
            for c in itertools.combinations(arr, l):
                s = ''.join(c)
                if self.isUniqueChars(s):
                    res = max(res, len(s))
        return res

    def isUniqueChars(self, s: str) -> bool:
        return len(s) == len(set(s))


if __name__ == '__main__':
    for arr, res in [
        (["un","iq","ue"], 4),
        (["cha","r","act","ers"], 6),
        (["abcdefghijklmnopqrstuvwxyz"], 26),
        (["iknvfgbaewdzyy","pd","aadijk","gfvcwcfgvipsnsx","mhyzmifbl","ljugu","tvrsgblc","ptzdqgsns","odtw","goieqadxgltxmvo","oki","sxhb","sdetrhmukwkfjh","bcmptmhypdbbiv","gmwzizg","iazlx"], 13),
        (["asruk","yedpibnmtrlkhczs","sltnvagobihm","bexnozjlpvdtic","hdfeiptnbuzmgsl","rfjvstpyicgeo","vhqljfspgrutai","yuizqrkv","njpmw","tcexwy","qi","zhjcpoxeksayd","hykxrcftoljuwpg","ngcjrmzowbyi","odnlpxtvzbfiyrje","zwidqlk"], 19),
    ]:
        assert Solution().maxLength(arr) == res
