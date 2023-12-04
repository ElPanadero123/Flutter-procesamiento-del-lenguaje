import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:natural_languaje_processing_mobile/api/question_client.dart';
import 'package:natural_languaje_processing_mobile/helpers/navigate.dart';
import 'package:natural_languaje_processing_mobile/models/question.dart';
import 'package:natural_languaje_processing_mobile/models/user.dart';
import 'package:natural_languaje_processing_mobile/screens/Questions/QuestionsScreen.dart';
import 'package:natural_languaje_processing_mobile/screens/UserData/Datauser.dart';
import 'package:natural_languaje_processing_mobile/screens/home/widgets/load.dart';
import 'package:natural_languaje_processing_mobile/screens/login/login.dart';
import 'package:voice_to_text/voice_to_text.dart';

class Home extends StatefulWidget {
  final UserNLP user;
  const Home({required this.user, super.key});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final VoiceToText _speech = VoiceToText();
  List<Widget> chat = [];
  TextEditingController questionController = TextEditingController();
  TextStyle styles = const TextStyle(fontSize: 15);
  @override
  void initState() {
    super.initState();
    _speech.initSpeech();
    _speech.addListener(() {
      setState(() {
        questionController.text = _speech.speechResult;
      });
    });
  }

  Widget newQuestion(String questionInput) {
    if (questionInput.isEmpty) return const SizedBox();
    Widget item = Card(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            questionInput,
            style: styles,
          ),
        ));
    Widget content = Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: item,
        ),
        const SizedBox(height: 10),
      ],
    );
    return content;
  }

  Widget newResponse(String result) {
    Widget loading = const Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
            width: 50,
            height: 50,
            child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Load(type: 3),
                ))));
    if (result.isEmpty) return loading;
    Widget response = Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(result, style: styles),
        ));
    Widget content = Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: response,
        ),
        const SizedBox(height: 10),
      ],
    );
    return content;
  }

  void handleButton() {
    if (questionController.text.isNotEmpty) {
      sendQuestion();
    } else {
      _speech.isNotListening ? _speech.startListening() : _speech.stop();
    }
  }

  void sendQuestion() async {
    chat.add(newQuestion(questionController.text));
    chat.add(newResponse(""));
    setState(() {});
    getAnswer();
  }

  void getAnswer() async {
    QuestionClient clinet = QuestionClient();
    final data = await clinet.sendQuestion(questionController.text);
    Question questionAnswer = Question.fromJSON(data);
    chat.removeLast();
    chat.add(newResponse(questionAnswer.result));
    questionController.text = "";
    setState(() {});
  }

  void clearChat() {
    setState(() {
      chat.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child:
                    Text("Welcome ${widget.user.name} ${widget.user.lastName}"),
              ),
            ),
            IconButton(
              onPressed: () async {
                navigate(
                  context: context,
                  screen: const Login(),
                  method: MethodNavigate.replace,
                );
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_outlined),
              alignment: Alignment.centerRight,
              color: const Color(0xFFA7A9AC), // Color secundario
            ),
            IconButton(
              onPressed: () {
                // Navegar a la pantalla de ayuda (QuestionsScreen)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionsScreen(user: widget.user),
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              alignment: Alignment.centerRight,
              color: const Color(0xFFA7A9AC), // Color secundario
            ),
            IconButton(
              onPressed: () {
                // Navegar a la pantalla de datos de usuario (DataUser)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataUser(user: widget.user),
                  ),
                );
              },
              icon: const Icon(Icons.person),
              alignment: Alignment.centerRight,
              color: const Color(0xFFA7A9AC), // Color secundario
            ),
          ],
        ),
        backgroundColor: const Color(0xFF9E0044), // Color principal
      ),
      body: Container(
        color: Colors.blueGrey[800],
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  if (chat.isEmpty) return const SizedBox();
                  return chat[index];
                },
              ),
            )),
            Align(
                alignment: Alignment.centerLeft,
                child: Card(
                  margin: EdgeInsets.all(5),
                  color: const Color(0xFF9e0044),
                  child: TextButton(
                      onPressed: clearChat,
                      child: const Text(
                        "Limpiar chat",
                        style: TextStyle(color: Colors.white),
                      )),
                )),
            Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.only(
                    right: 5, left: 15, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                          child: TextField(
                        maxLines: null,
                        onChanged: (value) => setState(() {}),
                        controller: questionController,
                        decoration: InputDecoration(
                            hintText: "Ingrese su pregunta",
                            labelStyle: const TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFF9e0044), width: 1.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10)),
                      )),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextButton(
                          onPressed: handleButton,
                          child: Container(
                              child: questionController.text.isNotEmpty
                                  ? const Icon(Icons.send,color: Color(0xFF9e0044),)
                                  : _speech.isNotListening
                                      ? const Icon(
                                          Icons.mic_off,
                                          color: Color(0xFF9e0044),
                                        )
                                      : const Load(
                                          type: 2,
                                        ))),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
