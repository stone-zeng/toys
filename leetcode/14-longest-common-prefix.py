'''14. Longest Common Prefix
https://leetcode.com/problems/longest-common-prefix/
'''

class Solution:
    def longestCommonPrefix(self, strs) -> str:
        if len(strs) == 0:
            return ''
        min_len = min(len(i) for i in strs)
        for i in range(min_len):
            prefix = strs[0][:i+1]
            if any(s[:i+1] != prefix for s in strs):
                return prefix[:-1]
            if i == min_len - 1:
                return prefix
        return ''
