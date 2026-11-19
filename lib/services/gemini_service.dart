
import 'package:firebase_ai/firebase_ai.dart';

import '../data/models/bitcoin_price.dart';

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
      throw Exception('Erro ao consultar Gemini: $e');
    }
  }

  Future<String> analyzeBitcoin({
    required BitcoinPrice bitcoin,
    String? question,
  }) async {
    final currency = bitcoin.currency == MarketCurrency.usd
        ? 'USD'
        : 'BRL';

    final prompt = '''
Você é um analista educacional de criptomoedas.

Analise os dados fornecidos pela API da Binance.

DADOS DO MERCADO:
Ativo: Bitcoin
Moeda: $currency
Preço atual: ${bitcoin.price.toStringAsFixed(2)}
Variação nas últimas 24 horas:
${bitcoin.changePercent24h.toStringAsFixed(2)}%
Data da cotação: ${bitcoin.timestamp.toIso8601String()}

INSTRUÇÕES:
1. Explique a situação atual do Bitcoin.
2. Interprete a variação percentual.
3. Explique o que os dados sugerem sobre
   o movimento recente do preço.
4. Destaque os riscos e limitações da análise.
5. Não invente indicadores, notícias ou volume.
6. Não recomende diretamente comprar ou vender.
7. Responda em português brasileiro.
8. Use uma linguagem clara e objetiva.

${question == null || question.trim().isEmpty
    ? 'Produza uma análise completa com até 200 palavras.'
    : 'Responda à pergunta: $question'}
''';

    return generateAnalysis(prompt: prompt);
  }
}
