import 'package:flutter/material.dart';

void main() {
  runApp(const PurpleCalculatorApp());
}

// 🎨 پالت رنگ بنفش مرکزی
class PurpleTheme {
  static const Color bgDark = Color(0xFF1A0B2E);
  static const Color calcBg = Color(0xFF2D1B4E);
  static const Color displayBg = Color(0xFF1F1038);
  static const Color btnBg = Color(0xFF4A2C7A);
  static const Color btnHover = Color(0xFF6B3FA0);
  static const Color operator = Color(0xFF9D4EDD);
  static const Color operatorHover = Color(0xFFB96FF5);
  static const Color equals = Color(0xFFC77DFF);
  static const Color text = Color(0xFFE0D4F5);
  static const Color history = Color(0xFFA08EC7);
}

class PurpleCalculatorApp extends StatelessWidget {
  const PurpleCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ماشین‌حساب بنفش',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: PurpleTheme.bgDark,
        fontFamily: 'Vazirmatn',
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _currentInput = '0';
  double? _previousValue;
  String? _operator;
  bool _shouldReset = false;

  String get _historyText {
    if (_previousValue == null || _operator == null) return '';
    final sym = {'+': '+', '-': '−', '*': '×', '/': '÷'}[_operator];
    final prev = _previousValue! % 1 == 0
        ? _previousValue!.toInt().toString()
        : _previousValue.toString();
    return '$prev $sym';
  }

  void _appendNumber(String num) {
    setState(() {
      if (_shouldReset) {
        _currentInput = '';
        _shouldReset = false;
      }
      _currentInput = (_currentInput == '0') ? num : _currentInput + num;
    });
  }

  void _appendDecimal() {
    setState(() {
      if (_shouldReset) {
        _currentInput = '0';
        _shouldReset = false;
      }
      if (!_currentInput.contains('.')) {
        _currentInput += '.';
      }
    });
  }

  void _handleOperator(String op) {
    setState(() {
      if (_operator != null && !_shouldReset) {
        _calculate();
      }
      _previousValue = double.tryParse(_currentInput) ?? 0;
      _operator = op;
      _shouldReset = true;
    });
  }

  void _calculate() {
    if (_operator == null || _previousValue == null) return;

    final current = double.tryParse(_currentInput) ?? 0;
    double result;

    switch (_operator) {
      case '+':
        result = _previousValue! + current;
        break;
      case '-':
        result = _previousValue! - current;
        break;
      case '*':
        result = _previousValue! * current;
        break;
      case '/':
        if (current == 0) {
          setState(() {
            _currentInput = 'Error';
            _previousValue = null;
            _operator = null;
            _shouldReset = true;
          });
          return;
        }
        result = _previousValue! / current;
        break;
      default:
        return;
    }

    final rounded = double.parse(result.toStringAsFixed(10));
    setState(() {
      _currentInput = rounded % 1 == 0
          ? rounded.toInt().toString()
          : rounded.toString();
      _previousValue = null;
      _operator = null;
      _shouldReset = true;
    });
  }

  void _handlePercent() {
    final val = double.tryParse(_currentInput) ?? 0;
    setState(() {
      _currentInput = (val / 100).toString();
    });
  }

  void _handleDelete() {
    setState(() {
      if (_currentInput == 'Error' || _currentInput.length == 1) {
        _currentInput = '0';
      } else {
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      }
    });
  }

  void _handleClear() {
    setState(() {
      _currentInput = '0';
      _previousValue = null;
      _operator = null;
      _shouldReset = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: PurpleTheme.calcBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: PurpleTheme.operator.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: PurpleTheme.operator.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
                const BoxShadow(
                  color: Colors.black45,
                  blurRadius: 40,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDisplay(),
                const SizedBox(height: 20),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PurpleTheme.displayBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PurpleTheme.operator.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 20,
            child: Text(
              _historyText,
              style: const TextStyle(
                color: PurpleTheme.history,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              _currentInput,
              style: const TextStyle(
                color: PurpleTheme.text,
                fontSize: 36,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        _row([
          _btn('AC', _handleClear, style: BtnStyle.function),
          _btn('DEL', _handleDelete, style: BtnStyle.function),
          _btn('%', _handlePercent, style: BtnStyle.function),
          _btn('÷', () => _handleOperator('/'), style: BtnStyle.operator),
        ]),
        const SizedBox(height: 12),
        _row([
          _btn('7', () => _appendNumber('7')),
          _btn('8', () => _appendNumber('8')),
          _btn('9', () => _appendNumber('9')),
          _btn('×', () => _handleOperator('*'), style: BtnStyle.operator),
        ]),
        const SizedBox(height: 12),
        _row([
          _btn('4', () => _appendNumber('4')),
          _btn('5', () => _appendNumber('5')),
          _btn('6', () => _appendNumber('6')),
          _btn('−', () => _handleOperator('-'), style: BtnStyle.operator),
        ]),
        const SizedBox(height: 12),
        _row([
          _btn('1', () => _appendNumber('1')),
          _btn('2', () => _appendNumber('2')),
          _btn('3', () => _appendNumber('3')),
          _btn('+', () => _handleOperator('+'), style: BtnStyle.operator),
        ]),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _btn('0', () => _appendNumber('0')),
            ),
            const SizedBox(width: 12),
            Expanded(child: _btn('.', _appendDecimal)),
            const SizedBox(width: 12),
            Expanded(child: _btn('=', _calculate, style: BtnStyle.equals)),
          ],
        ),
      ],
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      children: children
          .map((w) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: w,
                ),
              ))
          .toList(),
    );
  }

  Widget _btn(
    String label,
    VoidCallback onTap, {
    BtnStyle style = BtnStyle.normal,
  }) {
    Color bg;
    Color fg = PurpleTheme.text;
    double fontSize = 20;

    switch (style) {
      case BtnStyle.operator:
        bg = PurpleTheme.operator;
        fg = Colors.white;
        break;
      case BtnStyle.equals:
        bg = PurpleTheme.equals;
        fg = PurpleTheme.bgDark;
        break;
      case BtnStyle.function:
        bg = const Color(0xFF3A2263);
        fg = PurpleTheme.history;
        fontSize = 16;
        break;
      case BtnStyle.normal:
        bg = PurpleTheme.btnBg;
        break;
    }

    return AspectRatio(
      aspectRatio: 1.4,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

enum BtnStyle { normal, operator, equals, function }
