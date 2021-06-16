#ifndef LEETCODE_UTIL_H
#define LEETCODE_UTIL_H

#include <string>
#include <vector>
#include <map>

namespace leetcode {

// Definition for singly-linked list.
template <class T>
struct _ListNode {
    T val;
    _ListNode * next;
    _ListNode(int x) : val(x), next(nullptr) {}
    _ListNode(const std::initializer_list<T> & list) {
        if (list.size() != 0) {
            auto p = this;
            p->val = *list.begin();
            for (auto i = list.begin() + 1; i != list.end(); ++i) {
                p->next = new _ListNode<T>(*i);
                p = p->next;
            }
        }
    }
};

typedef _ListNode<int> ListNode;

template <class T>
inline std::string to_string(const T & val) {
    return std::to_string(val);
}

inline std::string to_string(const char * val) {
    std::string s = val;
    return s;
}

inline std::string to_string(const std::string & val) {
    return val;
}

inline std::string to_string(char c) {
    std::string s(1, c);
    return s;
}

inline std::string to_string(bool b) {
    return b ? "True" : "False";
}

// std::vector
template <class T>
inline std::string to_string(
        const std::vector<T> & v,
        const std::string & joiner=",",
        const std::pair<std::string, std::string> & braces={"[", "]"}) {
    if (v.empty()) return braces.first + braces.second;
    std::string s;
    for (auto iter = v.cbegin(); iter < v.cend() - 1; ++iter)
        s += to_string(*iter) + joiner;
    return braces.first + s + to_string(v.back()) + braces.second;
}

// std::map
template <class K, class V>
inline std::string to_string(
        std::map<K, V> m,
        std::string joiner=",",
        std::string separator=":",
        std::pair<std::string, std::string> braces={"{", "}"}) {
    if (m.empty()) return braces.first + braces.second;
    std::string s;
    for (const auto & i : m)
        s += to_string(i.first) + separator + to_string(i.second) + joiner;
    return braces.first + s + braces.second;
}

// std::pair
template <class T1, class T2>
inline std::string to_string(
        const std::pair<T1, T2> & p,
        const std::string & joiner=",",
        const std::pair<std::string, std::string> & braces={"(", ")"}) {
    return braces.first + to_string(p.first) + joiner + to_string(p.second) + braces.second;
}

// TODO: std::vector<std::pair>>
template <class T1, class T2>
inline std::string to_string(
        const std::vector<std::pair<T1, T2>> & v,
        const std::string & joiner=",",
        const std::pair<std::string, std::string> & braces={"[", "]"}) {
    if (v.empty()) return braces.first + braces.second;
    std::string s;
    for (auto iter = v.cbegin(); iter < v.cend() - 1; ++iter)
        s += to_string<T1, T2>(*iter) + joiner;
    return braces.first + s + to_string(v.back()) + braces.second;
}

// leetcode::_ListNode
template <class T>
inline std::string to_string(
        _ListNode<T> * head,
        std::string joiner="->",
        std::pair<std::string, std::string> braces={"(", ")"}) {
    std::vector<T> v;
    while (head) {
        v.push_back(head->val);
        head = head->next;
    }
    return to_string(v, joiner, braces);
}

}

#endif
