import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _working=false;
  final _inputController=TextEditingController();
  String _outputText='';

  @override
  void dispose() {
    // TODO: implement dispose
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.80;
    double height = MediaQuery.of(context).size.height * 0.30;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: const Color(0xFFE77918),
        centerTitle: true,
        title: const Text("Summarize Text",style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const SizedBox(height: 10,),

          // Select Input Text Field
          TextField(
            maxLines: 4,
            controller: _inputController,
            decoration: const InputDecoration(
              hintText: "Write text to summarize",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10,),

          //Run Model Button
          Center(
            child: SizedBox(
              width: width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE77918)),
                onPressed: _working
                    ? null
                    : () async {
                  HapticFeedback.lightImpact();

                  if (_inputController.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Enter the text first.")));
                    return;
                  }

                  setState(() {
                    _outputText='';
                    _working = true;
                  });

                  // Main Condition of Text Summarization
                  var text = await fetchSummary(_inputController.text);

                  setState(() {
                    _outputText=text;
                    _working = false;
                  });
                },
                child: const Text("Summarize", style: TextStyle(color: Colors.white,fontSize: 14)),
              ),
            ),
          ),

          const SizedBox(height: 10,),

          //Display Output Text
          _outputText == ""
              ? const SizedBox()
              : Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2),
              ),
              child: SizedBox(
                width: width,
                height: height + 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: width,
                      height: 40,
                      child: Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.topRight,
                        color: const Color(0xFF283149),
                        child: IconButton(
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: _outputText!));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Text copied to clipboard')),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      height: height,
                      child: Container(
                          color: const Color(0XFFDBEDF3),
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.all(5.0),
                          child: SelectableText(
                            _outputText!,
                            showCursor: true,
                            style: const TextStyle(color: Color(0xFF283149)),
                          )),
                    ),
                  ],
                ),
              )),


        ],
      ),
    );
  }

  Future<String> fetchSummary(text) async {
    final url = Uri.parse(
        'https://api-inference.huggingface.co/models/ahmedmbutt/PTS-Bart-Large-CNN');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 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',
    };
    final body = jsonEncode({
      'inputs': text,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0]['summary_text'];
      debugPrint('Response data: $data');
      return data;
    } else {
      const data =
          "An error occurred: Unable to fetch summary. Please try again later.";
      debugPrint('Request failed with status: ${response.statusCode}');
      return data;
    }
  }

}
