The valt library provides a simple way to save and retrieve values from local storage using AES encryption in a Flutter app. Here's how you can use this library:

Add valt as a dependency in your pubspec.yaml file:
```
dependencies:
  valt: ^0.0.1+1
```

Import the valt library:

```
import 'package:valt/valt.dart';
```
Use the library's static methods to save and retrieve values from local storage:
```
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
