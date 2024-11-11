import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:speech_to_text/speech_to_text.dart' as st;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// API keys and CSE ID for Google Custom Search
const String apiKey = 'YOUR_API_KEY';
const String cseId = '4391ec3fdd19b495d';

class ConstructionSearchPage extends StatefulWidget {
  @override
  _ConstructionSearchPageState createState() => _ConstructionSearchPageState();
}

class _ConstructionSearchPageState extends State<ConstructionSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final st.SpeechToText _speech = st.SpeechToText();
  String _selectedFilter = 'materials';
  bool _isListening = false;
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _speech.initialize();
    loadSearchHistory();
  }

  Future<void> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> saveSearchHistory(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_searchHistory.contains(query)) {
      _searchHistory.add(query);
      await prefs.setStringList('searchHistory', _searchHistory);
    }
  }

  // Fetch search results from Google CSE
  Future<List<String>> fetchSearchResults(String query) async {
    final url =
        'https://www.googleapis.com/customsearch/v1?q=$query+$selectedFilter&key=$apiKey&cx=$cseId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> searchResults = [];
      for (var item in data['items']) {
        searchResults.add(item['link']);
      }
      await saveSearchHistory(query);
      return searchResults;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  // Speech-to-Text with feedback
  void startListening() async {
    await _speech.listen(onResult: (result) {
      setState(() {
        _controller.text = result.recognizedWords;
      });
    });
    setState(() {
      _isListening = true;
    });
  }

  void stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Display search results in WebView
  Widget buildSearchResults(List<String> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewPage(url: results[index]),
              ),
            );
          },
        );
      },
    );
  }

  // Autocomplete suggestion for search
  Widget buildAutoCompleteSearch() {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search construction materials, tools, news...',
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
            },
          ),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return await fetchSearchResults(pattern);
      },
      itemBuilder: (context, suggestion) {
        return ListTile(title: Text(suggestion));
      },
      onSuggestionSelected: (suggestion) {
        _controller.text = suggestion;
        fetchSearchResults(suggestion);
      },
    );
  }

  // Show loading indicator and error handling for search results
  Widget buildSearchResultsContainer() {
    return FutureBuilder<List<String>>(
      future: fetchSearchResults(_controller.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found.'));
        } else {
          return buildSearchResults(snapshot.data!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Construction Search'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Placeholder for push notifications
              // Integrate with a notification service for real updates
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Dropdown with additional options
          DropdownButton<String>(
            value: _selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
            items: <String>['materials', 'news', 'tools', 'location', 'ratings']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // Search Bar with Autocomplete
          buildAutoCompleteSearch(),
          // Voice Search Button
          IconButton(
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
            onPressed: _isListening ? stopListening : startListening,
          ),
          // Display previous search history
          _searchHistory.isNotEmpty
              ? Expanded(
                  child: ListView(
                    children: _searchHistory.map((query) {
                      return ListTile(
                        title: Text(query),
                        onTap: () {
                          _controller.text = query;
                          fetchSearchResults(query);
                        },
                      );
                    }).toList(),
                  ),
                )
              : Container(),
          // Display search results
          Expanded(child: buildSearchResultsContainer()),
        ],
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Web View'), backgroundColor: Colors.blue),
      body: WebView(initialUrl: url),
    );
  }
}
