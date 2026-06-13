import 'package:flutter/material.dart';
import 'ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarketWatch AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final AIService _aiService = AIService();
  String _status = 'Initializing...';
  String _result = '';

  @override
  void initState() {
    super.initState();
    _runTest();
  }

  Future<void> _runTest() async {
    setState(() {
      _status = 'Loading model...';
    });
    
    await _aiService.loadModel();
    
    if (_aiService.isLoaded) {
      String testText = "The product is great!";
      double score = _aiService.predict(testText);
      
      setState(() {
        _status = 'Model loaded successfully.';
        _result = 'Input: "$testText"\nSentiment Score: $score';
      });
    } else {
      setState(() {
        _status = 'Error: Model failed to load. Check logs.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MarketWatch AI Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _status,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _result,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
