'''65. Valid Number
https://leetcode.com/problems/valid-number/
'''

import re

NUMBER_PATTERN = re.compile(r'''
    [\+\-]?
    (:?\d+\.?\d*|\.\d+)
    ([eE][\+\-]?\d+)?
''', re.VERBOSE)

class Solution:
    def isNumber(self, s: str) -> bool:
        return re.fullmatch(NUMBER_PATTERN, s) is not None

if __name__ == '__main__':
    sol = Solution()
    for i in ['2', '0089', '-0.1', '+3.14', '4.', '-.9', '2e10', '-90E3', '3e+7', '+6e-1', '53.5e93', '-123.456e789']:
        assert sol.isNumber(i) == True
    for i in ['abc', '1a', '1e', 'e3', '99e2.5', '--6', '-+3', '95a54e53']:
        assert sol.isNumber(i) == False
