import 'package:test_project/core/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreen createState() => _CalculatorScreen();
}

class _CalculatorScreen extends State<CalculatorScreen> {
  String input = "";
  dynamic result = 0;
  String currentOperator = "";
  dynamic prevValue = 0;

  onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        input = "";
        result = 0;
        currentOperator = "";
        prevValue = 0;
      } else if (buttonText == "=") {
        if (currentOperator.isNotEmpty) {
          double inputValue = double.tryParse(input) ?? 0;
          switch (currentOperator) {
            case "+":
              int inputValue = int.tryParse(input) ?? 0;
              result = prevValue + inputValue;
              break;
            case "-":
              int inputValue = int.tryParse(input) ?? 0;
              result = prevValue - inputValue;
              break;
            case "*":
              int inputValue = int.tryParse(input) ?? 0;
              result = prevValue * inputValue;
              break;
            case "/":
              if (inputValue != 0) {
                double inputValue = double.tryParse(input) ?? 0;
                result = prevValue / inputValue;
              } else {
                result = double.infinity;
              }
              break;
          }
          input = result.toString();
          currentOperator = "";
          prevValue = result;
        }
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "*" ||
          buttonText == "/") {
        if (currentOperator.isEmpty) {
          prevValue = int.tryParse(input) ?? 0;
          currentOperator = buttonText;
          input = "";
        }
      } else {
        input += buttonText;
      }
    });
  }

  final List<String> buttonLabels = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    '*',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      currentOperator == ''
                          ? input
                          : '$prevValue$currentOperator$input',
                      style: TextStyle(fontSize: 32),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: buttonLabels.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                final buttonText = buttonLabels[index];
                return CalculatorButton(
                  text: buttonText,
                  callback: onButtonPressed,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final Function(String) callback;

  CalculatorButton({required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return RawButton(
      onPressed: () => callback(text),
      child: Text(
        text,
        style: TextStyle(
            color: text == 'C'
                ? Colors.red
                : text == '=' ||
                        text == '+' ||
                        text == '-' ||
                        text == '*' ||
                        text == '/'
                    ? Color.fromARGB(255, 114, 1, 44)
                    : Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
