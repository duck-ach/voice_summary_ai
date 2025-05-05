import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final _apiKey = dotenv.env['OPENAI_API_KEY'];

  Future<String> summarizeText(String input) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "너는 사용자의 대화를 간결하게 요약하는 도우미야.",
          },
          {"role": "user", "content": "다음 문장을 요약해줘:\n$input"}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      var summaryData = data['choices'][0]['message']['content'].trim();
      print('요약내용 : $summaryData');

      return summaryData;
    } else {
      print("Error: ${response.body}");

      return '요약 실패';
    }
  }
}
