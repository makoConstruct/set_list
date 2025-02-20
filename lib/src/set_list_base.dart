// little library for representing sets with sorted lists
// Dart doesn't provide `Comparable` for `int` or `Uint8List` which means it's kind of impossible to have a nice API here so it would feel shameful to publish this.

int compareInt(int a, int b) {
  if (a < b) return -1;
  if (a > b) return 1;
  return 0;
}

/// Dart didn't implement Comparable for int or Uint8List, so there's a variant where you have to pass in a comparator instead of just having a comparable type bound.
class SetListNoncompare<T> {
  final List<T> v;
  SetListNoncompare(this.v);
  SetListNoncompare.fromUnsorted(this.v, int Function(T a, T b) compare) {
    v.sort(compare);
  }

  /// finds either the index where item is in the set or the index where it would be inserted.
  int findIndexCompare(T item, int Function(T a, T b) compare) {
    int base = 0;
    int range = v.length;
    while (range > 0) {
      int mid = base + range ~/ 2;
      int cmp = compare(item, v[mid]);
      if (cmp < 0) {
        range = range ~/ 2;
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

  bool containsCompare(T item, int Function(T a, T b) compare) {
    int index = findIndexCompare(item, compare);
    return v.isNotEmpty && v[index] == item;
  }

  SetListNoncompare<T> unionCompare(
      SetListNoncompare<T> other, int Function(T a, T b) compare) {
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
    return SetListNoncompare(result);
  }

  SetListNoncompare<T> intersectionCompare(
      SetListNoncompare<T> other, int Function(T a, T b) compare) {
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
    return SetListNoncompare(result);
  }

  SetListNoncompare<T> differenceCompare(
      SetListNoncompare<T> other, int Function(T a, T b) compare) {
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
    return SetListNoncompare(result);
  }

  void addCompare(T item, int Function(T a, T b) compare) {
    int index = findIndexCompare(item, compare);
    if (v.isNotEmpty && v[index] == item) {
      return;
    } else {
      v.insert(index, item);
    }
  }

  void removeCompare(T item, int Function(T a, T b) compare) {
    int index = findIndexCompare(item, compare);
    if (v.isNotEmpty && v[index] == item) {
      v.removeAt(index);
    }
  }
}

class SetList<T extends Comparable<T>> extends SetListNoncompare<T> {
  SetList(super.v);
  SetList.fromUnsorted(List<T> v)
      : super.fromUnsorted(v, (a, b) => a.compareTo(b));

  int findIndex(T item) {
    return findIndexCompare(item, (a, b) => a.compareTo(b));
  }

  bool contains(T item) {
    return containsCompare(item, (a, b) => a.compareTo(b));
  }

  SetList<T> union(SetList<T> other) {
    return SetList(super.unionCompare(other, (a, b) => a.compareTo(b)).v);
  }

  SetList<T> intersection(SetList<T> other) {
    return SetList(
        super.intersectionCompare(other, (a, b) => a.compareTo(b)).v);
  }

  SetList<T> difference(SetList<T> other) {
    return SetList(super.differenceCompare(other, (a, b) => a.compareTo(b)).v);
  }

  void add(T item) {
    super.addCompare(item, (a, b) => a.compareTo(b));
  }

  void remove(T item) {
    super.removeCompare(item, (a, b) => a.compareTo(b));
  }
}
