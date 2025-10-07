class CalculatorLogic {
  String _userInput = '';
  String _result = '0';

  String get userInput => _userInput;
  String get result => _result;

  void addInput(String value) {
    _userInput += value;
  }

  void clear() {
    _userInput = '';
    _result = '0';
  }

  void delete() {
    if (_userInput.isNotEmpty) {
      _userInput = _userInput.substring(0, _userInput.length - 1);
    }
  }

  void toggleSign() {
    if (_userInput.isNotEmpty) {
      if (_userInput.startsWith('-')) {
        _userInput = _userInput.substring(1);
      } else {
        _userInput = '-$_userInput';
      }
    }
  }

  void evaluate() {
    try {
      String exp = _userInput.replaceAll('×', '*').replaceAll('÷', '/');
      _result = _calculate(exp);
    } catch (e) {
      _result = 'Error';
    }
  }

  String _calculate(String exp) {
    try {
      exp = exp.replaceAll(' ', '');

      while (exp.contains('(')) {
        final start = exp.lastIndexOf('(');
        final end = exp.indexOf(')', start);
        if (end == -1) break;
        final subExp = exp.substring(start + 1, end);
        final subResult = _calculate(subExp);
        exp = exp.replaceRange(start, end + 1, subResult.toString());
      }

      exp = _evaluateOps(exp, RegExp(r'(-?\d+\.?\d*)([*/])(-?\d+\.?\d*)'));
      exp = _evaluateOps(exp, RegExp(r'(-?\d+\.?\d*)([+-])(\d+\.?\d*)'));

      return exp;
    } catch (e) {
      return 'Error';
    }
  }

  String _evaluateOps(String exp, RegExp reg) {
    while (reg.hasMatch(exp)) {
      exp = exp.replaceFirstMapped(reg, (match) {
        final a = double.parse(match.group(1)!);
        final op = match.group(2)!;
        final b = double.parse(match.group(3)!);

        // ✅ Handle division by zero
        if (op == '/' && b == 0) {
          throw Exception('Division by zero');
        }

        final r = (op == '+')
            ? a + b
            : (op == '-')
            ? a - b
            : (op == '*')
            ? a * b
            : a / b;

        // Prevent showing Infinity or NaN
        if (r.isInfinite || r.isNaN) {
          throw Exception('Invalid operation');
        }

        return r.toString();
      });
    }
    return exp;
  }
}
