/*
 * Package : sbom
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 22/09/2021
 * Copyright :  S.Hamblett
 */

import 'dart:isolate';
import 'package:sbom/sbom.dart';

/// SBOM
int main(List<String> args) {
  final licenseUri = Isolate.resolvePackageUriSync(
    Uri.parse('package:sbom/src/spdx/licences'),
  );
  if (licenseUri == null) {
    throw Exception('Unable to resolve package path. Script will not work.');
  }

  // Announce
  print('SBOM generator for Dart packages');
  // Construct the SBOM configuration
  final configuration = SbomConfiguration(
    args,
    licensePath: licenseUri.path,
  );

  // Check validity, if not valid then return.
  // The user may have just asked for usage or some other
  // error occurred.
  print('Parsing SBOM configuration file');
  if (!configuration.valid) {
    return 0;
  }

  // Parse the SBOM configuration file
  configuration.parseSbomFiles();
  if (!configuration.valid) {
    return -1;
  }

  // Generate the Sbom
  print('Generating the SBOM');
  final generator = SbomGenerator(configuration);
  generator.generate();
  if (!generator.valid) {
    return -1;
  }

  // Finish
  print('${SbomConstants.reset}SBOM generation complete');

  return 0;
}
