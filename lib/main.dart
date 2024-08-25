import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for clipboard handling

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  int _numberOfFields = 1; // Start with one field
  int _selectedWindow = 1; // 1, 2, or 3

  String _output1 = "0";
  String _output2 = "0";
  String _output3 = "0";

  String _result1 = "0";
  String _result2 = "0";
  String _result3 = "0";

  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;

  void buttonPressed(String buttonText) {
    String _currentOutput;

    if (_selectedWindow == 1) {
      _currentOutput = _output1;
    } else if (_selectedWindow == 2) {
      _currentOutput = _output2;
    } else {
      _currentOutput = _output3;
    }

    if (buttonText == "C") {
      _output1 = "0";
      _output2 = "0";
      _output3 = "0";
      _result1 = "0";
      _result2 = "0";
      _result3 = "0";
      _num1 = 0;
      _num2 = 0;
      _operation = "";
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "*" ||
        buttonText == "/") {
      _num1 = double.parse(_currentOutput);
      _operation = buttonText;
      _currentOutput = "0";
    } else if (buttonText == ".") {
      if (_currentOutput.contains(".")) {
        return;
      } else {
        _currentOutput = _currentOutput + buttonText;
      }
    } else if (buttonText == "=") {
      _num2 = double.parse(_currentOutput);

      if (_operation == "+") {
        _currentOutput = (_num1 + _num2).toString();
      } else if (_operation == "-") {
        _currentOutput = (_num1 - _num2).toString();
      } else if (_operation == "*") {
        _currentOutput = (_num1 * _num2).toString();
      } else if (_operation == "/") {
        _currentOutput = (_num1 / _num2).toString();
      }

      _operation = "";
    } else {
      _currentOutput = _currentOutput + buttonText;
    }

    setState(() {
      if (_selectedWindow == 1) {
        _output1 = _currentOutput;
        _result1 = double.parse(_output1).toStringAsFixed(2);
      } else if (_selectedWindow == 2) {
        _output2 = _currentOutput;
        _result2 = double.parse(_output2).toStringAsFixed(2);
      } else {
        _output3 = _currentOutput;
        _result3 = double.parse(_output3).toStringAsFixed(2);
      }
    });
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Container(
        height: 70,
        width: 71,// Set the desired height
        padding: const EdgeInsets.symmetric(vertical: 6 , horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0), // Set the desired border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30), // Shadow color
              spreadRadius: 0, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 6), // Offset in the X and Y direction
            ),
          ],
        ),// Adjust the padding around the button
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Set the desired border radius
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Adjust the padding inside the button
            ),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20, color: Color(0xFFffffff)),
          ),
        ),
      ),
    );
  }


  Widget buildResultWindow(String result, int windowNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18), // Add padding around the container
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedWindow = windowNumber; // Update the selected window
          });
        },
        onLongPress: () {
          _copyToClipboard(result); // Copy result to clipboard on long press
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A1926),
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 6, // Blur radius
                offset: Offset(0, 4), // Offset in the Y direction to make shadow appear below
              ),
            ],
            border: _selectedWindow == windowNumber ? Border.all(
              color: Color(0xFF563887), // Border color
              width: 2.0, // Border width
            ) : Border.all(
              color: Color(0xFF1A1926), // Border color
              width: 2.0, // Border width
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Align children vertically
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align all children to the left
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min, // Make the row as small as possible
                      children: [
                        InkWell(
                          onTap: () => _pasteFromClipboard(windowNumber),
                          child: Icon(Icons.paste, size: 17,),
                        ),
                        SizedBox(width: 8), // Add space between icons
                        InkWell(
                          onTap: () => _copyToClipboard(result),
                          child: Icon(Icons.copy, size: 17),
                        ),
                      ],
                    ),
                    if (_numberOfFields > 1)
                      SizedBox(height: 20),
                    if (_numberOfFields > 1)// Space between icons and close button
                    Align(
                      alignment: Alignment.centerLeft, // Align close button to the left
                      child: InkWell(
                        onTap: () => removeField(windowNumber),
                        child: Icon(Icons.close, size: 17),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Expanded(
                  // Make the text take the remaining space
                  child: Container(
                    alignment: Alignment.bottomRight, // Align container's content to bottom right
                    child: Baseline(
                      baseline: 50.0, // Adjust the baseline value as needed
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        result,
                        style: TextStyle(
                          fontSize: 35,
                        ),
                        textAlign: TextAlign.right, // Align text to the right
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void addField() {
    if (_numberOfFields < 3) {
      setState(() {
        _numberOfFields += 1;
      });
    }
  }

  void removeField(int windowNumber) {
    setState(() {
      if (windowNumber == 1) {
        _output1 = _output2;
        _result1 = _result2;
        _output2 = _output3;
        _result2 = _result3;
        _output3 = "0";
        _result3 = "0";
      } else if (windowNumber == 2) {
        _output2 = _output3;
        _result2 = _result3;
        _output3 = "0";
        _result3 = "0";
      }
      _numberOfFields -= 1;
      _selectedWindow = 1; // Reset selected window to the first one
    });
  }

  // Method to copy text to the clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard")),
    );
  }

  // Method to paste text from the clipboard into a specific result window
  void _pasteFromClipboard(int windowNumber) async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null) {
      String clipboardText = clipboardData.text ?? "0";

      // Validate if the clipboard text is a valid double
      try {
        double parsedValue = double.parse(clipboardText);

        setState(() {
          if (windowNumber == 1) {
            _output1 = parsedValue.toString();
            _result1 = parsedValue.toStringAsFixed(2);
          } else if (windowNumber == 2) {
            _output2 = parsedValue.toString();
            _result2 = parsedValue.toStringAsFixed(2);
          } else {
            _output3 = parsedValue.toString();
            _result3 = parsedValue.toStringAsFixed(2);
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid number format in clipboard")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check if in landscape mode
          bool isLandscape = constraints.maxWidth > 600;

          return isLandscape
              ? Row(
                  children: [
                    // Left side: Result windows and add button
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          if (_numberOfFields >= 1)
                            buildResultWindow(_result1, 1),
                          if (_numberOfFields >= 2)
                            buildResultWindow(_result2, 2),
                          if (_numberOfFields >= 3)
                            buildResultWindow(_result3, 3),
                          if (_numberOfFields < 3)
                            ElevatedButton(
                              onPressed: addField,
                              child: Text("Add Field"),
                            ),
                        ],
                      ),
                    ),
                    // Right side: Calculator buttons
                    Expanded(
                      flex: 1,
                      child: Column(
                        /*children: [
                          Row(
                            children: <Widget>[
                              buildButton("7"),
                              buildButton("8"),
                              buildButton("9"),
                              buildButton("/")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildButton("4"),
                              buildButton("5"),
                              buildButton("6"),
                              buildButton("*")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildButton("1"),
                              buildButton("2"),
                              buildButton("3"),
                              buildButton("-")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildButton("."),
                              buildButton("0"),
                              buildButton("00"),
                              buildButton("+")
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildButton("C"),
                              buildButton("="),
                            ],
                          ),
                        ],*/
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Spacer(),
                    if (_numberOfFields < 3)
                      Row(
                          children: [
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18), // Adjust margin around the button
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF311F4F), // Set background color
                                  borderRadius: BorderRadius.circular(10.0), // Change border radius
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3), // Shadow color with opacity
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 6, // Blur radius
                                      offset: Offset(2, 4), // Offset in the X and Y direction
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, // Make button background transparent to show container color
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0), // Adjust padding inside the button
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Change border radius
                                    ),
                                  ),
                                  onPressed: addField,
                                  child: Text(
                                    "+ Add",
                                    style: TextStyle(fontSize: 16, color: Colors.white), // Adjust font size
                                  ),
                                ),
                              ),
                            ),
                          ])
                    ,
                    if (_numberOfFields >= 1) buildResultWindow(_result1, 1),
                    if (_numberOfFields >= 2) buildResultWindow(_result2, 2),
                    if (_numberOfFields >= 3) buildResultWindow(_result3, 3),


                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB( 15,  10,  15, 45), // Adjust padding as needed
                      child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            buildButton("7", Color(0xFF2E2C43)),
                            buildButton("8", Color(0xFF2E2C43)),
                            buildButton("9", Color(0xFF2E2C43)),
                            buildButton("/", Color(0xFF311F4F))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            buildButton("4", Color(0xFF1C1A29)),
                            buildButton("5", Color(0xFF1C1A29)),
                            buildButton("6",Color(0xFF1C1A29)),
                            buildButton("*", Color(0xFF311F4F))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            buildButton("1", Color(0xFF1C1A29)),
                            buildButton("2", Color(0xFF1C1A29)),
                            buildButton("3", Color(0xFF1C1A29)),
                            buildButton("-", Color(0xFF311F4F))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            buildButton(".", Color(0xFF1C1A29)),
                            buildButton("0", Color(0xFF1C1A29)),
                            buildButton("00", Color(0xFF1C1A29)),
                            buildButton("+", Color(0xFF311F4F))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            buildButton("C", Color(0xFF1C1A29)),
                            buildButton("=", Color(0xFF1C1A29)),
                            buildButton("C", Color(0xFF1C1A29)),
                            buildButton("=", Color(0xFF311F4F)),
                          ],
                        ),
                      ],
                    ))
                  ],
                );
        },
      ),
    );
  }
}
