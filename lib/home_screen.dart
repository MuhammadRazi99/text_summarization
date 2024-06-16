import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _working=false;
  String _inputText='';
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
        title: const Text("Summarize Text",style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),),
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
              hintText: "Ask a question",
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

                  if (_inputText == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Select the Image First")));
                    return;
                  }

                  setState(() {
                    _outputText='';
                    _working = true;
                  });

                  // Main Condition of Text Summarization

                  setState(() {
                    _working = false;
                  });
                },
                child: const Text("Run", style: TextStyle(color: Colors.white)),
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
}
