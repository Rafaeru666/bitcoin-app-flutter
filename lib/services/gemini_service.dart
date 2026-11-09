import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  final GenerativeModel _model =
      FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.8-flash',
  );

  Future<String> generateAnalysis({
    required String prompt,
  }) async {
    try {
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);

      return response.text ??
          'O Gemini não retornou texto.';
    } catch (e) {
      print('ERRO GEMINI -> $e');

      return 'Erro Gemini: $e';
    }
  }
}