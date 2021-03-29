import numpy as np

def groupby_np(arr, both=True):
    n = len(arr)
    extrema = np.nonzero(arr[:-1] != arr[1:])[0] + 1
    if both:
        last_i = 0
        for i in extrema:
            yield last_i, i
            last_i = i
        yield last_i, n
    else:
        yield 0
        yield from extrema
        yield n


def labeling_groupby_np(values, labels):
    slicing = labels.argsort()
    sorted_labels = labels[slicing]
    sorted_values = values[slicing]
    del slicing
    result = []
    for i, j in groupby_np(sorted_labels, True):
        result.append(sorted_values[i:j])
    return result