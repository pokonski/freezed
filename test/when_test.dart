// ignore_for_file: prefer_const_constructors, omit_local_variable_types
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

import 'integration/multiple_constructors.dart';

void main() {
  group('when', () {
    group('default ctor', () {
      test("assert callbacks can't be null", () {
        final value = Complex('a');

        expect(
          () => value.when(
            (a) {},
            first: null,
            second: (a, c, d) {},
          ),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => value.when(
            null,
            first: (a, b, d) {},
            second: (a, c, d) {},
          ),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => value.when(
            (a) {},
            first: (a, b, d) {},
            second: null,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
      test('calls default callback', () {
        final value = Complex('a');

        expect(
          value.when(
            (String a) => '$a 42',
            first: (String a, bool b, double d) => throw Error(),
            second: (String a, int c, double d) => throw Error(),
          ),
          'a 42',
        );
      });
    });
    group('first ctor', () {
      test("assert callbacks can't be null", () {
        final value = Complex.first('a');

        expect(
          () => value.when(
            (a) {},
            first: null,
            second: (a, c, d) {},
          ),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => value.when(
            null,
            first: (a, b, d) {},
            second: (a, c, d) {},
          ),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => value.when(
            (a) {},
            first: (a, b, d) {},
            second: null,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
      test('calls first callback', () {
        final value = Complex.first('a', b: false, d: .42);

        expect(
          value.when(
            (String a) => throw Error(),
            first: (String a, bool b, double d) => '$a $b $d',
            second: (String a, int c, double d) => throw Error(),
          ),
          'a false 0.42',
        );
      });
    });
    group('second ctor', () {
      test("assert callbacks can't be null", () {
        final value = Complex.second('a');

        expect(
          () => value.when(
            (a) {},
            first: null,
            second: (a, c, d) {},
          ),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => value.when(
            null,
            first: (a, b, d) {},
            second: (a, c, d) {},
          ),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => value.when(
            (a) {},
            first: (a, b, d) {},
            second: null,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
      test('calls second callback', () {
        final value = Complex.second('a', 21, .42);

        expect(
          value.when(
            (String a) => throw Error(),
            first: (String a, bool b, double d) => throw Error(),
            second: (String a, int c, double d) => '$a $c $d',
          ),
          'a 21 0.42',
        );
      });
    });
    test('named parameters are marked as required', () async {
      final main = await resolveSources(
        {
          'immutable|test/integration/main.dart': r'''
library main;
import 'multiple_constructors.dart';

void main() {
  final value = Complex.first('a', b: false, d: .42);

  value.when(
    (String a) => 42,
  );
}
''',
        },
        (r) => r.findLibraryByName('main'),
      );

      final errorResult = await main.session.getErrors('/immutable/test/integration/main.dart');

      expect(errorResult.errors, isNotEmpty);
    });
  });
  // TODO: no default ctor
}