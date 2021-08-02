'''13. Roman to Integer
https://leetcode.com/problems/roman-to-integer/
'''

class Solution:
    ROMAN_PAIR = [
        'II', 'IV', 'IX',
        'XX', 'XL', 'XC',
        'CC', 'CD', 'CM'
    ]
    ROMAN_INT_MAP = {
        'I': 1, 'II': 2, 'III': 3, 'IV': 4, 'V': 5, 'IX': 9,
        'X': 10, 'XX': 20, 'XXX': 30, 'XL': 40, 'L': 50, 'XC': 90,
        'C': 100, 'CC': 200, 'CCC': 300, 'CD': 400, 'D': 500, 'CM': 900,
        'M': 1000, 'MM': 2000, 'MMM': 3000
    }

    def romanToInt(self, s):
        '''
        :type s: str
        :rtype: int
        '''
        if len(s) == 1:
            _s = s
        else:
            _s = ''
            for i in range(len(s) - 1):
                if s[i:i + 2] in self.ROMAN_PAIR:
                    _s += s[i]
                else:
                    _s += s[i] + ' '
            _s += s[-1]

        result = 0
        for i in _s.split(' '):
            result += self.ROMAN_INT_MAP[i]

        return result

def _test():
    sol = Solution()
    for i in ['III', 'IV', 'IX', 'XXVII', 'LVIII', 'MCMXCIV', 'MDCCLXXVI',
              'MCMLIV', 'MCMXC', 'MMXIV', 'MMXVIII']:
        print([i, sol.romanToInt(i)])

if __name__ == '__main__':
    _test()
