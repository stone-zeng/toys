// 916. Word Subsets
// https://leetcode.com/problems/word-subsets/

use std::collections::HashMap;
// use std::{
//     fs::File,
//     io::{BufRead, BufReader, Result},
// };

struct Solution {}

type WordMap = HashMap<char, usize>;

impl Solution {
    pub fn word_subsets(words1: Vec<String>, words2: Vec<String>) -> Vec<String> {
        let mut words1 = words1;
        let words2_map = Self::words2_to_maps(words2);
        for b in words2_map {
            words1 = words1
                .iter()
                .filter(|&a| Self::is_subset(&Self::str_to_map(a), &b))
                .cloned()
                .collect();
        }
        words1
    }

    fn words2_to_maps(words2: Vec<String>) -> Vec<WordMap> {
        let mut words: Vec<String> = words2.iter().map(Self::string_sort).collect();
        words.sort_unstable();
        words.dedup();
        let mut maps: Vec<WordMap> = words.iter().map(|w| Self::str_to_map(w)).collect();
        let mut i = 0;
        while i < maps.len() {
            let map_i = maps[i].clone();
            maps.retain(|map| !Self::is_subset(&map_i, map));
            maps.push(map_i);
            i += 1;
        }
        dbg!(maps)
    }

    fn is_subset(a: &WordMap, b: &WordMap) -> bool {
        for (c, n_b) in b {
            match a.get(c) {
                Some(n_a) => {
                    if n_a < n_b {
                        return false;
                    }
                }
                None => return false,
            }
        }
        true
    }

    fn str_to_map(s: &str) -> WordMap {
        let mut map = HashMap::new();
        s.chars().for_each(|c| *map.entry(c).or_insert(0) += 1);
        map
    }

    fn string_sort(s: &String) -> String {
        let mut chars: Vec<char> = s.chars().collect();
        chars.sort_unstable();
        chars.iter().collect()
    }
}

// fn read_lines(path: &str) -> Result<Vec<String>> {
//     let f = File::open(path)?;
//     BufReader::new(f).lines().collect()
// }

fn main() {
    let words1: Vec<String> = vec!["amazon", "apple", "facebook", "google", "leetcode"]
        .iter()
        .map(|s| s.to_string())
        .collect();
    for words2 in &[
        vec!["e", "o"],
        vec!["l", "e"],
        vec!["e", "oo"],
        vec!["lo", "eo"],
        vec!["ec", "oc", "ceo"],
    ] {
        let result = Solution::word_subsets(
            words1.clone(),
            words2.iter().map(|s| s.to_string()).collect(),
        );
        println!("{:?}", result);
    }

    // let words1 = read_lines("./words1-1.txt").unwrap();
    // let words2 = read_lines("./words2-1.txt").unwrap();
    // println!("{:?}", Solution::word_subsets(words1, words2));
}
