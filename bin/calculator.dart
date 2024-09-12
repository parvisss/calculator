void main() {
  String example = "9+12-2*(34-2/1*4+2-(2*6/12+4))";
  double result = solveMathExpression(example);
  print("Natija: $result");
}

double solveMathExpression(String expression) {
  expression = expression.replaceAll(' ', ''); 

  return _parseExpression(expression);
}

double _parseExpression(String expression) {
  List<double> values = [];
  List<String> operators = [];
  int index = 0;

  while (index < expression.length) {
    if (_isDigit(expression[index])) {
      double value = 0;
      while (index < expression.length && _isDigit(expression[index])) {
        value = value * 10 + (expression[index].codeUnitAt(0) - '0'.codeUnitAt(0));
        index++;
      }
      values.add(value);
    } else if (expression[index] == '(') {
      int parenCount = 1;
      int start = index + 1;
      while (parenCount > 0) {
        index++;
        if (expression[index] == '(') parenCount++;
        if (expression[index] == ')') parenCount--;
      }
      values.add(_parseExpression(expression.substring(start, index)));
      index++;
    } else if (_isOperator(expression[index])) {
      while (operators.isNotEmpty && _precedence(operators.last) >= _precedence(expression[index])) {
        _evaluateTop(values, operators);
      }
      operators.add(expression[index]);
      index++;
    } else if (expression[index] == ')') {
      break;
    } else {
      index++;
    }
  }

  while (operators.isNotEmpty) {
    _evaluateTop(values, operators);
  }

  return values.first;
}

bool _isDigit(String ch) {
  return ch.codeUnitAt(0) >= '0'.codeUnitAt(0) && ch.codeUnitAt(0) <= '9'.codeUnitAt(0);
}

bool _isOperator(String ch) {
  return ch == '+' || ch == '-' || ch == '*' || ch == '/';
}

int _precedence(String op) {
  if (op == '+' || op == '-') {
    return 1;
  } else if (op == '*' || op == '/') {
    return 2;
  }
  return 0;
}

void _evaluateTop(List<double> values, List<String> operators) {
  double b = values.removeLast();
  double a = values.removeLast();
  String op = operators.removeLast();
  
  if (op == '+') {
    values.add(a + b);
  } else if (op == '-') {
    values.add(a - b);
  } else if (op == '*') {
    values.add(a * b);
  } else if (op == '/') {
    values.add(a / b);
  }
}
