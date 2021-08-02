'''38. Count and Say
https://leetcode.com/problems/count-and-say/
'''

class Solution:
    def countAndSay(self, n: int) -> str:
        if n == 1:
            return '1'

        last_str = self.countAndSay(n - 1)
        last_str_len = len(last_str)
        result = ''
        i = 0
        while i < last_str_len:
            j = i + 1
            while j < last_str_len and last_str[i] == last_str[j]:
                j = j + 1
            result += str(j - i) + last_str[i]
            i = j
        return result
