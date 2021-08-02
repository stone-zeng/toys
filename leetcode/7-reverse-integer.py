'''7. Reverse Integer
https://leetcode.com/problems/reverse-integer/
'''

import re

class Solution:
    MAX_INT = 2147483648

    def reverse(self, x):
        '''
        :type x: int
        :rtype: int
        '''
        if 0 < x <= self.MAX_INT - 1:
            result = self.reversePos(x)
        elif -self.MAX_INT <= x < 0:
            result = -self.reversePos(-x)
        else:
            result = 0

        if -self.MAX_INT <= result <= self.MAX_INT - 1:
            return result
        return 0

    def reversePos(self, x):
        x_str = re.sub(r'0*\$', '', str(x) + '$')
        result = ''
        for i in range(len(x_str), 0, -1):
            result += x_str[i - 1]
        return int(result)
