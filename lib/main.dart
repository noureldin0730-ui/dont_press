import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DontPressApp());
}

class DontPressApp extends StatelessWidget {
  const DontPressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DON'T PRESS",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
      ),
      home: const PressScreen(),
    );
  }
}

// ─── رسائل اللعبة ───────────────────────────────────────────────────────────

class Msg {
  final String text;
  final bool rare;
  const Msg(this.text, {this.rare = false});
}

const List<Msg> kMessages = [
  Msg('لا تضغط.'),
  Msg('قلت لك. لا تضغط.'),
  Msg('الزر يعرف أنك ستضغط.'),
  Msg('أنت لا تستمع.'),
  Msg('مرة أخرى... حسناً.'),
  Msg('هل تشعر بذلك؟'),
  Msg('شيء ما تحرّك.'),
  Msg('لم يكن هناك شيء قبل قليل.'),
  Msg('هل تسمع ذلك؟'),
  Msg('توقف. من فضلك.'),
  Msg('الزر يبتسم الآن.'),
  Msg('أنت لا ترى ما أراه.'),
  Msg('اقتربت أكثر.'),
  Msg('هناك شيء خلف الشاشة.'),
  Msg('لا تنظر خلفك.'),
  Msg('توقف عن الضغط.', rare: true),
  Msg('لقد فتحت شيئاً.', rare: true),
  Msg('أنت لست وحدك.', rare: true),
  Msg('SYSTEM: UNKNOWN ENTITY DETECTED', rare: true),
  Msg('ERROR: PRESS LIMIT EXCEEDED', rare: true),
  Msg('لقد كان بإمكانك التوقف.', rare: true),
  Msg('...', rare: true),
  Msg('هل تريد أن ترى؟', rare: true),
];

const List<String> kWhispers = [
  '...',
  'قريب.',
  'أنت.',
  'خلفك.',
  'اسمع.',
  'لا تنظر.',
  'توقف.',
  'الآن.',
];

// ─── الشاشة الرئيسية ────────────────────────────────────────────────────────

class PressScreen extends StatefulWidget {
  const PressScreen({super.key});

  @override
  State<PressScreen> createState() => _PressScreenState();
}

class _PressScreenState extends State<PressScreen>
    with TickerProviderStateMixin {
  int _pressCount = 0;
  String _currentMessage = '';
  bool _currentRare = false;
  bool _showWhisper = false;
  String _whisperText = '';
  bool _corrupted = false;
  double _buttonScale = 1.0;
  double _glow = 0.0;

  final Random _rng = Random();
  Timer? _whisperTimer;
  Timer? _glitchTimer;

  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseCtrl.addListener(() {
      if (mounted) setState(() => _glow = _pulseCtrl.value);
    });
  }

  @override
  void dispose() {
    _whisperTimer?.cancel();
    _glitchTimer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Color get _bgColor {
    if (_pressCount < 10) return const Color(0xFF050505);
    if (_pressCount < 25) return const Color(0xFF070303);
    if (_pressCount < 50) return const Color(0xFF0A0202);
    return const Color(0xFF0D0000);
  }

  Color get _buttonColor {
    if (_corrupted) return const Color(0xFF660000);
    return const Color(0xFF141414);
  }

  Color get _accentColor {
    if (_corrupted) return const Color(0xFFFF2222);
    if (_pressCount < 10) return const Color(0xFF6A6A6A);
    if (_pressCount < 30) return const Color(0xFFAA3333);
    return const Color(0xFFCC2222);
  }

  void _onPress() {
    HapticFeedback.mediumImpact();
    setState(() {
      _pressCount++;
      _currentRare = false;

      if (_pressCount < 5) {
        _currentMessage = kMessages[_pressCount % 5].text;
      } else {
        final m = kMessages[_rng.nextInt(kMessages.length)];
        _currentMessage = m.text;
        _currentRare = m.rare;
      }

      if (_pressCount == 10) {
        _currentMessage = 'هل تشعر بذلك؟';
      }
      if (_pressCount == 25) {
        _corrupted = true;
        _currentMessage = 'لقد كان بإمكانك التوقف.';
        HapticFeedback.heavyImpact();
      }
      if (_pressCount == 50) {
        _currentMessage = 'SYSTEM: UNKNOWN ENTITY DETECTED';
        HapticFeedback.vibrate();
        _triggerGlitch();
      }
      if (_pressCount == 100) {
        _currentMessage = 'لقد فتحت شيئاً.';
        _triggerGlitch();
      }
    });

    if (_pressCount > 50) {
      HapticFeedback.lightImpact();
    }

    if (_rng.nextDouble() < 0.18) {
      _triggerWhisper();
    }
  }

  void _triggerWhisper() {
    _whisperTimer?.cancel();
    setState(() {
      _whisperText = kWhispers[_rng.nextInt(kWhispers.length)];
      _showWhisper = true;
    });
    _whisperTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showWhisper = false);
    });
  }

  void _triggerGlitch() {
    _glitchTimer?.cancel();
    setState(() => _corrupted = true);
    _glitchTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _corrupted = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenShake = _corrupted ? (size.width * 0.004) : 0.0;
    final dx = (_rng.nextDouble() - 0.5) * screenShake;
    final dy = (_rng.nextDouble() - 0.5) * screenShake;

    return Scaffold(
      backgroundColor: _bgColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        transform: Matrix4.translationValues(dx, dy, 0),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 24,
                right: 24,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _currentMessage.isEmpty ? 0 : 1,
                  child: Text(
                    _currentMessage,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: _currentRare
                          ? const Color(0xFFFF4444)
                          : _accentColor,
                      fontSize: _currentRare ? 19 : 17,
                      letterSpacing: 0.5,
                      height: 1.7,
                      fontWeight: _currentRare
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),

              if (_showWhisper)
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _showWhisper ? 1 : 0,
                    child: Text(
                      _whisperText,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.28),
                        fontSize: 15,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),

              Center(
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _buttonScale = 0.94),
                  onTapUp: (_) => setState(() => _buttonScale = 1.0),
                  onTapCancel: () => setState(() => _buttonScale = 1.0),
                  onTap: _onPress,
                  child: AnimatedScale(
                    scale: _buttonScale,
                    duration: const Duration(milliseconds: 90),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _buttonColor,
                        border: Border.all(
                          color: _accentColor.withOpacity(0.6 + _glow * 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(
                              _corrupted ? 0.6 : 0.15 + _glow * 0.25,
                            ),
                            blurRadius: _corrupted ? 60 : 20 + _glow * 20,
                            spreadRadius: _corrupted ? 6 : 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _corrupted ? 'STOP' : 'PRESS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _accentColor,
                            fontSize: 28,
                            letterSpacing: 5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      "DON'T PRESS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 14,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_pressCount',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _accentColor.withOpacity(0.7),
                        fontSize: 13,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              if (_pressCount >= 100)
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Text(
                    'SECRET // PRESS_$_pressCount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.35),
                      fontSize: 10,
                      letterSpacing: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}