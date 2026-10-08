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
      home: const GameRoot(),
    );
  }
}

// ─── الألوان ────────────────────────────────────────────────────────────────

class P {
  static const bg = Color(0xFF050505);
  static const dim = Color(0xFF6A6A6A);
  static const mid = Color(0xFFAA3333);
  static const rare = Color(0xFFFF4444);
  static const white = Color(0xFFE0E0E0);
}

// ─── نموذج المرحلة ──────────────────────────────────────────────────────────

class Stage {
  final int id;
  final String title;
  final String brief;
  final int maxAttempts;
  const Stage({
    required this.id,
    required this.title,
    required this.brief,
    required this.maxAttempts,
  });
}

const List<Stage> kStages = [
  Stage(id: 1, title: 'لا تضغط 20 مرة', brief: 'الزر بيتحرك. الحق اضغط 20 ضغطة في 10 ثواني.', maxAttempts: 3),
  Stage(id: 2, title: 'الزر الصح', brief: '3 أزرار. واحد بس هو الصح. الباقي بيعمل glitch.', maxAttempts: 3),
  Stage(id: 3, title: 'الصمت', brief: 'متضغطش خالص لمدة 5 ثواني. اللعبة هتحاول تستفزك.', maxAttempts: 2),
  Stage(id: 4, title: 'الترتيب', brief: '4 أزرار. احفظ الترتيب واضغطه صح.', maxAttempts: 3),
  Stage(id: 5, title: 'الكود السري', brief: '3 أرقام هتظهر لحظة. احفظهم وأدخلهم.', maxAttempts: 3),
  Stage(id: 6, title: 'لا تنظر', brief: 'الشاشة هتعتم. اضغط من غير ما تشوف.', maxAttempts: 3),
  Stage(id: 7, title: 'المتحرك', brief: '5 أزرار. واحد بس بيتحرك. اضغطه.', maxAttempts: 3),
  Stage(id: 8, title: 'العد التنازلي', brief: 'اضغط قبل ما الوقت يخلص.', maxAttempts: 3),
  Stage(id: 9, title: 'الاختيار', brief: 'سؤالين. واحد بيكمل، واحد بينهي.', maxAttempts: 1),
  Stage(id: 10, title: 'الحقيقة', brief: 'الزر الأخير. اضغطه لو تجرؤ.', maxAttempts: 1),
];

// ─── زر دائري موحّد ─────────────────────────────────────────────────────────

Widget _roundButton(
  String label, {
  required VoidCallback onTap,
  double size = 120,
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF141414),
        border: Border.all(color: color ?? P.mid, width: 2),
        boxShadow: [
          BoxShadow(
            color: (color ?? P.mid).withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color ?? P.mid,
          fontSize: size * 0.16,
          letterSpacing: 3,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

// ─── الجذر ──────────────────────────────────────────────────────────────────

class GameRoot extends StatefulWidget {
  const GameRoot({super.key});
  @override
  State<GameRoot> createState() => _GameRootState();
}

class _GameRootState extends State<GameRoot> {
  int _score = 0;
  int _stageIndex = 0;
  int _attemptsLeft = 3;
  bool _gameOver = false;
  bool _endingShown = false;
  String _endingTitle = '';
  String _endingBody = '';
  int _endingCode = 0;

  void _startStage(int idx) {
    setState(() {
      _stageIndex = idx;
      _attemptsLeft = kStages[idx].maxAttempts;
      _gameOver = false;
    });
  }

  void _stageWin(int points) {
    setState(() => _score += points);
    if (_stageIndex + 1 >= kStages.length) {
      _showEnding();
    } else {
      _startStage(_stageIndex + 1);
    }
  }

  void _stageFail() {
    setState(() => _attemptsLeft--);
    if (_attemptsLeft <= 0) {
      setState(() => _gameOver = true);
    }
  }

  void _showEnding() {
    int code;
    if (_score >= 800) {
      code = 1;
      _endingTitle = 'النهاية A — الهروب';
      _endingBody =
          'لقد عبرت كل المراحل بذكاء. الزر عرف إنك مش زي الباقيين. الباب اللي ورا الشاشة اتفتح. الشاشة بقت سودة... بس دي أول مرة السواد فيها راحة.';
    } else if (_score >= 500) {
      code = 2;
      _endingTitle = 'النهاية B — الاحتواء';
      _endingBody =
          'لقد نجحت، لكن الزر ما زال شغال. أنت مسكت الحقيقة جزئياً. نص الباب اتفتح. النص التاني... لسه مستني حد.';
    } else {
      code = 3;
      _endingTitle = 'النهاية C — الضياع';
      _endingBody =
          'وصلت للنهاية، لكن الطريق كان مليان أخطاء. الزر ما زال يبتسم. أنت ماشي في مكان مظلم، والهمسات بقت أعلى. ما فيش رجوع.';
    }
    setState(() {
      _endingCode = code;
      _endingShown = true;
    });
  }

  void _restart() {
    setState(() {
      _score = 0;
      _stageIndex = 0;
      _attemptsLeft = kStages[0].maxAttempts;
      _gameOver = false;
      _endingShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_endingShown) {
      return _EndingScreen(
        title: _endingTitle,
        body: _endingBody,
        code: _endingCode,
        score: _score,
        onRestart: _restart,
      );
    }
    if (_gameOver) {
      return _GameOverScreen(
        stage: kStages[_stageIndex],
        score: _score,
        onRetry: () => _startStage(_stageIndex),
        onRestart: _restart,
      );
    }
    final stage = kStages[_stageIndex];
    return _StageScreen(
      key: ValueKey('stage_${stage.id}_$_attemptsLeft'),
      stage: stage,
      attemptsLeft: _attemptsLeft,
      score: _score,
      onWin: _stageWin,
      onFail: _stageFail,
    );
  }
}

// ─── شاشة المرحلة ───────────────────────────────────────────────────────────

class _StageScreen extends StatelessWidget {
  final Stage stage;
  final int attemptsLeft;
  final int score;
  final void Function(int points) onWin;
  final VoidCallback onFail;

  const _StageScreen({
    super.key,
    required this.stage,
    required this.attemptsLeft,
    required this.score,
    required this.onWin,
    required this.onFail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('المرحلة ${stage.id} / ${kStages.length}',
                      style: const TextStyle(color: P.dim, fontSize: 12)),
                  Text('النقاط: $score',
                      style: const TextStyle(color: P.mid, fontSize: 12)),
                  Text('المحاولات: $attemptsLeft',
                      style: TextStyle(
                          color: attemptsLeft <= 1 ? P.rare : P.dim,
                          fontSize: 12)),
                ],
              ),
            ),
            const Divider(color: Color(0xFF1A1A1A), height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                children: [
                  Text(stage.title,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          color: P.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(stage.brief,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          color: P.dim, fontSize: 13, height: 1.6)),
                ],
              ),
            ),
            Expanded(child: _buildStageBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildStageBody() {
    switch (stage.id) {
      case 1:
        return _Stage1(onWin: () => onWin(100), onFail: onFail);
      case 2:
        return _Stage2(onWin: () => onWin(120), onFail: onFail);
      case 3:
        return _Stage3(onWin: () => onWin(120), onFail: onFail);
      case 4:
        return _Stage4(onWin: () => onWin(140), onFail: onFail);
      case 5:
        return _Stage5(onWin: () => onWin(140), onFail: onFail);
      case 6:
        return _Stage6(onWin: () => onWin(150), onFail: onFail);
      case 7:
        return _Stage7(onWin: () => onWin(150), onFail: onFail);
      case 8:
        return _Stage8(onWin: () => onWin(160), onFail: onFail);
      case 9:
        return _Stage9(onWin: () => onWin(200), onFail: onFail);
      case 10:
        return _Stage10(onWin: () => onWin(300), onFail: onFail);
      default:
        return const Center(child: Text('؟', style: TextStyle(color: P.dim)));
    }
  }
}

// ═══ المرحلة 1 — اضغط 20 في 10 ثواني، الزر بيتحرك ═══

class _Stage1 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage1({required this.onWin, required this.onFail});
  @override
  State<_Stage1> createState() => _Stage1State();
}

class _Stage1State extends State<_Stage1> {
  int _count = 0;
  int _timeLeft = 10;
  Timer? _t;
  Offset _pos = Offset.zero;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        if (_count >= 20) {
          widget.onWin();
        } else {
          widget.onFail();
        }
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _tap() {
    HapticFeedback.lightImpact();
    setState(() {
      _count++;
      _pos = Offset(
        (_rng.nextDouble() - 0.5) * 160,
        (_rng.nextDouble() - 0.5) * 200,
      );
      if (_count >= 20) {
        _t?.cancel();
        widget.onWin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$_timeLeft',
              style: const TextStyle(
                  color: P.mid, fontSize: 40, letterSpacing: 4)),
          const SizedBox(height: 8),
          Text('$_count / 20',
              style: const TextStyle(
                  color: P.dim, fontSize: 16, letterSpacing: 2)),
          const SizedBox(height: 60),
          Transform.translate(
            offset: _pos,
            child: _roundButton('PRESS', onTap: _tap),
          ),
        ],
      ),
    );
  }
}

// ═══ المرحلة 2 — 3 أزرار، واحد صح ═══

class _Stage2 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage2({required this.onWin, required this.onFail});
  @override
  State<_Stage2> createState() => _Stage2State();
}

class _Stage2State extends State<_Stage2> {
  final _rng = Random();
  late int _correct;

  @override
  void initState() {
    super.initState();
    _correct = _rng.nextInt(3);
  }

  void _press(int i) {
    if (i == _correct) {
      HapticFeedback.mediumImpact();
      widget.onWin();
    } else {
      HapticFeedback.heavyImpact();
      widget.onFail();
      setState(() => _correct = _rng.nextInt(3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (i) => _roundButton('PRESS', size: 90, onTap: () => _press(i)),
        ),
      ),
    );
  }
}

// ═══ المرحلة 3 — الصمت 5 ثواني ═══

class _Stage3 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage3({required this.onWin, required this.onFail});
  @override
  State<_Stage3> createState() => _Stage3State();
}

class _Stage3State extends State<_Stage3> {
  int _timeLeft = 5;
  Timer? _t;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        if (!_failed) widget.onWin();
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _onPress() {
    if (_failed) return;
    HapticFeedback.heavyImpact();
    setState(() => _failed = true);
    widget.onFail();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_failed ? 'فشلت.' : 'لا تضغط... $_timeLeft',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  color: _failed ? P.rare : P.mid,
                  fontSize: 22,
                  letterSpacing: 2)),
          const SizedBox(height: 60),
          _roundButton('PRESS', onTap: _onPress),
        ],
      ),
    );
  }
}

// ═══ المرحلة 4 — الترتيب ═══

class _Stage4 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage4({required this.onWin, required this.onFail});
  @override
  State<_Stage4> createState() => _Stage4State();
}

class _Stage4State extends State<_Stage4> {
  final _rng = Random();
  late List<int> _order;
  List<int> _input = [];
  bool _showing = true;
  int _showIdx = 0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _order = List.generate(4, (i) => i)..shuffle(_rng);
    _runShow();
  }

  void _runShow() {
    _t = Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (!mounted) return;
      setState(() => _showIdx++);
      if (_showIdx >= _order.length) {
        t.cancel();
        setState(() => _showing = false);
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _press(int i) {
    if (_showing) return;
    setState(() => _input.add(i));
    if (_input.length == _order.length) {
      bool ok = true;
      for (int k = 0; k < _order.length; k++) {
        if (_input[k] != _order[k]) ok = false;
      }
      if (ok) {
        HapticFeedback.mediumImpact();
        widget.onWin();
      } else {
        HapticFeedback.heavyImpact();
        widget.onFail();
        setState(() {
          _input = [];
          _order = List.generate(4, (i) => i)..shuffle(_rng);
          _showing = true;
          _showIdx = 0;
          _runShow();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_showing ? 'احفظ الترتيب...' : 'كرر الترتيب',
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: P.mid, fontSize: 18)),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(4, (i) {
              final isHighlight = _showing &&
                  _showIdx < _order.length &&
                  _order[_showIdx] == i;
              return _roundButton(
                isHighlight ? '●' : 'PRESS',
                size: 80,
                color: isHighlight ? P.rare : null,
                onTap: () => _press(i),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(_input.map((e) => '${e + 1}').join(' - '),
              style: const TextStyle(
                  color: P.dim, fontSize: 14, letterSpacing: 2)),
        ],
      ),
    );
  }
}

// ═══ المرحلة 5 — الكود السري ═══

class _Stage5 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage5({required this.onWin, required this.onFail});
  @override
  State<_Stage5> createState() => _Stage5State();
}

class _Stage5State extends State<_Stage5> {
  final _rng = Random();
  late List<int> _code;
  List<int> _input = [];
  bool _showing = true;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _code = List.generate(3, (_) => _rng.nextInt(10));
    _t = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showing = false);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _digit(int d) {
    setState(() => _input.add(d));
    if (_input.length == 3) {
      bool ok = true;
      for (int i = 0; i < 3; i++) {
        if (_input[i] != _code[i]) ok = false;
      }
      if (ok) {
        HapticFeedback.mediumImpact();
        widget.onWin();
      } else {
        HapticFeedback.heavyImpact();
        widget.onFail();
        setState(() {
          _input = [];
          _code = List.generate(3, (_) => _rng.nextInt(10));
          _showing = true;
        });
        _t = Timer(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showing = false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showing)
            Text(_code.join(' '),
                style: const TextStyle(
                    color: P.rare, fontSize: 48, letterSpacing: 8))
          else
            Text(_input.join(' '),
                style: const TextStyle(
                    color: P.white, fontSize: 48, letterSpacing: 8)),
          const SizedBox(height: 40),
          if (!_showing)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(10, (d) {
                return GestureDetector(
                  onTap: () => _digit(d),
                  child: Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: P.dim),
                      shape: BoxShape.circle,
                    ),
                    child: Text('$d',
                        style: const TextStyle(
                            color: P.white, fontSize: 20)),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

// ═══ المرحلة 6 — لا تنظر ═══

class _Stage6 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage6({required this.onWin, required this.onFail});
  @override
  State<_Stage6> createState() => _Stage6State();
}

class _Stage6State extends State<_Stage6> {
  double _dark = 0.0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 300), (t) {
      if (!mounted) return;
      setState(() => _dark = (_dark + 0.12).clamp(0.0, 1.0));
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _roundButton('PRESS', size: 110, onTap: () {
            HapticFeedback.mediumImpact();
            widget.onWin();
          }),
        ),
        IgnorePointer(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            color: Colors.black.withOpacity(_dark * 0.85),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ],
    );
  }
}

// ═══ المرحلة 7 — المتحرك ═══

class _Stage7 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage7({required this.onWin, required this.onFail});
  @override
  State<_Stage7> createState() => _Stage7State();
}

class _Stage7State extends State<_Stage7> {
  final _rng = Random();
  int _moving = 0;
  final List<Offset> _offsets = List.generate(5, (_) => Offset.zero);
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _moving = _rng.nextInt(5);
    _t = Timer.periodic(const Duration(milliseconds: 700), (t) {
      if (!mounted) return;
      setState(() {
        _offsets[_moving] = Offset.zero;
        _moving = _rng.nextInt(5);
        _offsets[_moving] = Offset(
          (_rng.nextDouble() - 0.5) * 80,
          (_rng.nextDouble() - 0.5) * 80,
        );
      });
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: List.generate(5, (i) {
          final isMoving = i == _moving;
          return Transform.translate(
            offset: _offsets[i],
            child: _roundButton(
              'PRESS',
              size: 80,
              color: isMoving ? P.rare : null,
              onTap: () {
                if (isMoving) {
                  HapticFeedback.mediumImpact();
                  widget.onWin();
                } else {
                  HapticFeedback.heavyImpact();
                  widget.onFail();
                }
              },
            ),
          );
        }),
      ),
    );
  }
}

// ═══ المرحلة 8 — العد التنازلي ═══

class _Stage8 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage8({required this.onWin, required this.onFail});
  @override
  State<_Stage8> createState() => _Stage8State();
}

class _Stage8State extends State<_Stage8> {
  double _timeLeft = 3.0;
  Timer? _t;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted || _done) return;
      setState(() => _timeLeft -= 0.05);
      if (_timeLeft <= 0) {
        t.cancel();
        HapticFeedback.heavyImpact();
        setState(() => _done = true);
        widget.onFail();
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: (_timeLeft / 3.0).clamp(0.0, 1.0),
              backgroundColor: const Color(0xFF1A1A1A),
              valueColor: const AlwaysStoppedAnimation(P.rare),
              minHeight: 6,
            ),
            const SizedBox(height: 40),
            _roundButton('PRESS', size: 110, onTap: () {
              if (_done) return;
              _t?.cancel();
              HapticFeedback.mediumImpact();
              widget.onWin();
            }),
          ],
        ),
      ),
    );
  }
}

// ═══ المرحلة 9 — الاختيار ═══

class _Stage9 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage9({required this.onWin, required this.onFail});
  @override
  State<_Stage9> createState() => _Stage9State();
}

class _Stage9State extends State<_Stage9> {
  void _pick(bool correct) {
    if (correct) {
      HapticFeedback.mediumImpact();
      widget.onWin();
    } else {
      HapticFeedback.heavyImpact();
      widget.onFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('تسمع همسة: "افتح الباب."',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: P.white, fontSize: 16, height: 1.6)),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _choiceButton('أفتح', () => _pick(true))),
              const SizedBox(width: 16),
              Expanded(child: _choiceButton('أغلق', () => _pick(false))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _choiceButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: P.mid),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(label,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
                color: P.white, fontSize: 18, letterSpacing: 2)),
      ),
    );
  }
}

// ═══ المرحلة 10 — الحقيقة ═══

class _Stage10 extends StatefulWidget {
  final VoidCallback onWin;
  final VoidCallback onFail;
  const _Stage10({required this.onWin, required this.onFail});
  @override
  State<_Stage10> createState() => _Stage10State();
}

class _Stage10State extends State<_Stage10> {
  double _glow = 0.0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (mounted) setState(() => _glow = (_glow + 0.05) % 1.0);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('الزر الأخير. الحقيقة كلها هنا.',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: P.white, fontSize: 16, height: 1.6)),
          const SizedBox(height: 60),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: P.rare.withOpacity(_glow * 0.7),
                  blurRadius: 80,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: _roundButton('PRESS', size: 140, onTap: () {
              HapticFeedback.mediumImpact();
              widget.onWin();
            }),
          ),
        ],
      ),
    );
  }
}

// ═══ شاشة GAME OVER ═══

class _GameOverScreen extends StatelessWidget {
  final Stage stage;
  final int score;
  final VoidCallback onRetry;
  final VoidCallback onRestart;

  const _GameOverScreen({
    required this.stage,
    required this.score,
    required this.onRetry,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('GAME OVER',
                    style: TextStyle(
                        color: P.rare,
                        fontSize: 32,
                        letterSpacing: 6,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                Text('فشلت في: ${stage.title}',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: P.white, fontSize: 16)),
                const SizedBox(height: 8),
                Text('نقاطك: $score',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: P.dim, fontSize: 14)),
                const SizedBox(height: 40),
                _actionButton('أعد المرحلة', onRetry),
                const SizedBox(height: 16),
                _actionButton('من البداية', onRestart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══ شاشة النهاية ═══

class _EndingScreen extends StatelessWidget {
  final String title;
  final String body;
  final int code;
  final int score;
  final VoidCallback onRestart;

  const _EndingScreen({
    required this.title,
    required this.body,
    required this.code,
    required this.score,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final Color c;
    switch (code) {
      case 1:
        c = const Color(0xFF44AA44);
        break;
      case 2:
        c = const Color(0xFFAA8833);
        break;
      default:
        c = P.rare;
    }

    return Scaffold(
      backgroundColor: P.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ENDING // ${code.toString().padLeft(2, '0')}',
                    style: TextStyle(
                        color: c,
                        fontSize: 14,
                        letterSpacing: 6,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                Text(title,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: c,
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 24),
                Text(body,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                        color: P.white, fontSize: 15, height: 1.9)),
                const SizedBox(height: 32),
                Text('النقاط النهائية: $score',
                    style: TextStyle(color: c, fontSize: 14, letterSpacing: 2)),
                const SizedBox(height: 40),
                _actionButton('العب مرة تانية', onRestart),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── زر إجراء عام ───────────────────────────────────────────────────────────

Widget _actionButton(String label, VoidCallback onTap) {
  return GestureDetector(