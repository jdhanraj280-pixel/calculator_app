import 'package:flutter/material.dart';
import 'logic.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorLogic logic = CalculatorLogic();

  final List<List<String>> buttons = [
    ['AC', '⌫', '+/-', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['%', '0', '.', '='],
  ];

  void onButtonPressed(String text) {
    setState(() {
      if (text == 'AC') {
        logic.clear();
      } else if (text == '⌫') {
        logic.delete();
      } else if (text == '+/-') {
        logic.toggleSign();
      } else if (text == '=') {
        logic.evaluate();
      } else {
        logic.addInput(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFF1C1C1E);
    const operatorColor = Color(0xFF2D2D5C);
    const equalColor = Color(0xFF4B5EFC);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      logic.userInput,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      logic.result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons Grid
            for (var row in buttons)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row.map((btnText) {
                    final isOperator = [
                      '÷',
                      '×',
                      '-',
                      '+',
                      '%',
                    ].contains(btnText);
                    final isEqual = btnText == '=';
                    final color = isEqual
                        ? equalColor
                        : (isOperator ||
                              btnText == 'AC' ||
                              btnText == '⌫' ||
                              btnText == '+/-')
                        ? operatorColor
                        : buttonColor;

                    return _CalcButton(
                      text: btnText,
                      color: color,
                      onPressed: () => onButtonPressed(btnText),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _CalcButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _CalcButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
