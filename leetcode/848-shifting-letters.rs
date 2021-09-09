// 848. Shifting Letters
// https://leetcode.com/problems/shifting-letters/

struct Solution {}

impl Solution {
    pub fn shifting_letters(s: String, shifts: Vec<i32>) -> String {
        let mut x = shifts.iter().rev().fold(vec![], |mut v, i| {
            v.push(v.last().unwrap_or(&0) + *i as u64);
            v
        });
        x.reverse();
        s.chars()
            .zip(x.iter())
            .map(|(c, i)| ((c as u64 - 97 + i) % 26 + 97) as u8 as char)
            .collect()
    }
}

fn main() {
    [
        ("abc", vec![3, 5, 9], "rpl"),
        ("aaa", vec![1, 2, 3], "gfd"),
        (
            "gjjdvpmsxjpisaakrjyz",
            vec![
                80531, 53, 671884, 2, 12851195, 6637, 120, 397670, 3193617, 468, 273955, 2998,
                19267, 46876999, 861417, 3646, 3298, 597, 20, 2,
            ],
            "icbdtukafgmmovihieub",
        ),
        (
            "mkgfzkkuxownxvfvxasy",
            vec![
                505870226, 437526072, 266740649, 224336793, 532917782, 311122363, 567754492,
                595798950, 81520022, 684110326, 137742843, 275267355, 856903962, 148291585,
                919054234, 467541837, 622939912, 116899933, 983296461, 536563513,
            ],
            "wqqwlcjnkphhsyvrkdod",
        ),
    ]
    .iter()
    .for_each(|(s, shifts, res)| {
        assert_eq!(
            Solution::shifting_letters(s.to_string(), shifts.clone()),
            *res
        )
    })
}
