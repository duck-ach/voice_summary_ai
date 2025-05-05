import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../api/openai_service.dart';

class VoiceSummaryScreen extends StatefulWidget {
  const VoiceSummaryScreen({super.key});

  @override
  _VoiceSummaryScreenState createState() => _VoiceSummaryScreenState();
}

class _VoiceSummaryScreenState extends State<VoiceSummaryScreen> {
  final SpeechToText _speech = SpeechToText();
  String _recognizedText = '';
  String _summary = '';

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      // 모든 지원되는 locale 목록 가져오기
      var locales = await _speech.locales();
      // debug
      for (var locale in locales) {
        print('✅ ${locale.name} (${locale.localeId})');
      }

      // "ko_KR" locale 찾기
      var selectedLocale = locales.firstWhere(
        (locale) => locale.localeId == 'ko-KR',
        orElse: () => locales.first, // 없을 경우 첫 번째 locale 사용
      );

      // 듣기 시작
      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        },
        localeId: selectedLocale.localeId,
      );
    }
  }

  void _stopListening() {
    _speech.stop();
  }

  void _summarize() async {
    if (_recognizedText.isEmpty) return;
    final summary = await OpenAIService().summarizeText(_recognizedText);
    setState(() {
      _summary = summary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.mic),
            label: Text('음성 시작'),
            onPressed: _startListening,
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: Icon(Icons.stop),
            label: Text('중지'),
            onPressed: _stopListening,
          ),
          SizedBox(height: 20),
          Text('🎤 인식된 텍스트:\n$_recognizedText'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _summarize,
            child: Text('요약하기'),
          ),
          SizedBox(height: 20),
          Text('📝 요약 결과:\n$_summary'),
        ],
      ),
    );
  }
}
