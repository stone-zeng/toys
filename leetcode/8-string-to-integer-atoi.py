'''8. String to Integer (atoi)
https://leetcode.com/problems/string-to-integer-atoi/
'''

import re

PATTERN = re.compile(r'^\s*([\+\-]?)0*(\d+)')
INT_MAX = pow(2, 31) - 1
INT_MIN = -pow(2, 31)
INT_MAX_LEN = 10

class Solution:
    def myAtoi(self, str: str) -> int:
        search = re.search(PATTERN, str)
        if search is None:
            return 0
        sign    = search.group(1)
        num_str = search.group(2)
        if search.group(2) == '' or search.group(2) == '0':
            return 0
        if sign == '-':
            if len(num_str) > INT_MAX_LEN:
                return INT_MIN
            num = self._atoi(num_str)  # num >= 0
            return -num if num < -INT_MIN else INT_MIN
        else:
            if len(num_str) > INT_MAX_LEN:
                return INT_MAX
            num = self._atoi(num_str)
            return num if num < INT_MAX else INT_MAX

    def _atoi(self, num_str: str) -> int:
        return sum(int(i) * pow(10, j)
                   for i, j in zip(num_str, range(len(num_str) - 1, -1, -1)))
