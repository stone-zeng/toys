# -*- coding: UTF-8 -*-
"""Benchmark for my sorting library.
"""

import random
import time
import matplotlib
import matplotlib.pyplot as plt

import sort

TEST_DATA_LEN = range(100, 4000, 100)

def generate_data():
    result = []
    for i in TEST_DATA_LEN:
        data = []
        for _ in range(i + 1):
            data.append(random.randint(0, 1000))
        result.append(data)
    return result

def timing_sort(method, data_list):
    timing_result = []
    for data in data_list:
        if method != "build-in":
            sort_func = getattr(sort, "sort_" + method)
            timing_start = time.clock()
            sorted_data = sort_func(data[:])
            timing_elapsed = time.clock() - timing_start
        else:
            sorted_data = data[:]
            timing_start = time.clock()
            sorted_data.sort()
            timing_elapsed = time.clock() - timing_start
        timing_result.append(timing_elapsed)
    return timing_result

def show_result(result):
    matplotlib.style.use("seaborn")
    plt.rcParams["font.family"] = "FiraGO"
    for i in result.keys():
        plt.plot(TEST_DATA_LEN, result[i],
                 marker="o",
                 label=i.capitalize())
    plt.yscale("log")
    plt.xlabel("Data size")
    plt.ylabel("Time / s")
    plt.legend()
    plt.show()

def benchmark():
    data_list = generate_data()
    result = {}
    for method in sort.SORT_METHODS:
        result[method] = timing_sort(method, data_list)
    show_result(result)

benchmark()
