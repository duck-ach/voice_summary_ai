import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voice_summary_ai/widgets/recode_voice_button.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // 환경변수 로딩
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 요약 앱',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('AI 음성 요약')),
        body: VoiceSummaryScreen(),
      ),
    );
  }
}
