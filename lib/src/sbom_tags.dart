/*
 * Package : sbom
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 22/09/2021
 * Copyright :  S.Hamblett
 */

part of sbom;

/// Tags database.
/// T, tag,
/// Y tag type
/// S, tag section
/// B, tag builder.
abstract class SbomTags<T, S, B, Y> {
  /// Construction
  SbomTags(this.builder);

  /// The tag database.
  final List<T> tags = <T>[];

  /// The tag builder.
  B builder;

  /// Get all tags for a specified section in section position order.
  List<T> sectionTags(S section);

  /// Get a tag by its type.
  T tagByType(Y type);

  /// Get a tag by its name
  T tagByName(String name);

  /// Check if a section is valid, i.e all its mandatory tags have values.
  /// Returns a list of mandatory tags that do not have values, empty
  /// indicating the section is valid.
  List<T> sectionValid(S section);
}
