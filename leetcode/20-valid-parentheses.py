'''20. Valid Parentheses
https://leetcode.com/problems/valid-parentheses/
'''

class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        for i in s:
            if stack == []:
                stack.append(i)
            else:
                if self.isMatch(stack[-1], i):
                    stack.pop(-1)
                else:
                    stack.append(i)
        if stack == []:
            return True
        else:
            return False

    def isMatch(self, c1: str, c2: str) -> bool:
        if (c1, c2) == ('(', ')') or (c1, c2) == ('[', ']') or (c1, c2) == ('{', '}'):
            return True
        else:
            return False
