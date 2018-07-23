# -*- coding: UTF-8 -*-
"""My sorting library.
    For exercise only.
"""

SORT_METHODS = [
    "bubble",
    "selection",
    "insertion",
    "merge",
    "quick",
    "build-in"    # 内置函数
]

def sort_bubble(data):
    """冒泡排序。

    两两元素互相比较，若 `left_elem` > `right_elem`，则交换两元素。遍历一次之后，最大的元素便被移动
    到列表右侧。依次处理子列表，即可完成排序。
    """
    last_unsorted_index = len(data)
    while last_unsorted_index != 1:
        for i in range(last_unsorted_index - 1):
            if data[i] > data[i + 1]:
                data[i], data[i + 1] = data[i + 1], data[i]
        last_unsorted_index -= 1
    return data

def sort_selection(data):
    """选择排序。

    先固定第一个元素，找出其右侧最小的元素后，与之交换；依次更新第二个、第三个元素，直至完成排序。
    """
    data_len = len(data)
    first_unsorted_index = 0
    while first_unsorted_index != data_len:
        current_min = data[first_unsorted_index]
        current_min_index = first_unsorted_index
        for i in range(first_unsorted_index + 1, data_len):
            if data[i] < current_min:
                current_min = data[i]
                current_min_index = i
        data[first_unsorted_index], data[current_min_index] \
            = data[current_min_index], data[first_unsorted_index]
        first_unsorted_index += 1
    return data

def sort_insertion(data):
    """插入排序。

    将未排序好的元素与排序好的元素依次比较，并插入到合适的位置上，直至将所有元素全部插入到排好的
    序列中。
    """
    first_unsorted_index = 1    # 第二个元素
    while first_unsorted_index != len(data):
        for i in range(first_unsorted_index):    # `i` 是已排序好的序列的指标
            if data[first_unsorted_index] < data[i]:
                temp = data[first_unsorted_index]
                for j in range(first_unsorted_index, i, -1):
                    data[j] = data[j - 1]
                data[i] = temp
                break
        first_unsorted_index += 1
    return data

def sort_merge(data):
    """归并排序。

    递归地对已排序好的子列表调用 `_merge_sorted_list` 进行合并操作，最终使得整个列表变为有序。
    """
    data_len = len(data)
    # 基本情形
    if data_len <= 1:
        return data
    # 分解为左、右两个列表，递归调用 `sort_merge` 进行排序
    left_list, right_list = data[:data_len // 2], data[data_len // 2:]
    return _merge_sorted_list(sort_merge(left_list), sort_merge(right_list))

def _merge_sorted_list(left_list, right_list):
    """合并两个已排序好的子列表。
    """
    result = []
    i = j = 0
    left_list_len = len(left_list)
    right_list_len = len(right_list)
    # 逐项比较左右两个列表，将较小的元素添加到 `result`
    while i < left_list_len and j < right_list_len:
        if left_list[i] < right_list[j]:
            result.append(left_list[i])
            i += 1
        else:
            result.append(right_list[j])
            j += 1
    # 剩余元素直接附加到 `result` 之后
    if i < left_list_len:
        result += left_list[i:]
    if j < right_list_len:
        result += right_list[j:]
    return result

def sort_quick(data):
    """快速排序。

    选择第一个元素为主元 `pivot`，其余元素若小于 `pivot`，则放入 `left_list`，否则放入
    `right_list`。递归地对子列表调用 `sort_quick`，直至排序完成。
    """
    if len(data) <= 1:
        return data
    pivot = data[0]
    left_list = []
    right_list = []
    for i in data[1:]:    # `data` 中至少有 2 个元素
        if i < pivot:
            left_list.append(i)
        else:
            right_list.append(i)
    return sort_quick(left_list) + [pivot] + sort_quick(right_list)

################
#     TEST     #
################

_MESSAGE_PREFFIX_LEN = 18

def _random_int(num, min_val=0, max_val=1000):
    """生成 [`min_val`, `max_val`] 间的 `num` 个随机整数。
    """
    result = []
    for _ in range(num):
        result.append(random.randint(min_val, max_val))
    return result

def _generate_data(use_random_data=False, data_num=1000):
    """生成测试数据。
    """
    if use_random_data:
        timing_start = time.clock()
        data = _random_int(data_num)
        timing_elapsed = time.clock() - timing_start
        print("Generate sample:".ljust(_MESSAGE_PREFFIX_LEN),
              "{0:.6f}".format(timing_elapsed), "s\n")
        return data
    return [8, 1, 5, 11, 46, 46, 17, 41, 50, 3, 7, 46, 16]    # 预定义序列

def _test_sort(data, method="build-in", print_data=True):
    """单元测试。
    """
    if method != "build-in":
        if "sort_" + method in globals():
            sort_func = globals()["sort_" + method]    # 从字符串生成函数名
            timing_start = time.clock()
            sorted_data = sort_func(data[:])
            timing_elapsed = time.clock() - timing_start
        else:
            print("Function `sort_" + method + "` not found!")
            return
    else:
        sorted_data = data[:]
        timing_start = time.clock()
        sorted_data.sort()
        timing_elapsed = time.clock() - timing_start
    print((method.capitalize() + " sort:").ljust(_MESSAGE_PREFFIX_LEN),
          "{0:.6f}".format(timing_elapsed), "s")
    if print_data:
        print(data)
        print(sorted_data)

def main():
    """程序入口。
    """
    data = _generate_data(use_random_data=True, data_num=1000)
    for sort_method in SORT_METHODS:
        _test_sort(data, method=sort_method, print_data=False)

if __name__ == '__main__':
    import random
    import time
    main()
