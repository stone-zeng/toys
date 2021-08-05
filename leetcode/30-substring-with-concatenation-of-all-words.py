'''30. Substring with Concatenation of All Words
https://leetcode.com/problems/substring-with-concatenation-of-all-words/
'''

class Solution:
    def findSubstring(self, s: str, words: list[str]) -> list[int]:
        substring_len = len(words[0])
        substring_total_len = len(words) * substring_len
        words_dict = self.wordsDict(words)
        res = []
        for i in range(len(s) - substring_total_len + 1):
            d = {}
            for j in range(0, substring_total_len, substring_len):
                w = s[i+j:][:substring_len]
                if w not in words_dict:
                    break
                if w in d:
                    if d[w] > words_dict[w]:
                        break
                    else:
                        d[w] += 1
                else:
                    d[w] = 1
            if d == words_dict:
                res.append(i)
        return res

    def wordsDict(self, words: list[str]) -> dict[str, int]:
        return {w: words.count(w) for w in words}

if __name__ == '__main__':
    for s, words in [
        ('barfoothefoobarman', ['foo','bar']),
        ('wordgoodgoodgoodbestword', ['word','good','best','word']),
        ('barfoofoobarthefoobarman', ['bar','foo','the']),
    ]:
        print(Solution().findSubstring(s, words))
