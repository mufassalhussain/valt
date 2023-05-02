
# Valt

Valt is a Flutter plugin that enables easy reading and writing of simple key-value pairs with AES encryption for secure local storage. 

Here's how you can use this library:

Supported data types are `int`, `double`, `bool`, `String`, `List<dynamic>` and `Map<dynamic>`.

Add valt as a dependency in your `pubspec.yaml` file:
```
dependencies:
  valt: ^0.0.4+2
```

Import the `valt` library:

```
import 'package:valt/valt.dart';
```
Use the library's static methods to save and retrieve values from local storage:
```
// Storing a Map
final myMap = {'name': 'John', 'age': 30};
await Valt.setMap('myMapKey', myMap);

// Retrieving a Map
final retrievedMap = await Valt.getMap('myMapKey');
print(retrievedMap); // {'name': 'John', 'age': 30}

// Save a string value with key 'myKey' to local storage:
await Valt.setString('myKey', 'myValue');

// Retrieve the string value associated with key 'myKey' from local storage:
final myValue = await Valt.getString('myKey');
print(myValue); // Outputs 'myValue'

// Save a bool value with key 'myBool' to local storage:
await Valt.setBool('myBool', true);

// Retrieve the bool value associated with key 'myBool' from local storage:
final myBool = await Valt.getBool('myBool');
print(myBool); // Outputs 'true'

// Save a double value with key 'myDouble' to local storage:
await Valt.setDouble('myDouble', 3.14159);

// Retrieve the double value associated with key 'myDouble' from local storage:
final myDouble = await Valt.getDouble('myDouble');
print(myDouble); // Outputs '3.14159'

// Save a list of dynamic values with key 'myList' to local storage:
await Valt.setList('myList', [1, 'two', true]);

// Retrieve the list of dynamic values associated with key 'myList' from local storage:
final myList = await Valt.getList('myList');
print(myList); // Outputs '[1, "two", true]'
```

## To store and retrieve any type of value data type, you can use the following generic `set` and `get` functions:

```
await Valt.set('my_int', 42);
final myInt = await Valt.get('my_int');

await Valt.set('my_string', 'hello world');
final myString = await Valt.get('my_string');

await Valt.set('my_bool', true);
final myBool = await Valt.get('my_bool');

await Valt.set('my_double', 3.14159);
final myDouble = await Valt.get('my_double');

await Valt.set('my_list', [1, 2, 3, 4]);
final myList = await Valt.get('my_list');

await Valt.set('my_map', {'name': 'Alice', 'age': 25});
final myMap = await Valt.get('my_map');

```
## Store and Retrieve Multiple Values at Once Using `setMultiValues` and `getMultiValues`
```
// Set multiple key-value pairs
await setMultiValues({
  'name': 'Alice',
  'age': 30,
  'isStudent': false,
});

// Get the values of multiple keys
Map<String, dynamic> values = await getMultiValues(['name', 'age', 'isStudent']);

// Print the values
print(values['name']); // Output: Alice
print(values['age']); // Output: 30
print(values['isStudent']); // Output: false
```

```
Note that all values are saved to local storage as encrypted strings. If an operation fails, the corresponding method will return null or false, depending on the method.
```

## Contributing 
If you would like to contribute to Valt, please open an issue or pull request on GitHub.

## MIT License
```
Copyright (c) 2023 Mufassal Hussain

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
