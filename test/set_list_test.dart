import 'package:set_list/set_list.dart';
import 'package:test/test.dart';

void main() {
  group('findIndexCompare', () {
    test('empty list', () {
      var empty = SetList<int>([], compare: compareInt);
      expect(empty.findIndex(1), equals(0));
    });

    test('multiple elements with integers', () {
      var multi = SetList<int>([1, 3, 5, 7, 9], compare: compareInt);
      expect(multi.findIndex(0), equals(0));
      expect(multi.findIndex(1), equals(0));
      expect(multi.findIndex(2), equals(1));
      expect(multi.findIndex(3), equals(1));
      expect(multi.findIndex(4), equals(2));
      expect(multi.findIndex(5), equals(2));
      expect(multi.findIndex(6), equals(3));
      expect(multi.findIndex(7), equals(3));
      expect(multi.findIndex(8), equals(4));
      expect(multi.findIndex(9), equals(4));
      expect(multi.findIndex(10), equals(5));
    });

    test('strings with custom comparator', () {
      var strings = SetList<String>(["apple", "banana", "orange"]);
      expect(strings.findIndex("apple"), equals(0));
      expect(strings.findIndex("banana"), equals(1));
      expect(strings.findIndex("mango"), equals(2));
      expect(strings.findIndex("zebra"), equals(3));
    });
  });

  group('intersectionCompare', () {
    test('empty lists', () {
      var empty1 = SetList<int>([], compare: compareInt);
      var empty2 = SetList<int>([], compare: compareInt);
      var result = empty1.intersection(empty2);
      expect(result.v, equals([]));
    });

    test('one empty list', () {
      var list1 = SetList<int>([1, 2, 3], compare: compareInt);
      var empty = SetList<int>([], compare: compareInt);
      var result = list1.intersection(empty);
      expect(result.v, equals([]));
    });

    test('no overlap', () {
      var list1 = SetList<int>([1, 3, 5], compare: compareInt);
      var list2 = SetList<int>([2, 4, 6], compare: compareInt);
      var result = list1.intersection(list2);
      expect(result.v, equals([]));
    });

    test('partial overlap', () {
      var list1 = SetList<int>([1, 2, 3, 4], compare: compareInt);
      var list2 = SetList<int>([3, 4, 5, 6], compare: compareInt);
      var result = list1.intersection(list2);
      expect(result.v, equals([3, 4]));
    });

    test('complete overlap', () {
      var list1 = SetList<int>([1, 2, 3], compare: compareInt);
      var list2 = SetList<int>([1, 2, 3], compare: compareInt);
      var result = list1.intersection(list2);
      expect(result.v, equals([1, 2, 3]));
    });

    test('with strings', () {
      var list1 = SetList<String>(["apple", "banana", "orange"]);
      var list2 = SetList<String>(["banana", "grape", "orange"]);
      var result = list1.intersection(list2);
      expect(result.v, equals(["banana", "orange"]));
    });
  });

  group('unionCompare', () {
    test('empty lists', () {
      var empty1 = SetList<int>([], compare: compareInt);
      var empty2 = SetList<int>([], compare: compareInt);
      var result = empty1.union(empty2);
      expect(result.v, equals([]));
    });

    test('one empty list', () {
      var list1 = SetList<int>([1, 2, 3], compare: compareInt);
      var empty = SetList<int>([], compare: compareInt);
      var result = list1.union(empty);
      expect(result.v, equals([1, 2, 3]));
    });

    test('no overlap', () {
      var list1 = SetList<int>([1, 3, 5], compare: compareInt);
      var list2 = SetList<int>([2, 4, 6], compare: compareInt);
      var result = list1.union(list2);
      expect(result.v, equals([1, 2, 3, 4, 5, 6]));
    });

    test('partial overlap', () {
      var list1 = SetList<int>([1, 2, 3, 4], compare: compareInt);
      var list2 = SetList<int>([3, 4, 5, 6], compare: compareInt);
      var result = list1.union(list2);
      expect(result.v, equals([1, 2, 3, 4, 5, 6]));
    });

    test('complete overlap', () {
      var list1 = SetList<int>([1, 2, 3], compare: compareInt);
      var list2 = SetList<int>([1, 2, 3], compare: compareInt);
      var result = list1.union(list2);
      expect(result.v, equals([1, 2, 3]));
    });

    test('with strings', () {
      var list1 = SetList<String>(["apple", "banana", "orange"]);
      var list2 = SetList<String>(["banana", "grape", "orange"]);
      var result = list1.union(list2);
      expect(result.v, equals(["apple", "banana", "grape", "orange"]));
    });
  });

  group('differenceCompare', () {
    test('empty lists', () {
      var empty1 = SetList<int>([], compare: compareInt);
      var empty2 = SetList<int>([], compare: compareInt);
      var result = empty1.difference(empty2);
      expect(result.v, equals([]));
    });

    test('one empty list', () {
      var list1 = SetList<int>([1, 2, 3], compare: compareInt);
      var empty = SetList<int>([], compare: compareInt);
      var result = list1.difference(empty);
      expect(result.v, equals([1, 2, 3]));
    });

    test('no overlap', () {
      var list1 = SetList<int>([1, 3, 5], compare: compareInt);
      var list2 = SetList<int>([2, 4, 6], compare: compareInt);
      var result = list1.difference(list2);
      expect(result.v, equals([1, 3, 5]));
    });

    test('partial overlap', () {
      var list1 = SetList<int>([1, 2, 3, 4], compare: compareInt);
      var list2 = SetList<int>([3, 4, 5, 6], compare: compareInt);
      var result = list1.difference(list2);
      expect(result.v, equals([1, 2]));
    });

    test('complete overlap', () {
      var list1 = SetList<int>([1, 2, 3], compare: compareInt);
      var list2 = SetList<int>([1, 2, 3], compare: compareInt);
      var result = list1.difference(list2);
      expect(result.v, equals([]));
    });

    test('with strings', () {
      var list1 = SetList<String>(["apple", "banana", "orange"]);
      var list2 = SetList<String>(["banana", "grape", "orange"]);
      var result = list1.difference(list2);
      expect(result.v, equals(["apple"]));
    });
  });

  group('addCompare', () {
    test('add to empty list', () {
      var list = SetList<int>([], compare: compareInt);
      list.add(1);
      expect(list.v, equals([1]));
    });

    test('add to non-empty list', () {
      var list = SetList<int>([1, 3, 5], compare: compareInt);
      list.add(4);
      expect(list.v, equals([1, 3, 4, 5]));
    });

    test('add duplicate element', () {
      var list = SetList<int>([1, 2, 3], compare: compareInt);
      list.add(2);
      expect(list.v, equals([1, 2, 3]));
    });

    test('add with strings', () {
      var list = SetList<String>(["apple", "orange"]);
      list.add("banana");
      expect(list.v, equals(["apple", "banana", "orange"]));
    });
  });

  group('removeCompare', () {
    test('remove from empty list', () {
      var list = SetList<int>([], compare: compareInt);
      list.remove(1);
      expect(list.v, equals([]));
    });

    test('remove existing element', () {
      var list = SetList<int>([1, 2, 3, 4], compare: compareInt);
      list.remove(2);
      expect(list.v, equals([1, 3, 4]));
    });

    test('remove non-existing element', () {
      var list = SetList<int>([1, 3, 5], compare: compareInt);
      list.remove(2);
      expect(list.v, equals([1, 3, 5]));
    });

    test('remove with strings', () {
      var list = SetList<String>(["apple", "banana", "orange"]);
      list.remove("banana");
      expect(list.v, equals(["apple", "orange"]));
    });
  });

  group('comparisonScan', () {
    test('general', () {
      var list1 = SetList<int>([1, 3, 5, 7, 9], compare: compareInt);
      var list2 = SetList<int>([2, 3, 6, 8, 9, 10, 11], compare: compareInt);
      var onlyA = [];
      var onlyB = [];
      var both = [];
      list1.comparisonScan(list2,
          onlyInThis: (a) => onlyA.add(a),
          onlyInOther: (b) => onlyB.add(b),
          inBoth: (a) => both.add(a));
      expect(onlyA, equals([1, 5, 7]));
      expect(onlyB, equals([2, 6, 8, 10, 11]));
      expect(both, equals([3, 9]));
    });
  });
}
