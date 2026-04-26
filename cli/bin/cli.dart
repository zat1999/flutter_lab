import 'package:cli/wikipedia.dart' as wiki;

// Define the version of the CLI application
const version = '1.0.0';

void main(List<String> arguments) {
  if(arguments.isEmpty){
    printUsage();
  }
  else if(arguments[0] == '--help' || arguments[0] == '-h' || arguments[0] == 'help'){
    printUsage();
  }
  else if(arguments[0] == '--version' || arguments[0] == '-v' || arguments[0] == 'version'){
    print('CLI Application Version: $version');
  }
  else if(arguments[0] == '--search' || arguments[0] == '-s' || arguments[0] == 'search'){
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    wiki.searchWikipedia(inputArgs);
  }
  else {
    print('Unknown option: ${arguments[0]}');
    printUsage();
  } 
}


void printUsage() {
  print('Usage: dart cli.dart [options]');
  print('Options:');
  print('  --version, -v, version   Show the version of the CLI application');
  print('  --help, -h, help        Show this usage information');
  print('  --search, -s, search <ARTICLE_NAME>  Search for an article by name');
}

