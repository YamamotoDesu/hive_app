# [hive_app](https://www.youtube.com/watch?v=xN_OTO5EYKY&t=104s)

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

