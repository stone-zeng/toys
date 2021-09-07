// 459. Repeated Substring Pattern
// https://leetcode.com/problems/repeated-substring-pattern/

struct Solution {}

impl Solution {
    pub fn repeated_substring_pattern(s: String) -> bool {
        let n = s.len();
        (1..n)
            .into_iter()
            .filter(|&x| n % x == 0)
            .any(|i| s[..i].repeat(n / i) == s)
    }
}

fn main() {
    for (s, res) in [
        ("abab", true),
        ("aba", false),
        ("abcabcabcabc", true),
        ("bb", true),
    ] {
        assert_eq!(Solution::repeated_substring_pattern(s.to_string()), res);
    }
}
