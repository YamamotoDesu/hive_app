# [hive_app](https://www.youtube.com/watch?v=xN_OTO5EYKY&t=104s)

https://docs.hivedb.dev/#/

<img width="300" alt="スクリーンショット 2023-05-13 17 57 20" src="https://github.com/YamamotoDesu/hive_app/assets/47273077/aaf1daeb-34d6-4650-8616-f567ce1d0cb9">

### Add Hive Library
```yml
dependencies:
  hive:
  hive_flutter:

dev_dependencies:
  hive_generator: 
  build_runner:
```


### Generate adapter
https://github.com/hivedb/docs/blob/master/custom-objects/generate_adapter.md

person.dart
```dart
import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  Person({
    required this.name,
    required this.age,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  int age;
}
```

```
Run build task flutter packages pub run build_runner build
```

<img width="722" alt="スクリーンショット_2023_05_13_15_15" src="https://github.com/YamamotoDesu/hive_app/assets/47273077/ce2238f0-86cc-4018-a061-bdfeb9670e4e">

## [Initialize](https://docs.hivedb.dev/#/?id=initialize)
```dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
```

## [Register Adapter](https://docs.hivedb.dev/#/custom-objects/type_adapters?id=register-adapter)
lib/boxes.dart
```dart
import 'package:hive/hive.dart';

late Box boxPersons;
```

```dart
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('peopleBox');
```

main.dart
```dart
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
```
