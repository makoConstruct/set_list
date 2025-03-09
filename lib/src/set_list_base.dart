// little library for representing sets with sorted lists. Probably useless. You should prefer BTreeSets. But we don't have that yet https://github.com/dart-lang/core/issues/657

int compareInt(int a, int b) {
  if (a < b) return -1;
  if (a > b) return 1;
  return 0;
}

/// A set represented as a sorted list.
class SetList<T> {
  final List<T> v;
  final bool infinity;
  late final int Function(T a, T b) compare;
  SetList.assumeSorted(this.v,
      {this.infinity = false, int Function(T a, T b)? compare}) {
    compare ??= (a, b) => (a as Comparable<T>).compareTo(b);
    this.compare = compare;
  }
  SetList.infinity()
      : v = [],
        infinity = true;
  SetList(this.v, {int Function(T a, T b)? compare, this.infinity = false}) {
    compare ??= (a, b) => (a as Comparable<T>).compareTo(b);
    this.compare = compare;
    v.sort(compare);
  }

  SetList<T> clone() {
    return SetList.assumeSorted(v.toList(),
        infinity: infinity, compare: compare);
  }

  /// finds either the index where item is in the set or the index where it would be inserted.
  int findIndex(T item) {
    if (infinity) {
      throw StateError("attempt to find index in an infinity setlist");
    }
    // tentative optimization todo: consider positioning mid in proportion to how high item is relative to the max T?..
    int base = 0;
    int range = v.length;
    while (range > 0) {
      int mid = base + range ~/ 2;
      int cmp = compare(item, v[mid]);
      if (cmp < 0) {
        range = mid - base;
      } else if (cmp > 0) {
        int nbase = mid + 1;
        range = range - (nbase - base);
        base = nbase;
      } else {
        return mid;
      }
    }
    return base;
  }

  bool contains(T item) {
    if (infinity) {
      throw StateError("attempt to check containment in an infinity setlist");
    }
    int index = findIndex(item);
    return v.isNotEmpty && v[index] == item;
  }

  SetList<T> union(SetList<T> other) {
    if (infinity) {
      return other.clone();
    }
    if (other.infinity) {
      return this.clone();
    }
    List<T> result = [];
    int i = 0;
    int j = 0;
    while (i < v.length && j < other.v.length) {
      int comp = compare(v[i], other.v[j]);
      if (comp < 0) {
        result.add(v[i]);
        i++;
      } else if (comp > 0) {
        result.add(other.v[j]);
        j++;
      } else {
        result.add(v[i]);
        i++;
        j++;
      }
    }
    while (i < v.length) {
      result.add(v[i]);
      i++;
    }
    while (j < other.v.length) {
      result.add(other.v[j]);
      j++;
    }
    return SetList.assumeSorted(result, compare: compare);
  }

  SetList<T> intersection(SetList<T> other) {
    if (infinity) {
      return other.clone();
    }
    if (other.infinity) {
      return this.clone();
    }
    // optimization TODO: if either list is large while the other is very small, use some kind of binary search.
    List<T> result = [];
    int i = 0;
    int j = 0;
    while (i < v.length && j < other.v.length) {
      int comp = compare(v[i], other.v[j]);
      if (comp < 0) {
        i++;
      } else if (comp > 0) {
        j++;
      } else {
        result.add(v[i]);
        i++;
        j++;
      }
    }
    return SetList.assumeSorted(result, compare: compare);
  }

  SetList<T> difference(SetList<T> other) {
    if (infinity) {
      // this isn't actually correct, but it's the best we can do
      return this.clone();
    }
    if (other.infinity) {
      return SetList([]);
    }
    List<T> result = [];
    int i = 0;
    int j = 0;
    while (i < v.length && j < other.v.length) {
      int comp = compare(v[i], other.v[j]);
      if (comp < 0) {
        result.add(v[i]);
        i++;
      } else if (comp > 0) {
        j++;
      } else {
        i++;
        j++;
      }
    }
    while (i < v.length) {
      result.add(v[i]);
      i++;
    }
    return SetList.assumeSorted(result, compare: compare);
  }

  /// Adds an item to the setlist if it's not already present.
  /// Returns the index of the item in the setlist.
  int add(T item) {
    if (infinity) {
      throw StateError("attempt to add to an infinity setlist");
    }
    int index = findIndex(item);
    if (v.isEmpty || v[index] != item) {
      v.insert(index, item);
    }
    return index;
  }

  void remove(T item) {
    if (infinity) {
      throw StateError("attempt to remove from an infinity setlist");
    }
    int index = findIndex(item);
    if (v.isNotEmpty && v[index] == item) {
      v.removeAt(index);
    }
  }

  void comparisonScan(SetList<T> other,
      {void Function(T a)? onlyInThis,
      void Function(T b)? onlyInOther,
      void Function(T a)? inBoth}) {
    if (infinity) {
      if (other.infinity) {
        throw StateError(
            "attempt to scan an infinity setlist against an infinity setlist");
      } else {
        for (var item in other.v) {
          inBoth?.call(item);
        }
      }
    } else {
      if (other.infinity) {
        for (var item in v) {
          inBoth?.call(item);
        }
      } else {
        int i = 0;
        int j = 0;
        while (i < v.length && j < other.v.length) {
          int comp = compare(v[i], other.v[j]);
          if (comp < 0) {
            onlyInThis?.call(v[i]);
            i++;
          } else if (comp > 0) {
            onlyInOther?.call(other.v[j]);
            j++;
          } else {
            inBoth?.call(v[i]);
            i++;
            j++;
          }
        }
        while (i < v.length) {
          onlyInThis?.call(v[i]);
          i++;
        }
        while (j < other.v.length) {
          onlyInOther?.call(other.v[j]);
          j++;
        }
      }
    }
  }
}
