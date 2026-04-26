import 'dart:io';
import 'package:http/http.dart' as http;

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