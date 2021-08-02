'''9. Palindrome Number
https://leetcode.com/problems/palindrome-number/
'''

import math

class Solution:
    def isPalindrome(self, x):
        '''
        :type x: int
        :rtype: bool
        '''
        if x >= 10:
            x_len = math.floor(math.log10(x)) + 1
            digit_list = []
            for i in reversed(range(x_len)):
                base = 10 ** i
                quotient = x // base
                x -= quotient * base
                digit_list.append(quotient)
            for i in range(x_len // 2):
                if digit_list[i] != digit_list[-i - 1]:
                    return False
            return True
        elif x >= 0:
            return True
        return False
