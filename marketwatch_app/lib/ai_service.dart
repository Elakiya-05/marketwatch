import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// A robust backend service for running sentiment analysis via a TFLite model.
class AIService {
  Interpreter? _interpreter;

  // Configuration for the model inputs.
  // These should match the sequence length used during training.
  static const int _maxSequenceLength = 128;
  
  bool get isLoaded => _interpreter != null;

  /// Loads the TFLite model from the assets directory.
  Future<void> loadModel() async {
    try {
      // Initialize the interpreter with the model from assets.
      // The path must match exactly what is declared in pubspec.yaml.
      _interpreter = await Interpreter.fromAsset('../assets/model.tflite');
      
      // Optionally configure interpreter options for production (e.g., multithreading)
      // var options = InterpreterOptions()..threads = 2;
      // _interpreter = await Interpreter.fromAsset('../assets/model.tflite', options: options);

      debugPrint('AIService: TFLite model loaded successfully.');
      
      // In a real debug scenario, logging input/output shapes is very helpful
      // debugPrint('Input Tensors: ${_interpreter?.getInputTensors()}');
      // debugPrint('Output Tensors: ${_interpreter?.getOutputTensors()}');
    } catch (e) {
      debugPrint('AIService: Error loading model — $e');
    }
  }

  /// Predicts sentiment for a given input string.
  /// Pre-processes the text, runs inference, and returns the sentiment score.
  double predict(String input) {
    if (_interpreter == null) {
      debugPrint('AIService: Interpreter not initialized. Call loadModel() first.');
      return 0.0;
    }

    try {
      // 1. Pre-process the input string into a tensor format.
      // The model typically expects a 2D tensor of shape [batch_size, sequence_length].
      // Here, batch_size is 1, so the shape will be [1, _maxSequenceLength].
      List<double> inputData = _preprocess(input);
      var inputTensor = [inputData]; 

      // 2. Prepare the output tensor.
      // Assuming the model outputs a single probability or sentiment score, the shape is [1, 1].
      var outputTensor = [[0.0]];

      // 3. Run inference.
      _interpreter!.run(inputTensor, outputTensor);

      // 4. Return the resulting score.
      return outputTensor[0][0];
    } catch (e) {
      debugPrint('AIService: Inference error — $e');
      return 0.0;
    }
  }

  /// Template logic for text-to-numbers pre-processing (Tokenization & Padding).
  /// In a production environment, you must use a vocabulary mapping (dictionary)
  /// matching the exact one used to train your TFLite model.
  List<double> _preprocess(String text) {
    // 1. Basic Tokenization (e.g., lowercase, remove punctuation, split by space).
    List<String> tokens = text.toLowerCase().split(RegExp(r'\W+'));
    
    // 2. Map tokens to integer IDs based on your model's vocabulary.
    // Placeholder dictionary representation:
    // final Map<String, double> vocab = {"bad": 1.0, "good": 2.0, "market": 3.0, ...};
    
    List<double> sequence = [];
    for (String token in tokens) {
      if (token.isEmpty) continue;
      
      // In production, map the actual token string to its dictionary index.
      // e.g., sequence.add(vocab[token] ?? 0.0); // 0.0 = <UNK> token
      
      // Temporary stub: Using string length to mock token ID assignments
      sequence.add(token.length.toDouble()); 
    }

    // 3. Pad or truncate the sequence to precisely match _maxSequenceLength.
    if (sequence.length > _maxSequenceLength) {
      // Truncate if too long.
      sequence = sequence.sublist(0, _maxSequenceLength);
    } else if (sequence.length < _maxSequenceLength) {
      // Pad with zeros if too short.
      int paddingCount = _maxSequenceLength - sequence.length;
      sequence.addAll(List.filled(paddingCount, 0.0)); // 0.0 = <PAD> token
    }

    return sequence;
  }

  /// Disposes of the native resources used by the interpreter.
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    debugPrint('AIService: Model resources disposed.');
  }
}
