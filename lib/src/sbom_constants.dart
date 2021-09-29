/*
 * Package : sbom
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 22/09/2021
 * Copyright :  S.Hamblett
 */

part of sbom;

/// The main sbom constants class
class SbomConstants {
  /// General off/none indicator for integers
  static const int off = 0;

  /// Verbosity(Loudness)
  static const int loud = 1;
  static const int louder = 2;

  /// Terminal colours
  static const String yellow = '\u001b[33m';
  static const String red = '\u001b[31m';
}
