/*
 * Package : sbom
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 25/09/2021
 * Copyright :  S.Hamblett
 */
import 'package:sbom/sbom.dart';
import 'package:test/test.dart';

@TestOn('VM')
void main() {
  group('SPDX', () {
    final builder = SbomSpdxTagBuilder();
    test('Tag by type', () {
      final tags = SbomSpdxTags(builder);
      expect(tags.tags.length, 2);
    });
  });
}
