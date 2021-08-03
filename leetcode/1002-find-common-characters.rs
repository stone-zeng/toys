// 1002. Find Common Characters
// https://leetcode.com/problems/find-common-characters/

use std::collections::HashMap;

struct Solution {}

type CharMap = HashMap<char, usize>;

impl Solution {
    pub fn common_chars(words: Vec<String>) -> Vec<String> {
        let mut temp = words.iter().map(|word| {
            let mut chars = CharMap::new();
            word.chars().for_each(|c| {
                let counter = chars.entry(c).or_insert(0);
                *counter += 1;
            });
            chars
        });
        // This can be simplified by using `.reduce(...).unwrap()` (requires Rust 1.51).
        let init = temp.next().unwrap();
        temp.fold(init, |a, b| {
            a.into_iter()
                .filter(|(c, _)| b.contains_key(c))
                .map(|(c, n)| (c, n.min(b[&c])))
                .collect()
        })
        .into_iter()
        .map(|(c, n)| vec![c].repeat(n))
        .flatten()
        .map(|c| c.to_string())
        .collect()
    }
}

fn main() {
    for words in [
        vec!["bella", "label", "roller"],
        vec!["cool", "lock", "cook"],
        vec![
            "acabcddd", "bcbdbcbd", "baddbadb", "cbdddcac", "aacbcccd", "ccccddda", "cababaab",
            "addcaccd",
        ],
    ] {
        let words = words.iter().map(|w| w.to_string()).collect();
        println!("{:?}", Solution::common_chars(words));
    }
}
