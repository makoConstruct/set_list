import 'package:set_list/set_list.dart';
import 'package:test/test.dart';

void main() {
  group('findIndexCompare', () {
    test('empty list', () {
      var empty = SetListNoncompare<int>([]);
      expect(empty.findIndexCompare(1, compareInt), equals(0));
    });

    test('multiple elements with integers', () {
      var multi = SetListNoncompare<int>([1, 3, 5, 7, 9]);
      expect(multi.findIndexCompare(0, compareInt), equals(0));
      expect(multi.findIndexCompare(1, compareInt), equals(0));
      expect(multi.findIndexCompare(2, compareInt), equals(1));
      expect(multi.findIndexCompare(3, compareInt), equals(1));
      expect(multi.findIndexCompare(4, compareInt), equals(2));
      expect(multi.findIndexCompare(5, compareInt), equals(2));
      expect(multi.findIndexCompare(6, compareInt), equals(3));
      expect(multi.findIndexCompare(7, compareInt), equals(3));
      expect(multi.findIndexCompare(8, compareInt), equals(4));
      expect(multi.findIndexCompare(9, compareInt), equals(4));
      expect(multi.findIndexCompare(10, compareInt), equals(5));
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
      var empty1 = SetListNoncompare<int>([]);
      var empty2 = SetListNoncompare<int>([]);
      var result = empty1.intersectionCompare(empty2, compareInt);
      expect(result.v, equals([]));
    });

    test('one empty list', () {
      var list1 = SetListNoncompare<int>([1, 2, 3]);
      var empty = SetListNoncompare<int>([]);
      var result = list1.intersectionCompare(empty, compareInt);
      expect(result.v, equals([]));
    });

    test('no overlap', () {
      var list1 = SetListNoncompare<int>([1, 3, 5]);
      var list2 = SetListNoncompare<int>([2, 4, 6]);
      var result = list1.intersectionCompare(list2, compareInt);
      expect(result.v, equals([]));
    });

    test('partial overlap', () {
      var list1 = SetListNoncompare<int>([1, 2, 3, 4]);
      var list2 = SetListNoncompare<int>([3, 4, 5, 6]);
      var result = list1.intersectionCompare(list2, compareInt);
      expect(result.v, equals([3, 4]));
    });

    test('complete overlap', () {
      var list1 = SetListNoncompare<int>([1, 2, 3]);
      var list2 = SetListNoncompare<int>([1, 2, 3]);
      var result = list1.intersectionCompare(list2, compareInt);
      expect(result.v, equals([1, 2, 3]));
    });

    test('with strings', () {
      var list1 = SetListNoncompare<String>(["apple", "banana", "orange"]);
      var list2 = SetListNoncompare<String>(["banana", "grape", "orange"]);
      var result = list1.intersectionCompare(list2, (a, b) => a.compareTo(b));
      expect(result.v, equals(["banana", "orange"]));
    });
  });

  group('unionCompare', () {
    test('empty lists', () {
      var empty1 = SetListNoncompare<int>([]);
      var empty2 = SetListNoncompare<int>([]);
      var result = empty1.unionCompare(empty2, compareInt);
      expect(result.v, equals([]));
    });

    test('one empty list', () {
      var list1 = SetListNoncompare<int>([1, 2, 3]);
      var empty = SetListNoncompare<int>([]);
      var result = list1.unionCompare(empty, compareInt);
      expect(result.v, equals([1, 2, 3]));
    });

    test('no overlap', () {
      var list1 = SetListNoncompare<int>([1, 3, 5]);
      var list2 = SetListNoncompare<int>([2, 4, 6]);
      var result = list1.unionCompare(list2, compareInt);
      expect(result.v, equals([1, 2, 3, 4, 5, 6]));
    });

    test('partial overlap', () {
      var list1 = SetListNoncompare<int>([1, 2, 3, 4]);
      var list2 = SetListNoncompare<int>([3, 4, 5, 6]);
      var result = list1.unionCompare(list2, compareInt);
      expect(result.v, equals([1, 2, 3, 4, 5, 6]));
    });

    test('complete overlap', () {
      var list1 = SetListNoncompare<int>([1, 2, 3]);
      var list2 = SetListNoncompare<int>([1, 2, 3]);
      var result = list1.unionCompare(list2, compareInt);
      expect(result.v, equals([1, 2, 3]));
    });

    test('with strings', () {
      var list1 = SetListNoncompare<String>(["apple", "banana", "orange"]);
      var list2 = SetListNoncompare<String>(["banana", "grape", "orange"]);
      var result = list1.unionCompare(list2, (a, b) => a.compareTo(b));
      expect(result.v, equals(["apple", "banana", "grape", "orange"]));
    });
  });

  group('differenceCompare', () {
    test('empty lists', () {
      var empty1 = SetListNoncompare<int>([]);
      var empty2 = SetListNoncompare<int>([]);
      var result = empty1.differenceCompare(empty2, compareInt);
      expect(result.v, equals([]));
    });

    test('one empty list', () {
      var list1 = SetListNoncompare<int>([1, 2, 3]);
      var empty = SetListNoncompare<int>([]);
      var result = list1.differenceCompare(empty, compareInt);
      expect(result.v, equals([1, 2, 3]));
    });

    test('no overlap', () {
      var list1 = SetListNoncompare<int>([1, 3, 5]);
      var list2 = SetListNoncompare<int>([2, 4, 6]);
      var result = list1.differenceCompare(list2, compareInt);
      expect(result.v, equals([1, 3, 5]));
    });

    test('partial overlap', () {
      var list1 = SetListNoncompare<int>([1, 2, 3, 4]);
      var list2 = SetListNoncompare<int>([3, 4, 5, 6]);
      var result = list1.differenceCompare(list2, compareInt);
      expect(result.v, equals([1, 2]));
    });

    test('complete overlap', () {
      var list1 = SetListNoncompare<int>([1, 2, 3]);
      var list2 = SetListNoncompare<int>([1, 2, 3]);
      var result = list1.differenceCompare(list2, compareInt);
      expect(result.v, equals([]));
    });

    test('with strings', () {
      var list1 = SetListNoncompare<String>(["apple", "banana", "orange"]);
      var list2 = SetListNoncompare<String>(["banana", "grape", "orange"]);
      var result = list1.differenceCompare(list2, (a, b) => a.compareTo(b));
      expect(result.v, equals(["apple"]));
    });
  });

  group('addCompare', () {
    test('add to empty list', () {
      var list = SetListNoncompare<int>([]);
      list.addCompare(1, compareInt);
      expect(list.v, equals([1]));
    });

    test('add to non-empty list', () {
      var list = SetListNoncompare<int>([1, 3, 5]);
      list.addCompare(4, compareInt);
      expect(list.v, equals([1, 3, 4, 5]));
    });

    test('add duplicate element', () {
      var list = SetListNoncompare<int>([1, 2, 3]);
      list.addCompare(2, compareInt);
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
      var list = SetListNoncompare<int>([]);
      list.removeCompare(1, compareInt);
      expect(list.v, equals([]));
    });

    test('remove existing element', () {
      var list = SetListNoncompare<int>([1, 2, 3, 4]);
      list.removeCompare(2, compareInt);
      expect(list.v, equals([1, 3, 4]));
    });

    test('remove non-existing element', () {
      var list = SetListNoncompare<int>([1, 3, 5]);
      list.removeCompare(2, compareInt);
      expect(list.v, equals([1, 3, 5]));
    });

    test('remove with strings', () {
      var list = SetList<String>(["apple", "banana", "orange"]);
      list.remove("banana");
      expect(list.v, equals(["apple", "orange"]));
    });
  });
}
