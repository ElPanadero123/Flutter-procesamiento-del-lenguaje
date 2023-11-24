import 'package:flutter/material.dart';
import 'package:voice_to_text/voice_to_text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  final VoiceToText _speech = VoiceToText();
  List<String> chat = [];
  String text =
      ""; //this is optional, I could get the text directly using speechResult
  @override
  void initState() {
    super.initState();
    _speech.initSpeech();
    _speech.addListener(() {
      setState(() {
        text = _speech.speechResult;
        text.isEmpty ? null : chat.add(text);
      });
    });
  }

  Widget newMessage(String questionInput) {
    if (questionInput.isEmpty) return const SizedBox();
    TextStyle styles =
        const TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis);
    Widget question = Card(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            questionInput,
            style: styles,
          ),
        ));
    Widget response = Card(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Text("El modelo respondio :D", style: styles),
    ));
    Widget content = Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: question,
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: response,
        ),
      ],
    );
    return Container(margin: const EdgeInsets.only(bottom: 10), child: content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Column(
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 600,
              color: Colors.blueAccent[100],
              child: Expanded(
                  child: ListView.builder(
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  if (chat.isEmpty) return const SizedBox();
                  return newMessage(chat[index]);
                },
              )),
            ),
            Text(
                _speech.isListening
                    ? "Listening...."
                    : 'Tap the microphone to start',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(_speech.isNotListening
                ? text.isNotEmpty
                    ? text
                    : "Try speaking again"
                : ""),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speech.isNotListening ? _speech.startListening : _speech.stop,
        tooltip: 'Listen',
        child: Icon(_speech.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
