import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'ai_service.dart';

void main() async {
  // 1. Initialize Flutter bindings. 
  // This is strictly required to read assets via Interpreter.fromAsset() without a UI.
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('\n========== TFLITE BACKEND TEST ==========');
  
  AIService aiService = AIService();
  
  debugPrint('1. Initializing and loading model...');
  await aiService.loadModel();
  
  if (aiService.isLoaded) {
    String testText = "The product is great!";
    debugPrint('2. Running inference on text: "$testText"');
    
    // Call the prediction backend
    double score = aiService.predict(testText);
    
    debugPrint('\n--> OUTPUT SENTIMENT SCORE: $score\n');
  } else {
    debugPrint('\n--> ERROR: Model failed to load. Check logs.\n');
  }
  
  debugPrint('========== TEST COMPLETE ==========\n');
}
