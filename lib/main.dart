import 'package:flutter/material.dart';
import 'package:hive_app/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('peopleBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 13, 31, 57),
      appBar: AppBar(
        title: const Text('Hive Demo'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Image.network(
            'https://avatars.githubusercontent.com/u/60202664?s=400&u=5b3b6b3b5b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0&v=4',
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Age',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          boxPersons.put(
                            'key_${nameController.text}',
                            Person(
                              name: nameController.text,
                              age: int.parse(ageController.text),
                            ),
                          );
                        });
                      },
                      child: const Text(
                        'Add Person',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: boxPersons.length,
                    itemBuilder: (context, index) {
                      Person person = boxPersons.getAt(index);
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            setState(() {
                              boxPersons.deleteAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.remove,
                          ),
                        ),
                        title: Text(
                          person.name,
                        ),
                        subtitle: const Text(
                          'Name',
                        ),
                        trailing: Text(
                          'age ${person.age.toString()}',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
