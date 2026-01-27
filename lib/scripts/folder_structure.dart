import 'dart:io';

void main() {
  final currentDir = Directory.current;
  print('Setting up project structure in existing directory: ${currentDir.path}');

  List<String> folders = [
    'lib/core/theme',
    'lib/core/localization',
    'lib/core/configs',
    'lib/core/constants',
    'lib/core/api',
    'lib/core/routes',
    'lib/commons/widgets',
    'lib/commons/models/enums',
    'lib/commons/blocs',
    'lib/commons/repositories',
    'lib/features',
    'lib/utils/extensions',
  ];

  for (var folder in folders) {
    Directory('${currentDir.path}/$folder').createSync(recursive: true);
  }

  print('Project structure setup completed successfully!');
}
