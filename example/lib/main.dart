import 'package:flutter/material.dart';
import 'package:valt/valt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Valt Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = 'value';
  final _defaultValue = 'Not Stored';
  String? _value;

  @override
  void initState() {
    super.initState();
    _getValue();
  }

  Future<void> _getValue() async {
    final value = await Valt.getString(_key);
    setState(() {
      _value = value ?? _defaultValue;
    });
  }

  Future<void> _setValue(String value) async {
    await Valt.setString(_key, value);
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valt Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stored Value:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              _value != null ? _value! : "",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _setValue('Hello, Flutter!'),
              child: const Text('Store Value'),
            ),
          ],
        ),
      ),
    );
  }
}
