import 'package:cli/cli.dart' as cli;
import 'dart:io';
import 'package:http/http.dart' as http;

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
    searchWikipedia(inputArgs);
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

void searchWikipedia(List<String>? arguments) async {
  //print('searchWikipedia received arguments: $arguments');

  final String articleName;

  if(arguments == null || arguments.isEmpty){
    print('Please provide an article name to search for.');
    final inputFromStdin = stdin.readLineSync();
    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('No article title provided. Exiting.');
      return; // Exit the function if no valid input
    }

    articleName = inputFromStdin;
  }
  else {
    articleName = arguments.join(' ');
  }

  print('Looking up articles about "$articleName". Please wait.');

  var articleContent = await getWikipediaArticle(articleName);
  print(articleContent);



}

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org',
    'api/rest_v1/page/summary/$articleTitle',
  );
  
  final response = await http.get(url); // Make the HTTP request

  if (response.statusCode == 200) {
    return response.body; // Return the response body if successful
  }

  // Return an error message if the request failed
  return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
}