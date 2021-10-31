/*
 * Package : sbom
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 22/09/2021
 * Copyright :  S.Hamblett
 */

part of sbom;

/// The SBOM file support class.
/// Provides convenience methods for file listings, SHA1 generation of file contents etc.
class SbomFileSupport {
  /// Construction
  SbomFileSupport(this._topLevelPath);

  /// Package top level
  final String _topLevelPath;

  /// Gets a list of Dart files in a package directory from the lib and
  /// bin directories.
  /// Returns a list of absolute file paths, empty if none found or
  /// an exception is raised.
  List<String> packageDartFiles() {
    var output = <String>[];
    try {
      // Lib
      final libDir = Directory(path.join(_topLevelPath, SbomConstants.libDir));
      final libFiles = libDir.listSync(recursive: true);
      for (final entity in libFiles) {
        if (entity is File) {
          var file = entity.absolute;
          if (path.extension(file.path) == SbomConstants.dartFiletype) {
            output.add(file.path);
          }
        }
      }
      // Bin
      final binDir = Directory(path.join(_topLevelPath, SbomConstants.binDir));
      final binFiles = binDir.listSync(recursive: true);
      for (final entity in binFiles) {
        if (entity is File) {
          var file = entity.absolute;
          if (path.extension(file.path) == SbomConstants.dartFiletype) {
            output.add(file.path);
          }
        }
      }
    } catch (e) {
      SbomUtilities.error(
          'File Support - exception $e thrown getting package files, the SBOM generation will be incorrect');
    }
    return output;
  }

  /// SHA1 digest helper.
  /// Returns a valid Digest or null if t cannot be calculated.
  Digest? _sha1Digest(String path) {
    try {
      final file = File(path);
      final bytes = file.readAsBytesSync();
      return sha1.convert(bytes);
    } catch (e) {
      SbomUtilities.warning(
          'File Support - exception $e thrown generating sha1 digest for $path, the SBOM generation will be incorrect');
    }
    return null;
  }

  /// Get the SHA1 digest of a supplied absolute file path as a string.
  /// Returns the digest or empty if it could not be calculated.
  String sha1DigestAsString(String path) {
    final digest = _sha1Digest(path);
    return digest == null ? '' : digest.toString();
  }

  /// Get the SHA1 digest of a supplied absolute file path as a list of bytes.
  /// Returns the digest or empty if it could not be calculated.
  List<int> sha1DigestAsBytes(String path) {
    final digest = _sha1Digest(path);
    return digest == null ? <int>[] : digest.bytes;
  }

  /// Get the combined SHA1 digest of a list of SHA1 digests.
  /// Returns the digest as a String which may be empty.
  String combinedDigest(List<String> digests) {
    final bytes = <int>[];
    for (final digest in digests) {
      bytes.addAll(digest.codeUnits);
    }
    return sha1.convert(bytes).toString();
  }

  /// Get the package verification code.
  /// This is generated from the SHA1 digests of a combination of all the dart files in the
  /// package with that of the pubspec.yaml file.
  /// The algorithm used is from section 3.9.4 of the SPDX 2.2 specification.
  /// Returns empty if the code cannot be generated.
  String packageVerificationCode() {
    // Get the Dart files SHA1 digests
    final dartFiles = packageDartFiles();
    final packageFileDigests = <String>[];
    for (final file in dartFiles) {
      final digest = sha1DigestAsString(file);
      if (digest.isNotEmpty) {
        packageFileDigests.add(digest);
      }
    }
    // Get the pubspec.yaml digest
    final pubspecPath = path.join(_topLevelPath, SbomConstants.pubspecName);
    final digest = sha1DigestAsString(pubspecPath);
    if (digest.isNotEmpty) {
      packageFileDigests.add(digest);
    }
    // Sort the digests ascending
    packageFileDigests.sort();
    return combinedDigest(packageFileDigests);
  }
}
