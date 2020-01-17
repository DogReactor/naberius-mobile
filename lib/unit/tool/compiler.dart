import 'dart:collection';

import 'package:characters/characters.dart';

const operatorPriority = {
  '!=': 1,
  "==": 1,
  ">": 1,
  "<": 1,
  ">=": 1,
  "<=": 1,
  "&&": 0,
  "||": 0,
  "!": 2,
};

eval(String expression, selectedClass, unit, skill) {
  if (expression == '') return 1;
  expression.replaceAll('\"', '"');
  var classID = selectedClass['ClassID'];
  // 要把这个type转成int的
  var classType = selectedClass['Type'];
  var functions = {
    'GetClassID': (args) {
      return classID;
    },
    'IsSkillID': (args) {
      var currentSkillID = skill['SkillID'];
      return args[0] == currentSkillID ? 1 : 0;
    }
  };

  // 将表达式转换为逆波兰式
  // 去掉所有空格
  expression = expression.replaceAll(' ', '');
  // 创建stack
  var stack = new ListQueue();
  var output = [];
  // 遍历expression
  var expressionC = Characters(expression);
  loopPop(f) {
    while (true) {
      if (stack.length == 0 || f(stack.last)) break;
      output.add({'operator': true, 'data': stack.removeLast()});
    }
  }

  treateOperator(String ope) {
    var priority = operatorPriority[ope];
    while (true) {
      if (stack.length == 0 ||
          stack.last == '(' ||
          priority > operatorPriority[stack.last]) {
        stack.add(ope);
        break;
      } else {
        output.add({'operator': true, 'data': stack.removeLast()});
      }
    }
  }

  // 主遍历体
  for (var i = 0; i < expressionC.length; i++) {
    var s = expressionC.elementAt(i);
    switch (s) {
      case ';':
        break;
      case '(':
        stack.add('(');
        break;
      case ')':
        loopPop((last) => last == '(');
        stack.removeLast();
        break;
      case '!':
        if (i == expressionC.length - 1) throw 'Wired';
        if (expressionC.elementAt(i + 1) == '=') {
          treateOperator('!=');
          i++;
        } else {
          treateOperator('!');
        }
        break;
      case '=':
        if (i == expressionC.length - 1) throw 'Wired';
        treateOperator('==');
        i++;
        break;
      case '&':
        if (i == expressionC.length - 1) throw 'Wired';
        treateOperator('&&');
        i++;
        break;
      case '|':
        if (i == expressionC.length - 1) throw 'Wired';
        treateOperator('||');
        i++;
        break;
      case '>':
      case '<':
        if (i == expressionC.length - 1) throw 'Wired';
        if (expressionC.elementAt(i + 1) == '=') {
          treateOperator(s + '=');
          i++;
        } else {
          treateOperator(s);
        }
        break;
      default:
        // 这里有两种情况，一种是数字，一种是字符
        isNum(code) {
          var zeroCode = '0'.runes.first;
          var nineCode = '9'.runes.first;
          return code >= zeroCode && code <= nineCode;
        }
        var firstCode = s.runes.first;
        if (isNum(firstCode)) {
          var numString = '';
          // 如果是数字
          while (true) {
            // 将当前字符压入
            numString += expressionC.elementAt(i);
            // 若下一个字符为非数字或者遍历结束时跳出
            if (i == expressionC.length - 1 ||
                !isNum(expression.runes.elementAt(i + 1))) {
              break;
            }
            // 否则下标+1
            i++;
          }
          var n = num.tryParse(numString);
          if (n == null) throw 'notNumber $numString';
          output.add({'operator': false, 'data': n});
        } else {
          var functionString = '';
          // 如果是非数字，那就是函数了
          while (true) {
            // 找到下一个')'
            var currentChar = expressionC.elementAt(i);
            if (currentChar == ')') break;
            functionString += currentChar;
            i++;
          }
          var functionA = functionString.split('(');
          var functionName = functionA[0];
          var functionArg = functionA[1].split(',');
          var f = functions[functionName];
          if (f == null) {
            print('new Function ' + functionName);
            output.add({'operator': false, 'data': 1});
          } else {
            var args = [];
            if (functionA[1].length != 0) {
              args = functionArg.map((e) {
                if (e.contains('\'') || e.contains('"')) {
                  e = e.replaceAll('\'', '');
                  e = e.replaceAll('"', '');
                  return e;
                } else {
                  var nume = num.tryParse(e);
                  if (nume == null) {
                    throw 'not Number ' + e;
                  }
                  return nume;
                }
              }).toList();
            }
            var result = f(args);
            output.add({'operator': false, 'data': result});
          }
        }
        break;
    }
  }
  // 把剩下的全部出栈
  while (stack.length > 0) {
    output.add({'operator': true, 'data': stack.removeLast()});
  }
  // output是后缀表达式
  var execStack = ListQueue();
  output.forEach((e) {
    if (e['operator'] == false) {
      execStack.add(e['data']);
    } else {
      var ope = e['data'];
      switch (ope) {
        case '!=':
          var right = execStack.removeLast();
          var left = execStack.removeLast();
          var result = left != right ? 1 : 0;
          execStack.add(result);
          break;
        case '==':
          var right = execStack.removeLast();
          var left = execStack.removeLast();
          var result = left == right ? 1 : 0;
          execStack.add(result);
          break;
        case '>':
          var right = execStack.removeLast();
          var left = execStack.removeLast();
          var result = left > right ? 1 : 0;
          execStack.add(result);
          break;
        case '<':
          var right = execStack.removeLast();
          var left = execStack.removeLast();
          var result = left < right ? 1 : 0;
          execStack.add(result);
          break;
        case '>=':
          var right = execStack.removeLast();
          var left = execStack.removeLast();
          var result = left >= right ? 1 : 0;
          execStack.add(result);
          break;
        case '<=':
          var right = execStack.removeLast();
          var left = execStack.removeLast();
          var result = left <= right ? 1 : 0;
          execStack.add(result);
          break;
        case '&&':
          var right = execStack.removeLast() >= 1 ? true : false;
          var left = execStack.removeLast() >= 1 ? true : false;
          var result = left & right ? 1 : 0;
          execStack.add(result);
          break;
        case '||':
          var right = execStack.removeLast() >= 1 ? true : false;
          var left = execStack.removeLast() >= 1 ? true : false;
          var result = left | right ? 1 : 0;
          execStack.add(result);
          break;
        case '!':
          var target = execStack.removeLast() >= 1 ? true : false;
          var result = !target ? 0 : 1;
          execStack.add(result);
          break;
      }
    }
  });
  print(expression);
  return execStack.removeLast();
}
