import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:snicker_bot/openai_service.dart';
import 'package:snicker_bot/pallete.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'feature_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  FlutterTts flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: Text('Snicker Bot'),
        ),
        leading: Icon(Icons.menu_rounded),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/virtualAssistant.png'),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Visibility(
                  visible: generatedImageUrl == null,
                  child: FadeInLeft(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Text(
                          generatedContent == null
                              ? 'Greetings! What can I do for you?'
                              : generatedContent!,
                          style: TextStyle(
                            color: Pallete.mainFontColor,
                            fontFamily: 'San Francisco',
                            fontSize: generatedContent == null ? 20 : 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(generatedImageUrl!),
                ),
              ),
            FadeIn(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: 10,
                    left: 37,
                  ),
                  child: Text(
                    'Here are some suggestions',
                    style: TextStyle(
                      fontFamily: 'San Francisco',
                      fontSize: 15,
                      color: Pallete.mainFontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(
                      milliseconds: start,
                    ),
                    child: FeatureBox(
                      headerText: 'Box 1',
                      descriptionText:
                          'Here goes the description of first suggestion box.',
                      color: Pallete.firstSuggestionBoxColor,
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(
                      milliseconds: start + delay,
                    ),
                    child: FeatureBox(
                      headerText: 'Box 2',
                      descriptionText:
                          'Here goes the description of second suggestion box.',
                      color: Pallete.secondSuggestionBoxColor,
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(
                      milliseconds: start + 2 * delay,
                    ),
                    child: FeatureBox(
                      headerText: 'Box 3',
                      descriptionText:
                          'Here goes the description of third suggestion box.',
                      color: Pallete.thirdSuggestionBoxColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            if (speech.contains('https')) {
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedImageUrl = null;
              generatedContent = speech;
              setState(() {});
              await systemSpeak(speech);
            }
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          speechToText.isListening ? Icons.stop : Icons.mic,
          size: 30,
        ),
      ),
    );
  }
}
