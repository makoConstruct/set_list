import 'dart:collection';
import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:set_list/set_list.dart';

const int SIZE = 20000;

(SetList<int>, SetList<int>) generateLists(int size,
    {int winnowSecondSetToSize = -1, Comparator<int>? compare = compareInt}) {
  if (winnowSecondSetToSize == -1) {
    winnowSecondSetToSize = size;
  }
  // Create two lists with 50% overlap (on average)
  final random = Random(90);
  SetList<int> firstSet =
      SetList.assumeSorted(List.generate(size, (i) => i * 2), compare: compare);
  SetList<int> secondSet = SetList.assumeSorted(
      List.generate(size, (i) => i * 2 + 1)
        ..addAll(
            List.generate(size, (i) => i * 2).where((_) => random.nextBool())),
      compare: compare);

  if (winnowSecondSetToSize < size) {
    // Use reservoir sampling to randomly select items to keep
    var currentSize = secondSet.v.length;
    var toKeep = winnowSecondSetToSize;
    for (var i = toKeep; i < currentSize; i++) {
      var j = random.nextInt(i + 1);
      if (j < toKeep) {
        var temp = secondSet.v[j];
        secondSet.v[j] = secondSet.v[i];
        secondSet.v[i] = temp;
      }
    }
    secondSet.v.length = winnowSecondSetToSize;
    secondSet.v.sort(compare);
  }

  return (
    firstSet,
    secondSet,
  );
}

class SetListUnionBenchmark extends BenchmarkBase {
  late SetList<int> list1;
  late SetList<int> list2;
  final int size;
  final int winnowSecondSetToSize;
  SetListUnionBenchmark({this.size = SIZE, this.winnowSecondSetToSize = -1})
      : super('SetListUnion');

  @override
  void setup() {
    final (list1, list2) =
        generateLists(size, winnowSecondSetToSize: winnowSecondSetToSize);
    this.list1 = list1;
    this.list2 = list2;
  }

  @override
  void run() {
    final output = list1.union(list2).v;
    output.length;
  }
}

class HashSetUnionBenchmark extends BenchmarkBase {
  late Set<int> set1;
  late Set<int> set2;
  final int size;
  final int winnowSecondSetToSize;

  HashSetUnionBenchmark({this.size = SIZE, this.winnowSecondSetToSize = -1})
      : super('HashSetUnion');

  @override
  void setup() {
    final (list1, list2) =
        generateLists(size, winnowSecondSetToSize: winnowSecondSetToSize);
    set1 = HashSet.from(list1.v);
    set2 = HashSet.from(list2.v);
  }

  @override
  void run() {
    final output = set1.union(set2);
    output.length;
  }
}

class SetListIntersectionBenchmark extends BenchmarkBase {
  late SetList<int> list1;
  late SetList<int> list2;
  final bool usingComparisonScan;
  final int size;

  SetListIntersectionBenchmark(
      {required this.usingComparisonScan, this.size = SIZE})
      : super('SetListIntersection');

  @override
  void setup() {
    final (list1, list2) = generateLists(size);
    this.list1 = list1;
    this.list2 = list2;
  }

  @override
  void run() {
    List<int> output = [];
    if (usingComparisonScan) {
      list1.comparisonScan(list2, inBoth: (o) => output.add(o));
      assert(output.length == 9);
    } else {
      output = list1.intersection(list2).v;
      assert(output.length == 10082);
    }
  }
}

class HashSetIntersectionBenchmark extends BenchmarkBase {
  late Set<int> set1;
  late Set<int> set2;
  final int size;
  final bool nativeIntersectionImplementation;
  HashSetIntersectionBenchmark(
      {this.size = SIZE, this.nativeIntersectionImplementation = true})
      : super('HashSetIntersection');

  @override
  void setup() {
    final (list1, list2) = generateLists(size);
    set1 = HashSet.from(list1.v);
    set2 = HashSet.from(list2.v);
  }

  @override
  void run() {
    if (nativeIntersectionImplementation) {
      set1.intersection(set2);
    } else {
      final ret = HashSet<int>();
      for (final a in set2) {
        if (set1.contains(a)) {
          ret.add(a);
        }
      }
    }
  }
}

class SetListContainsBenchmark extends BenchmarkBase {
  late SetList<int> list;
  late List<int> itemsToCheck;
  final int size;
  final int numChecks;
  final int seed;

  SetListContainsBenchmark(
      {this.size = SIZE, this.numChecks = SIZE ~/ 2, this.seed = 90})
      : super('SetListContains');

  @override
  void setup() {
    final random = Random(seed);
    list = SetList.assumeSorted(List.generate(size, (i) => i * 2),
        compare: compareInt);
    // Create a mix of items that are in the list and not in the list
    itemsToCheck = List.generate(numChecks, (_) {
      if (random.nextBool()) {
        // Return an item that is in the list
        return random.nextInt(size) * 2;
      } else {
        // Return an item that is not in the list
        return random.nextInt(size) * 2 + 1;
      }
    });
  }

  @override
  void run() {
    int count = 0;
    for (final item in itemsToCheck) {
      if (list.contains(item)) {
        count++;
      }
    }
    count;
  }
}

class HashSetContainsBenchmark extends BenchmarkBase {
  late Set<int> set;
  late List<int> itemsToCheck;
  final int size;
  final int numChecks;
  final int seed;

  HashSetContainsBenchmark(
      {this.size = SIZE, this.numChecks = SIZE ~/ 2, this.seed = 90})
      : super('HashSetContains');

  @override
  void setup() {
    final random = Random(seed);
    set = HashSet.from(List.generate(size, (i) => i * 2));
    // Create a mix of items that are in the set and not in the set
    itemsToCheck = List.generate(numChecks, (_) {
      if (random.nextBool()) {
        // Return an item that is in the set
        return random.nextInt(size) * 2;
      } else {
        // Return an item that is not in the set
        return random.nextInt(size) * 2 + 1;
      }
    });
  }

  @override
  void run() {
    int count = 0;
    for (final item in itemsToCheck) {
      if (set.contains(item)) {
        count++;
      }
    }
    count;
  }
}

// finding: setlist is about twice as fast as hashset. Hashset native implementation is only 10% faster.
void testHashSetIntersectionNative() {
  SetListIntersectionBenchmark(usingComparisonScan: true).report();
  HashSetIntersectionBenchmark(nativeIntersectionImplementation: true).report();
  HashSetIntersectionBenchmark(nativeIntersectionImplementation: false)
      .report();
}

// finding: setlist is about twice as fast as hashset.
void testHashSetUnion() {
  SetListUnionBenchmark().report();
  HashSetUnionBenchmark().report();
  HashSetUnionBenchmark().report();
}

// finding: they're about the same now??
void testComparisonScan() {
  SetListIntersectionBenchmark(usingComparisonScan: false).report();
  SetListIntersectionBenchmark(usingComparisonScan: true).report();
}

// it's still a lot faster even for very small unions, I guess because it's faster to construct the output, because it isn't faster at contains checks.
void testSmallUnion() {
  SetListUnionBenchmark(winnowSecondSetToSize: 10).report();
  HashSetUnionBenchmark(winnowSecondSetToSize: 10).report();
}

void testVerySmallUnion() {
  SetListUnionBenchmark(winnowSecondSetToSize: 2).report();
  HashSetUnionBenchmark(winnowSecondSetToSize: 2).report();
}

void testSingleElementUnion() {
  SetListUnionBenchmark(winnowSecondSetToSize: 1).report();
  HashSetUnionBenchmark(winnowSecondSetToSize: 1).report();
}

// but finally hashset is 10x faster at this
void testContains() {
  SetListContainsBenchmark().report();
  HashSetContainsBenchmark().report();
}

void main() {
  testContains();
}
