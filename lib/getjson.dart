import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void main()
{
  runApp(const MyAppjson());
}

class MyAppjson extends StatelessWidget {
  const MyAppjson({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JsonListViewExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class JsonListViewExample extends StatefulWidget {
  const JsonListViewExample({super.key});

  @override
  State<JsonListViewExample> createState() => _JsonListViewExampleState();
}

class _JsonListViewExampleState extends State<JsonListViewExample> {
  // Explicitly typing the Future as List<dynamic> to avoid type mismatch errors
  Future<List<dynamic>> fetchUsers() async {
    // FIX 1: Wrap the string URL in Uri.parse() to fix the http.get type error
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');


    final response = await http.get(url);

    if (response.statusCode == 200) {
      // FIX 2: Ensure 'dart:convert' is imported at the top for jsonDecode to work
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error-Free JSON ListView'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final List<dynamic> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> user = users[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(user['title'] ?? 'title'),
                  subtitle: Text(user['body'] ?? 'body'),

                );
              },
            );
          }

          return const Center(child: Text('No data found'));
        },
      ),
    );
  }
}


class JsonListViewExample1 extends StatefulWidget {
  const JsonListViewExample1({super.key});

  @override
  State<JsonListViewExample1> createState() => _JsonListViewExample1State();
}

class _JsonListViewExample1State extends State<JsonListViewExample1> {
  // Posts API वरून डेटा मिळवण्यासाठी फंक्शन
  Future<List<dynamic>> fetchPosts() async {
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
   // final Uri url = Uri.parse('http://localhost:3000/users');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts JSON ListView'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final List<dynamic> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> post = posts[index];

                //  JSON (Keys)
                final String id = post['id'].toString();
                final String userId = post['userId'].toString();
                final String title = post['title'] ?? 'No Title';
                final String body = post['body'] ?? 'No Content';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    // 1. डाव्या बाजूला गोल चिन्हात 'id' दाखवला आहे
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        id,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'ID: $id  |  User ID: $userId',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        // पोस्टचा मुख्य मजकूर (body)
                        Text(
                          body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No data found'));
        },
      ),
    );
  }
}


                //final Map<String, dynamic> post = posts[index];

                //  JSON (Keys)
                //final String id = post['id'].toString();
                //final String name = post['name'].toString();
                //final String author = post['author'] ?? 'author';
                //final String title = post['title'] ?? 'title';
                //final String description = post['description'] ?? 'description';
                //final String url = post['url'] ?? 'url';
                //final String urltoimage = post['urltoimage'] ?? 'urltoimage';
                //final String publishedAt = post['publishedAt'] ?? 'publishedAt';
                //final String content = post['content'] ?? 'content';


class JsonListViewnews1 extends StatefulWidget {
  const JsonListViewnews1({super.key});

  @override
  State<JsonListViewnews1> createState() => _JsonListViewnews1State();
}

class _JsonListViewnews1State extends State<JsonListViewnews1> {
  Future<List<dynamic>> fetchPosts() async {
    final Uri url = Uri.parse(
        'https://newsapi.org/v2/everything?q=apple&from=2026-05-29&to=2026-05-29&sortBy=popularity&apiKey=7c7507db282642a4bf86f0e1eb6be1d4');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['articles'] as List<dynamic>;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: Colors.transparent ,centerTitle: true,foregroundColor: Colors.black,
        elevation: 0,flexibleSpace: Container(decoration: BoxDecoration(color: Colors.lightBlue,borderRadius:BorderRadius.circular(10.0),boxShadow:[BoxShadow(color: Colors.black,blurRadius: 10,offset: Offset(0, 4))] )),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final List<dynamic> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> post = posts[index];

                // बदल ३: NewsAPI च्या अचूक स्ट्रक्चरनुसार की (Keys) मॅप केल्या
                final Map<String, dynamic> source = post['source'] ?? {};
                final String id = source['id']?.toString() ?? 'N/A';
                final String name = source['name']?.toString() ?? 'Unknown';

                final String author = post['author'] ?? 'No Author';
                final String title = post['title'] ?? 'No Title';
                final String description = post['description'] ?? 'No Description';
                final String url = post['url'] ?? '';
                final String urlToImage = post['urlToImage'] ?? ''; // कॅपिटल 'T' आवश्यक
                final String publishedAt = post['publishedAt'] ?? '';
                final String content = post['content'] ?? '';
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.orangeAccent,borderRadius: BorderRadius.circular(15.0),boxShadow: [BoxShadow(color: Colors.black,blurRadius: 10,offset: Offset(0, 4))]),
                  padding: EdgeInsets.all(16.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      child: Text(
                        id.substring(0, id.length > 2 ? 2 : id.length),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    title: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 14),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        TextButton.icon(
                          onPressed: () {
                            // Your action here
                          },
                          icon: const Icon(Icons.person),
                          label: const Text('Author'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue, // Colors both text and icon
                          ),
                        ),
                        Text(
                          ' $author',
                          maxLines: 1,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        TextButton.icon(
                          onPressed: () {
                            // Your action here
                          },
                          icon: const Icon(Icons.note_alt_sharp),
                          label: const Text('Title'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue, // Colors both text and icon
                          ),
                        ),
                        Text(
                          '$title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        TextButton.icon(
                          onPressed: () {
                            // Your action here
                          },
                          icon: const Icon(Icons.description_rounded),
                          label: const Text('Description'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue, // Colors both text and icon
                          ),
                        ),
                        Text(
                          ' $description',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black,fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'URL: $url',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black,fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        //Image.network(urlToImage,height: 100,width: 100,alignment: Alignment.center,),
                        Text(
                          'Image URL: $urlToImage',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black,fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Published: $publishedAt',
                          maxLines:1,
                          style: const TextStyle(color: Colors.black, fontSize: 11,),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            // Your action here
                          },
                          icon: const Icon(Icons.content_paste_outlined),
                          label: const Text('Content'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue, // Colors both text and icon
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ' $content',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black,fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No data found'));
        },
      ),
    );
  }
}




