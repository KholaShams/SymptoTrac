import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Survey {
  String name;
  String email;
  bool anonymous;
  String opinion;
  int rating;

  Survey({required this.name, required this.email, required this.anonymous, required this.opinion, required this.rating});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SurveyForm(),
    );
  }
}

class SurveyForm extends StatefulWidget {
  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController opinionController = TextEditingController();
  int rating = 1;
  bool anonymous = false;

  List<Survey> surveys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SymptoTrack Feature Survey'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SymptoTrack Feature Survey',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              enabled: !anonymous, // Disable when anonymous
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: !anonymous, // Disable when anonymous
            ),
            Row(
              children: [
                Text('Anonymous:'),
                Switch(
                  value: anonymous,
                  onChanged: (value) {
                    setState(() {
                      anonymous = value;
                      if (anonymous) {
                        nameController.clear();
                        emailController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            TextField(
              controller: opinionController,
              decoration: InputDecoration(labelText: 'Opinion on adding the new feature'),
            ),
            DropdownButton<int>(
              value: rating,
              onChanged: (value) {
                setState(() {
                  rating = value!;
                });
              },
              items: List.generate(5, (index) => index + 1)
                  .map((value) => DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              ))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: () {
                submitSurvey();
              },
              child: Text('Submit Survey'),
            ),
            ElevatedButton(
              onPressed: () {
                redirectToExisting(context);
              },
              child: Text('View Existing Suggestions'),
            ),
          ],
        ),
      ),
    );
  }

  void submitSurvey() {
    final name = nameController.text;
    final email = emailController.text;
    final opinion = opinionController.text;

    final survey = Survey(name: name, email: email, anonymous: anonymous, opinion: opinion, rating: rating);

    surveys.add(survey);

    // You can save surveys to local storage or any other persistence method here.

    // Clear form
    nameController.clear();
    emailController.clear();
    opinionController.clear();

    // Refresh UI
    setState(() {});
  }

  void redirectToExisting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExistingSuggestions(surveys: surveys)),
    );
  }
}

class ExistingSuggestions extends StatelessWidget {
  final List<Survey> surveys;

  ExistingSuggestions({required this.surveys});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Suggestions - SymptoTrack Feature Survey'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Existing Suggestions - SymptoTrack Feature Survey',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: surveys.length,
                itemBuilder: (context, index) {
                  return SurveyItem(survey: surveys[index]);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                goBackToSurvey(context);
              },
              child: Text('Back to Survey'),
            ),
          ],
        ),
      ),
    );
  }

  void goBackToSurvey(BuildContext context) {
    Navigator.pop(context);
  }
}

class SurveyItem extends StatelessWidget {
  final Survey survey;

  SurveyItem({required this.survey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${survey.name} (${survey.email})',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Opinion: ${survey.opinion}'),
              Text('Rating: ${survey.rating}'),
            ],
          ),
        ),
      ),
    );
  }
}
