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

class P {
  static const bg = Color(0xFF050505);
  static const dim = Color(0xFF6A6A6A);
  static const mid = Color(0xFFAA3333);
  static const rare = Color(0xFFFF4444);
  static const white = Color(0xFFE0E0E0);
}

class Stage {
  final int id;
  final String title;
  final String brief;
  final int maxAttempts;
  const Stage({required this.id, required this.title, required this.brief, required this.maxAttempts});
}

const List<Stage> kStages = [
  Stage(id: 1, title: 'لا تضغط 20 مرة', brief: 'الزر بيتحرك. الحق اضغط 20 ضغطة في 10 ثواني.', maxAttempts: 3, whisper: 'سمعت صوت؟ ... يمكن مفيش حاجة.'),
  Stage(id: 2, title: 'الزر الصح', brief: '3 أزرار. واحد بس هو الصح.', maxAttempts: 3, whisper: 'الزر عارف إنك بتفكر.'),
  Stage(id: 3, title: 'الصمت', brief: 'متضغطش خالص لمدة 5 ثواني.', maxAttempts: 2, whisper: 'الصمت بيوجع أكتر من الضغط.'),
  Stage(id: 4, title: 'الترتيب', brief: '4 أزرار. احفظ الترتيب واضغطه صح.', maxAttempts: 3, whisper: 'الترتيب دا كان في مكان تاني.'),
  Stage(id: 5, title: 'الكود السري', brief: '3 أرقام هتظهر لحظة. احفظهم وأدخلهم.', maxAttempts: 3, whisper: 'الأرقام دي مألوفة؟'),
  Stage(id: 6, title: 'لا تنظر', brief: 'الشاشة هتعتم. اضغط من غير ما تشوف.', maxAttempts: 3, whisper: 'مين اللي بيضغط؟ إنت ولا الزر؟'),
  Stage(id: 7, title: 'المتحرك', brief: '5 أزرار. واحد بس بيتحرك. اضغطه.', maxAttempts: 3, whisper: 'الزر بيهرب منك.'),
  Stage(id: 8, title: 'العد التنازلي', brief: 'اضغط قبل ما الوقت يخلص.', maxAttempts: 3, whisper: 'الوقت مش دايم في صفك.'),
  Stage(id: 9, title: 'الاختيار', brief: 'همسة تقول: "افتح الباب."', maxAttempts: 1, whisper: 'الباب اللي جواك.'),
  Stage(id: 10, title: 'الحقيقة', brief: 'الزر الأخير. اضغطه لو تجرؤ.', maxAttempts: 1, whisper: 'مفيش رجوع بعد كده.'),
  Stage(id: 11, title: 'المرايا', brief: '3 أزرار. واحد بس أصلي. الباقي انعكاس.', maxAttempts: 3, whisper: 'شوف كويس مين إنت.'),
  Stage(id: 12, title: 'الهمس', brief: 'كلمة هتظهر لحظة. اكتبها صح.', maxAttempts: 3, whisper: 'الكلمة دي هتفضل معاك.'),
  Stage(id: 13, title: 'الظل', brief: 'ظل بيتحرك. اضغطه قبل ما يختفي.', maxAttempts: 3, whisper: 'الظل بيعرف اسمك.'),
  Stage(id: 14, title: 'المتاهة', brief: 'الهدف بيتغير كل ثانية. اجمع 3 إصابات.', maxAttempts: 3, whisper: 'التوهان جزء من اللعبة.'),
  Stage(id: 15, title: 'المقلوب', brief: 'اقرأ بعكس ما تشوف.', maxAttempts: 3, whisper: 'الحقيقة معكوسة.'),
  Stage(id: 16, title: 'الذاكرة', brief: '5 رموز تظهر بالترتيب. كررها.', maxAttempts: 3, whisper: 'اللي هتنساه هيفضل يفتكرك.'),
  Stage(id: 17, title: 'الصبر', brief: '10 ثواني بدون لمس. الفخ بيستفزك.', maxAttempts: 2, whisper: 'الزر بيكلمك. اسمعه.'),
  Stage(id: 18, title: 'الارتباك', brief: '8 أزرار. واحد بس بيتحرك.', maxAttempts: 3, whisper: 'كلهم بيتحركوا لو بصيت كفاية.'),
  Stage(id: 19, title: 'القرار الأخير', brief: '3 أزرار. واحد بس بيكمل.', maxAttempts: 1, whisper: 'آخر قرار.'),
  Stage(id: 20, title: 'الباب', brief: 'اضغط 5 ثواني بدون رفع صباعك.', maxAttempts: 1, whisper: 'افتح الباب.'),
  Stage(id: 21, title: 'النبض', brief: 'الزر بينبض. اضغط بس لما يوصل لأقصى نبضة.', maxAttempts: 3, whisper: 'النبض بيقولك إمتى.'),
  Stage(id: 22, title: 'التوأم', brief: 'زرين متطابقين. اضغطهم في نفس الوقت.', maxAttempts: 3, whisper: 'الاتنين واحد. أو مش واحد.'),
  Stage(id: 23, title: 'الدوار', brief: 'الزر بيلف حوالين الشاشة. اضغطه 3 مرات.', maxAttempts: 3, whisper: 'مش هتقدر تلحق.'),
  Stage(id: 24, title: 'الصوت', brief: 'الشاشة هتسكت. اعتمد على الإحساس بس.', maxAttempts: 3, whisper: 'حس بالإيد اللي مش شايفها.'),
  Stage(id: 25, title: 'العد التنازلي للفشل', brief: 'كل ثانية بتقربك من الفشل. اضغط بسرعة.', maxAttempts: 2, whisper: 'الوقت بيجري منك.'),
  Stage(id: 26, title: 'المرايا المتعددة', brief: '5 أزرار. واحد بس بيتحرك ببطء.', maxAttempts: 3, whisper: 'واحد بس بيعرف الطريق.'),
  Stage(id: 27, title: 'الكمين', brief: '5 ضغطات صح ورا بعض. أي غلطة بتفشل.', maxAttempts: 3, whisper: 'الغلطة الواحدة بتكلف.'),
  Stage(id: 28, title: 'الحبل', brief: 'الشاشة بتتقطع. اضغط قبل ما تختفي خالص.', maxAttempts: 3, whisper: 'الخيط بيقطع.'),
  Stage(id: 29, title: 'الاسم', brief: 'اكتب اسمك. بعدين اضغط الزر اللي فيه اسمك.', maxAttempts: 1, whisper: 'إنت مين؟'),
  Stage(id: 30, title: 'الباب الأخير', brief: 'اضغط الزر 3 مرات. المرة التالتة بتفتح الحقيقة.', maxAttempts: 1, whisper: 'خلاص. ما فيش بعد كده.'),
];

Widget _roundButton(String label, {required VoidCallback onTap, double size = 120, Color? color}) {
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
        boxShadow: [BoxShadow(color: (color ?? P.mid).withOpacity(0.4), blurRadius: 20)],
      ),
      child: Text(
        label,
        style: TextStyle(color: color ?? P.mid, fontSize: size * 0.16, letterSpacing: 3, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

Widget _actionButton(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: P.mid),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        textDirection: TextDirection.rtl,
        style: const TextStyle(color: P.white, fontSize: 15, letterSpacing: 1),
      ),
    ),
  );
}

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
    if (_attemptsLeft <= 0) setState(() => _gameOver = true);
  }

  void _showEnding() {
    int code;
    if (_score >= 2200) {
      code = 1;
      _endingTitle = 'النهاية A — الهروب';
      _endingBody = 'عبرت 20 مرحلة بذكاء. الزر عرف إنك مش زي الباقيين. الباب اللي ورا الشاشة اتفتح.';
    } else if (_score >= 1400) {
      code = 2;
      _endingTitle = 'النهاية B — الاحتواء';
      _endingBody = 'نجحت، لكن الزر ما زال شغال. مسكت الحقيقة جزئياً.';
    } else {
      code = 3;
      _endingTitle = 'النهاية C — الضياع';
      _endingBody = 'وصلت للنهاية، لكن الطريق كان مليان أخطاء. ما فيش رجوع.';
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
      key: ValueKey('s${stage.id}_$_attemptsLeft'),
      stage: stage,
      attemptsLeft: _attemptsLeft,
      score: _score,
      onWin: _stageWin,
      onFail: _stageFail,
    );
  }
}

class _StageScreen extends StatelessWidget {
  final Stage stage;
  final int attemptsLeft;
  final int score;
  final void Function(int) onWin;
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
                  Text('المرحلة ${stage.id}/${kStages.length}',
                      style: const TextStyle(color: P.dim, fontSize: 12)),
                  Text('النقاط: $score',
                      style: const TextStyle(color: P.mid, fontSize: 12)),
                  Text('محاولات: $attemptsLeft',
                      style: TextStyle(color: attemptsLeft <= 1 ? P.rare : P.dim, fontSize: 12)),
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
                      style: const TextStyle(color: P.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(stage.brief,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(color: P.dim, fontSize: 13, height: 1.6)),
                ],
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    switch (stage.id) {
      case 1: return _Stage1(onWin: () => onWin(100), onFail: onFail);
      case 2: return _Stage2(onWin: () => onWin(120), onFail: onFail);
      case 3: return _Stage3(onWin: () => onWin(120), onFail: onFail);
      case 4: return _Stage4(onWin: () => onWin(140), onFail: onFail);
      case 5: return _Stage5(onWin: () => onWin(140), onFail: onFail);
      case 6: return _Stage6(onWin: () => onWin(150), onFail: onFail);
      case 7: return _Stage7(onWin: () => onWin(150), onFail: onFail);
      case 8: return _Stage8(onWin: () => onWin(160), onFail: onFail);
      case 9: return _Stage9(onWin: () => onWin(200), onFail: onFail);
      case 10: return _Stage10(onWin: () => onWin(300), onFail: onFail);
      case 11: return _Stage11(onWin: () => onWin(180), onFail: onFail);
      case 12: return _Stage12(onWin: () => onWin(180), onFail: onFail);
      case 13: return _Stage13(onWin: () => onWin(200), onFail: onFail);
      case 14: return _Stage14(onWin: () => onWin(200), onFail: onFail);
      case 15: return _Stage15(onWin: () => onWin(220), onFail: onFail);
      case 16: return _Stage16(onWin: () => onWin(220), onFail: onFail);
      case 17: return _Stage17(onWin: () => onWin(240), onFail: onFail);
      case 18: return _Stage18(onWin: () => onWin(240), onFail: onFail);
      case 19: return _Stage19(onWin: () => onWin(280), onFail: onFail);
      case 20: return _Stage20(onWin: () => onWin(400), onFail: onFail);
      default: return const SizedBox();
    }
  }
}

// ═══ المرحلة 1 ═══
class _Stage1 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage1({required this.onWin, required this.onFail});
  @override
  State<_Stage1> createState() => _Stage1State();
}
class _Stage1State extends State<_Stage1> {
  int _count = 0;
  int _timeLeft = 20;
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
        _count >= 20 ? widget.onWin() : widget.onFail();
      }
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _tap() {
    HapticFeedback.lightImpact();
    setState(() {
      _count++;
      _pos = Offset((_rng.nextDouble() - 0.5) * 160, (_rng.nextDouble() - 0.5) * 200);
      if (_count >= 20) { _t?.cancel(); widget.onWin(); }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('$_timeLeft', style: const TextStyle(color: P.mid, fontSize: 40, letterSpacing: 4)),
      const SizedBox(height: 8),
      Text('$_count / 20', style: const TextStyle(color: P.dim, fontSize: 16)),
      const SizedBox(height: 60),
      Transform.translate(offset: _pos, child: _roundButton('PRESS', onTap: _tap)),
    ]));
  }
}

// ═══ المرحلة 2 ═══
class _Stage2 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage2({required this.onWin, required this.onFail});
  @override
  State<_Stage2> createState() => _Stage2State();
}
class _Stage2State extends State<_Stage2> {
  final _rng = Random();
  late int _correct;
  @override
  void initState() { super.initState(); _correct = _rng.nextInt(3); }
  void _press(int i) {
    if (i == _correct) { HapticFeedback.mediumImpact(); widget.onWin(); }
    else { HapticFeedback.heavyImpact(); widget.onFail(); setState(() => _correct = _rng.nextInt(3)); }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) => _roundButton('PRESS', size: 90, onTap: () => _press(i)))));
  }
}

// ═══ المرحلة 3 ═══
class _Stage3 extends StatefulWidget {
  final VoidCallback onWin, onFail;
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
      if (_timeLeft <= 0) { t.cancel(); if (!_failed) widget.onWin(); }
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _onPress() {
    if (_failed) return;
    HapticFeedback.heavyImpact();
    setState(() => _failed = true);
    widget.onFail();
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_failed ? 'فشلت.' : 'لا تضغط... $_timeLeft',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: _failed ? P.rare : P.mid, fontSize: 22, letterSpacing: 2)),
      const SizedBox(height: 60),
      _roundButton('PRESS', onTap: _onPress),
    ]));
  }
}

// ═══ المرحلة 4 ═══
class _Stage4 extends StatefulWidget {
  final VoidCallback onWin, onFail;
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
      if (_showIdx >= _order.length) { t.cancel(); setState(() => _showing = false); }
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _press(int i) {
    if (_showing) return;
    setState(() => _input.add(i));
    if (_input.length == _order.length) {
      bool ok = true;
      for (int k = 0; k < _order.length; k++) { if (_input[k] != _order[k]) ok = false; }
      if (ok) { HapticFeedback.mediumImpact(); widget.onWin(); }
      else {
        HapticFeedback.heavyImpact(); widget.onFail();
        setState(() { _input = []; _order = List.generate(4, (i) => i)..shuffle(_rng); _showing = true; _showIdx = 0; _runShow(); });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_showing ? 'احفظ الترتيب...' : 'كرر الترتيب',
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: P.mid, fontSize: 18)),
      const SizedBox(height: 40),
      Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
        children: List.generate(4, (i) {
          final hl = _showing && _showIdx < _order.length && _order[_showIdx] == i;
          return _roundButton(hl ? '●' : 'PRESS', size: 80, color: hl ? P.rare : null, onTap: () => _press(i));
        })),
      const SizedBox(height: 20),
      Text(_input.map((e) => '${e + 1}').join(' - '), style: const TextStyle(color: P.dim, fontSize: 14)),
    ]));
  }
}

// ═══ المرحلة 5 ═══
class _Stage5 extends StatefulWidget {
  final VoidCallback onWin, onFail;
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
    _t = Timer(const Duration(seconds: 3), () { if (mounted) setState(() => _showing = false); });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _digit(int d) {
    setState(() => _input.add(d));
    if (_input.length == 3) {
      bool ok = true;
      for (int i = 0; i < 3; i++) { if (_input[i] != _code[i]) ok = false; }
      if (ok) { HapticFeedback.mediumImpact(); widget.onWin(); }
      else {
        HapticFeedback.heavyImpact(); widget.onFail();
        setState(() { _input = []; _code = List.generate(3, (_) => _rng.nextInt(10)); _showing = true; });
        _t = Timer(const Duration(seconds: 3), () { if (mounted) setState(() => _showing = false); });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_showing ? _code.join(' ') : _input.join(' '),
          style: TextStyle(color: _showing ? P.rare : P.white, fontSize: 48, letterSpacing: 8)),
      const SizedBox(height: 40),
      if (!_showing)
        Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
          children: List.generate(10, (d) => GestureDetector(
            onTap: () => _digit(d),
            child: Container(width: 56, height: 56, alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: P.dim), shape: BoxShape.circle),
              child: Text('$d', style: const TextStyle(color: P.white, fontSize: 20))),
          ))),
    ]));
  }
}

// ═══ المرحلة 6 ═══
class _Stage6 extends StatefulWidget {
  final VoidCallback onWin, onFail;
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
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(child: _roundButton('PRESS', size: 110, onTap: () {
        HapticFeedback.mediumImpact(); widget.onWin();
      })),
      IgnorePointer(child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: Colors.black.withOpacity(_dark * 0.85),
        width: double.infinity, height: double.infinity)),
    ]);
  }
}

// ═══ المرحلة 7 ═══
class _Stage7 extends StatefulWidget {
  final VoidCallback onWin, onFail;
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
        _offsets[_moving] = Offset((_rng.nextDouble() - 0.5) * 80, (_rng.nextDouble() - 0.5) * 80);
      });
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center,
      children: List.generate(5, (i) {
        final isMoving = i == _moving;
        return Transform.translate(offset: _offsets[i],
          child: _roundButton('PRESS', size: 80, color: isMoving ? P.rare : null,
            onTap: () {
              if (isMoving) { HapticFeedback.mediumImpact(); widget.onWin(); }
              else { HapticFeedback.heavyImpact(); widget.onFail(); }
            }));
      })));
  }
}

// ═══ المرحلة 8 ═══
class _Stage8 extends StatefulWidget {
  final VoidCallback onWin, onFail;
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
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LinearProgressIndicator(
          value: (_timeLeft / 3.0).clamp(0.0, 1.0),
          backgroundColor: const Color(0xFF1A1A1A),
          valueColor: const AlwaysStoppedAnimation(P.rare),
          minHeight: 6),
        const SizedBox(height: 40),
        _roundButton('PRESS', size: 110, onTap: () {
          if (_done) return;
          _t?.cancel();
          HapticFeedback.mediumImpact();
          widget.onWin();
        }),
      ])));
  }
}

// ═══ المرحلة 9 ═══
class _Stage9 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage9({required this.onWin, required this.onFail});
  @override
  State<_Stage9> createState() => _Stage9State();
}
class _Stage9State extends State<_Stage9> {
  void _pick(bool correct) {
    if (correct) { HapticFeedback.mediumImpact(); widget.onWin(); }
    else { HapticFeedback.heavyImpact(); widget.onFail(); }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('تسمع همسة: "افتح الباب."',
            textDirection: TextDirection.rtl,
            style: TextStyle(color: P.white, fontSize: 16, height: 1.6)),
        const SizedBox(height: 40),
        Row(children: [
          Expanded(child: _choiceButton('أفتح', () => _pick(true))),
          const SizedBox(width: 16),
          Expanded(child: _choiceButton('أغلق', () => _pick(false))),
        ]),
      ]));
  }
  Widget _choiceButton(String label, VoidCallback onTap) {
    return GestureDetector(onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(border: Border.all(color: P.mid), borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text(label, textDirection: TextDirection.rtl,
            style: const TextStyle(color: P.white, fontSize: 18, letterSpacing: 2))));
  }
}

// ═══ المرحلة 10 ═══
class _Stage10 extends StatefulWidget {
  final VoidCallback onWin, onFail;
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
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('الزر الأخير. الحقيقة كلها هنا.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: P.white, fontSize: 16, height: 1.6)),
      const SizedBox(height: 60),
      Container(decoration: BoxDecoration(shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: P.rare.withOpacity(_glow * 0.7), blurRadius: 80, spreadRadius: 10)]),
        child: _roundButton('PRESS', size: 140, onTap: () {
          HapticFeedback.mediumImpact(); widget.onWin();
        })),
    ]));
  }
}


// ═══ المرحلة 11 — المرايا ═══
class _Stage11 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage11({required this.onWin, required this.onFail});
  @override
  State<_Stage11> createState() => _Stage11State();
}
class _Stage11State extends State<_Stage11> {
  final _rng = Random();
  late int _correct;
  @override
  void initState() { super.initState(); _correct = _rng.nextInt(3); }
  void _press(int i) {
    if (i == _correct) { HapticFeedback.mediumImpact(); widget.onWin(); }
    else { HapticFeedback.heavyImpact(); widget.onFail(); setState(() => _correct = _rng.nextInt(3)); }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('واحد بس أصلي. الباقي انعكاس.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: P.dim, fontSize: 14)),
      const SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (i) => _roundButton(
          i == _correct ? 'PRESS' : 'STOP', size: 90,
          color: i == _correct ? P.rare : P.dim,
          onTap: () => _press(i)))),
    ]));
  }
}

// ═══ المرحلة 12 — الهمس ═══
class _Stage12 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage12({required this.onWin, required this.onFail});
  @override
  State<_Stage12> createState() => _Stage12State();
}
class _Stage12State extends State<_Stage12> {
  static const _words = ['قريب', 'خلفك', 'اسمع', 'توقف', 'انظر', 'الآن'];
  final _rng = Random();
  late String _target;
  bool _showing = true;
  final _ctrl = TextEditingController();
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _target = _words[_rng.nextInt(_words.length)];
    _t = Timer(const Duration(seconds: 2), () { if (mounted) setState(() => _showing = false); });
  }
  @override
  void dispose() { _t?.cancel(); _ctrl.dispose(); super.dispose(); }
  void _submit() {
    if (_ctrl.text.trim() == _target) { HapticFeedback.mediumImpact(); widget.onWin(); }
    else {
      HapticFeedback.heavyImpact(); widget.onFail();
      setState(() { _target = _words[_rng.nextInt(_words.length)]; _showing = true; _ctrl.clear(); });
      _t = Timer(const Duration(seconds: 2), () { if (mounted) setState(() => _showing = false); });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        _showing
            ? Text(_target, textDirection: TextDirection.rtl,
                style: const TextStyle(color: P.rare, fontSize: 42, letterSpacing: 6))
            : const Text('اكتب اللي سمعته',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: P.dim, fontSize: 14)),
        const SizedBox(height: 40),
        if (!_showing)
          TextField(
            controller: _ctrl,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: P.white, fontSize: 20),
            decoration: const InputDecoration(
              hintText: '...',
              hintStyle: TextStyle(color: P.dim),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: P.dim)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: P.mid)),
            ),
            onSubmitted: (_) => _submit(),
          ),
        const SizedBox(height: 24),
        if (!_showing) _roundButton('ادخل', size: 90, onTap: _submit),
      ])));
  }
}

// ═══ المرحلة 13 — الظل ═══
class _Stage13 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage13({required this.onWin, required this.onFail});
  @override
  State<_Stage13> createState() => _Stage13State();
}
class _Stage13State extends State<_Stage13> {
  final _rng = Random();
  Offset _pos = Offset.zero;
  Timer? _t;
  bool _tapped = false;
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 800), (t) {
      if (!mounted || _tapped) return;
      setState(() {
        _pos = Offset((_rng.nextDouble() - 0.5) * 220, (_rng.nextDouble() - 0.5) * 220);
      });
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _tap() {
    if (_tapped) return;
    _tapped = true;
    HapticFeedback.mediumImpact();
    widget.onWin();
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Transform.translate(offset: _pos,
      child: GestureDetector(onTap: _tap,
        child: Container(width: 70, height: 70,
          decoration: BoxDecoration(shape: BoxShape.circle,
            color: P.rare.withOpacity(0.15),
            border: Border.all(color: P.rare, width: 2),
            boxShadow: [BoxShadow(color: P.rare.withOpacity(0.5), blurRadius: 30)])))));
  }
}

// ═══ المرحلة 14 — المتاهة ═══
class _Stage14 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage14({required this.onWin, required this.onFail});
  @override
  State<_Stage14> createState() => _Stage14State();
}
class _Stage14State extends State<_Stage14> {
  final _rng = Random();
  int _target = 0;
  Timer? _t;
  int _hits = 0;
  bool _done = false;
  @override
  void initState() {
    super.initState();
    _target = _rng.nextInt(4);
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _done) return;
      setState(() => _target = _rng.nextInt(4));
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _press(int i) {
    if (_done) return;
    if (i == _target) {
      _hits++;
      HapticFeedback.lightImpact();
      if (_hits >= 3) { _done = true; _t?.cancel(); widget.onWin(); }
      else { setState(() => _target = _rng.nextInt(4)); }
    } else {
      HapticFeedback.heavyImpact();
      widget.onFail();
      _t?.cancel();
      setState(() { _hits = 0; _target = _rng.nextInt(4); });
      _t = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted || _done) return;
        setState(() => _target = _rng.nextInt(4));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('$_hits / 3', style: const TextStyle(color: P.mid, fontSize: 32, letterSpacing: 4)),
      const SizedBox(height: 40),
      Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center,
        children: List.generate(4, (i) => _roundButton(
          i == _target ? '●' : 'PRESS', size: 80,
          color: i == _target ? P.rare : null,
          onTap: () => _press(i)))),
    ]));
  }
}

// ═══ المرحلة 15 — المقلوب ═══
class _Stage15 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage15({required this.onWin, required this.onFail});
  @override
  State<_Stage15> createState() => _Stage15State();
}
class _Stage15State extends State<_Stage15> {
  final _rng = Random();
  late int _correct;
  @override
  void initState() { super.initState(); _correct = _rng.nextInt(2); }
  void _press(int i) {
    if (i == _correct) { HapticFeedback.mediumImpact(); widget.onWin(); }
    else { HapticFeedback.heavyImpact(); widget.onFail(); setState(() => _correct = _rng.nextInt(2)); }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('اقرأ بعكس ما تشوف.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: P.dim, fontSize: 14)),
      const SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _roundButton('STOP', size: 100, color: _correct == 0 ? P.rare : null, onTap: () => _press(0)),
        _roundButton('PRESS', size: 100, color: _correct == 1 ? P.rare : null, onTap: () => _press(1)),
      ]),
    ]));
  }
}

// ═══ المرحلة 16 — الذاكرة ═══
class _Stage16 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage16({required this.onWin, required this.onFail});
  @override
  State<_Stage16> createState() => _Stage16State();
}
class _Stage16State extends State<_Stage16> {
  final _rng = Random();
  late List<int> _seq;
  List<int> _input = [];
  bool _showing = true;
  int _showIdx = 0;
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _seq = List.generate(5, (_) => _rng.nextInt(4));
    _runShow();
  }
  void _runShow() {
    _t = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) return;
      setState(() => _showIdx++);
      if (_showIdx >= _seq.length) { t.cancel(); setState(() => _showing = false); }
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _press(int i) {
    if (_showing) return;
    setState(() => _input.add(i));
    if (_input.length == _seq.length) {
      bool ok = true;
      for (int k = 0; k < _seq.length; k++) { if (_input[k] != _seq[k]) ok = false; }
      if (ok) { HapticFeedback.mediumImpact(); widget.onWin(); }
      else {
        HapticFeedback.heavyImpact(); widget.onFail();
        setState(() { _input = []; _seq = List.generate(5, (_) => _rng.nextInt(4)); _showing = true; _showIdx = 0; _runShow(); });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_showing ? 'احفظ...' : 'كرر',
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: P.mid, fontSize: 18)),
      const SizedBox(height: 40),
      Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
        children: List.generate(4, (i) {
          final hl = _showing && _showIdx < _seq.length && _seq[_showIdx] == i;
          return _roundButton('${i + 1}', size: 80, color: hl ? P.rare : null, onTap: () => _press(i));
        })),
    ]));
  }
}

// ═══ المرحلة 17 — الصبر ═══
class _Stage17 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage17({required this.onWin, required this.onFail});
  @override
  State<_Stage17> createState() => _Stage17State();
}
class _Stage17State extends State<_Stage17> {
  int _timeLeft = 10;
  Timer? _t;
  bool _failed = false;
  final _rng = Random();
  String _tease = '';
  static const _teases = ['اضغط. أعرف إنك عايز.', 'خايف؟', 'الزر مش هيعض.', 'اضغط. أنا واثق.', 'تلاتة... اضغط.'];
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() { _timeLeft--; _tease = _teases[_rng.nextInt(_teases.length)]; });
      if (_timeLeft <= 0) { t.cancel(); if (!_failed) widget.onWin(); }
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _onPress() {
    if (_failed) return;
    HapticFeedback.heavyImpact();
    setState(() => _failed = true);
    widget.onFail();
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_failed ? 'فشلت.' : '$_timeLeft',
          style: TextStyle(color: _failed ? P.rare : P.mid, fontSize: 60, letterSpacing: 4)),
      const SizedBox(height: 20),
      Text(_tease, textDirection: TextDirection.rtl,
          style: const TextStyle(color: P.dim, fontSize: 14, fontStyle: FontStyle.italic)),
      const SizedBox(height: 60),
      _roundButton('PRESS', onTap: _onPress),
    ]));
  }
}

// ═══ المرحلة 18 — الارتباك ═══
class _Stage18 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage18({required this.onWin, required this.onFail});
  @override
  State<_Stage18> createState() => _Stage18State();
}
class _Stage18State extends State<_Stage18> {
  final _rng = Random();
  int _moving = 0;
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _moving = _rng.nextInt(8);
    _t = Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (!mounted) return;
      setState(() => _moving = _rng.nextInt(8));
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
      children: List.generate(8, (i) {
        final isMoving = i == _moving;
        return _roundButton('PRESS', size: 65, color: isMoving ? P.rare : null,
          onTap: () {
            if (isMoving) { HapticFeedback.mediumImpact(); widget.onWin(); }
            else { HapticFeedback.heavyImpact(); widget.onFail(); }
          });
      })));
  }
}

// ═══ المرحلة 19 — القرار الأخير ═══
class _Stage19 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage19({required this.onWin, required this.onFail});
  @override
  State<_Stage19> createState() => _Stage19State();
}
class _Stage19State extends State<_Stage19> {
  final _rng = Random();
  late int _correct;
  @override
  void initState() { super.initState(); _correct = _rng.nextInt(3); }
  void _press(int i) {
    if (i == _correct) { HapticFeedback.mediumImpact(); widget.onWin(); }
    else { HapticFeedback.heavyImpact(); widget.onFail(); }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('واحد بس بيكمل. الباقي بينهي.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: P.white, fontSize: 15)),
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (i) => _roundButton('?', size: 90, onTap: () => _press(i)))),
    ]));
  }
}

// ═══ المرحلة 20 — الباب ═══
class _Stage20 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage20({required this.onWin, required this.onFail});
  @override
  State<_Stage20> createState() => _Stage20State();
}
class _Stage20State extends State<_Stage20> {
  double _holdTime = 0.0;
  Timer? _t;
  bool _pressing = false;
  bool _done = false;
  static const _required = 5.0;
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  void _start() {
    if (_done) return;
    _pressing = true;
    _t = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted || !_pressing) { t.cancel(); return; }
      setState(() => _holdTime += 0.05);
      if (_holdTime >= _required) {
        _done = true;
        _pressing = false;
        t.cancel();
        HapticFeedback.mediumImpact();
        widget.onWin();
      }
    });
  }
  void _stop() {
    if (_done) return;
    _pressing = false;
    _t?.cancel();
    if (_holdTime > 0 && _holdTime < _required) {
      setState(() => _holdTime = 0.0);
      HapticFeedback.heavyImpact();
      widget.onFail();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('اضغط 5 ثواني بدون رفع صباعك.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: P.white, fontSize: 15)),
      const SizedBox(height: 30),
      SizedBox(width: 220,
        child: LinearProgressIndicator(
          value: (_holdTime / _required).clamp(0.0, 1.0),
          backgroundColor: const Color(0xFF1A1A1A),
          valueColor: const AlwaysStoppedAnimation(P.rare),
          minHeight: 8)),
      const SizedBox(height: 40),
      GestureDetector(
        onTapDown: (_) => _start(),
        onTapUp: (_) => _stop(),
        onTapCancel: _stop,
        child: Container(width: 160, height: 160, alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle,
            color: const Color(0xFF141414),
            border: Border.all(color: _pressing ? P.rare : P.mid, width: 3),
            boxShadow: [BoxShadow(color: P.rare.withOpacity(_pressing ? 0.7 : 0.2), blurRadius: _pressing ? 60 : 20)]),
          child: const Text('PRESS',
              style: TextStyle(color: P.rare, fontSize: 22, letterSpacing: 4, fontWeight: FontWeight.w700)))),
      const SizedBox(height: 20),
      Text('${_holdTime.toStringAsFixed(1)} / 5.0',
          style: const TextStyle(color: P.dim, fontSize: 14)),
    ]));
  }
}

// ═══ المرحلة 21 — النبض ═══
class _Stage21 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage21({required this.onWin, required this.onFail});
  @override
  State<_Stage21> createState() => _Stage21State();
}
class _Stage21State extends State<_Stage21> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _clicked = false;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final v = (sin(_ctrl.value * 2 * pi) + 1) / 2; // 0..1
        final size = 100 + v * 60;
        final isPeak = v > 0.85;
        return GestureDetector(
          onTap: _clicked ? null : () {
            if (isPeak) { HapticFeedback.mediumImpact(); widget.onWin(); }
            else { HapticFeedback.heavyImpact(); widget.onFail(); }
            setState(() => _clicked = true);
          },
          child: Container(
            width: size, height: size, alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF141414),
              border: Border.all(color: isPeak ? P.rare : P.mid, width: isPeak ? 4 : 2),
              boxShadow: [BoxShadow(color: P.rare.withOpacity(v * 0.8), blurRadius: 40 + v * 40)],
            ),
            child: Text('PRESS', style: TextStyle(color: isPeak ? P.rare : P.mid, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w700)),
          ),
        );
      },
    ));
  }
}

// ═══ المرحلة 22 — التوأم ═══
class _Stage22 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage22({required this.onWin, required this.onFail});
  @override
  State<_Stage22> createState() => _Stage22State();
}
class _Stage22State extends State<_Stage22> {
  bool _leftDown = false;
  bool _rightDown = false;
  DateTime? _leftTime;
  DateTime? _rightTime;
  void _check() {
    if (_leftTime != null && _rightTime != null) {
      final diff = _leftTime!.difference(_rightTime!).inMilliseconds.abs();
      if (diff < 150) { HapticFeedback.mediumImpact(); widget.onWin(); }
      else { HapticFeedback.heavyImpact(); widget.onFail(); }
      setState(() { _leftDown = false; _rightDown = false; _leftTime = null; _rightTime = null; });
    }
  }
  Widget _twin(bool active, void Function() onDown, void Function() onUp) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      child: Container(width: 120, height: 120, alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF141414),
          border: Border.all(color: active ? P.rare : P.mid, width: active ? 4 : 2),
          boxShadow: [BoxShadow(color: (active ? P.rare : P.mid).withOpacity(0.5), blurRadius: 20)],
        ),
        child: Text('PRESS', style: TextStyle(color: active ? P.rare : P.mid, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w700))),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('اضغطهم في نفس الوقت', textDirection: TextDirection.rtl,
        style: TextStyle(color: P.dim, fontSize: 14)),
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _twin(_leftDown,
          () { setState(() { _leftDown = true; _leftTime = DateTime.now(); }); _check(); },
          () => setState(() => _leftDown = false)),
        _twin(_rightDown,
          () { setState(() { _rightDown = true; _rightTime = DateTime.now(); }); _check(); },
          () => setState(() => _rightDown = false)),
      ]),
    ]));
  }
}

// ═══ المرحلة 23 — الدوار ═══
class _Stage23 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage23({required this.onWin, required this.onFail});
  @override
  State<_Stage23> createState() => _Stage23State();
}
class _Stage23State extends State<_Stage23> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _hits = 0;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return Center(child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final angle = _ctrl.value * 2 * pi;
          final r = min(c.maxWidth, c.maxHeight) / 2 - 60;
          final dx = cos(angle) * r;
          final dy = sin(angle) * r;
          return Stack(alignment: Alignment.center, children: [
            Text('$_hits / 3', style: const TextStyle(color: P.mid, fontSize: 32, letterSpacing: 4)),
            Transform.translate(offset: Offset(dx, dy),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _hits++);
                  if (_hits >= 3) { HapticFeedback.mediumImpact(); widget.onWin(); }
                },
                child: Container(width: 70, height: 70, alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF141414),
                    border: Border.all(color: P.rare, width: 2),
                    boxShadow: [BoxShadow(color: P.rare.withOpacity(0.6), blurRadius: 30)]),
                  child: const Text('PRESS', style: TextStyle(color: P.rare, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700))),
              )),
          ]);
        },
      ));
    });
  }
}

// ═══ المرحلة 24 — الصوت (الاهتزاز) ═══
class _Stage24 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage24({required this.onWin, required this.onFail});
  @override
  State<_Stage24> createState() => _Stage24State();
}
class _Stage24State extends State<_Stage24> {
  int _count = 0;
  int _target = 5;
  bool _done = false;
  @override
  void initState() {
    super.initState();
    HapticFeedback.vibrate();
  }
  void _tap() {
    if (_done) return;
    HapticFeedback.lightImpact();
    setState(() => _count++);
    if (_count >= _target) {
      _done = true;
      HapticFeedback.vibrate();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) widget.onWin();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('$_count / $_target', style: const TextStyle(color: P.mid, fontSize: 28, letterSpacing: 4)),
      const SizedBox(height: 8),
      const Text('اتبع الإحساس', textDirection: TextDirection.rtl,
        style: TextStyle(color: P.dim, fontSize: 13)),
      const SizedBox(height: 60),
      _roundButton('PRESS', size: 130, onTap: _tap),
    ]));
  }
}

// ═══ المرحلة 25 — العد التنازلي للفشل ═══
class _Stage25 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage25({required this.onWin, required this.onFail});
  @override
  State<_Stage25> createState() => _Stage25State();
}
class _Stage25State extends State<_Stage25> {
  double _timeLeft = 2.0;
  Timer? _t;
  bool _done = false;
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (!mounted || _done) return;
      setState(() => _timeLeft -= 0.03);
      if (_timeLeft <= 0) { t.cancel(); if (!_done) { HapticFeedback.heavyImpact(); widget.onFail(); } }
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_timeLeft.toStringAsFixed(1), style: TextStyle(color: _timeLeft < 0.8 ? P.rare : P.mid, fontSize: 60, letterSpacing: 4)),
      const SizedBox(height: 20),
      LinearProgressIndicator(value: (_timeLeft / 2.0).clamp(0.0, 1.0),
        backgroundColor: const Color(0xFF1A1A1A),
        valueColor: const AlwaysStoppedAnimation(P.rare), minHeight: 6),
      const SizedBox(height: 60),
      _roundButton('PRESS', size: 130, onTap: () {
        if (_done) return;
        _done = true;
        _t?.cancel();
        HapticFeedback.mediumImpact();
        widget.onWin();
      }),
    ])));
  }
}

// ═══ المرحلة 26 — المرايا المتعددة ═══
class _Stage26 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage26({required this.onWin, required this.onFail});
  @override
  State<_Stage26> createState() => _Stage26State();
}
class _Stage26State extends State<_Stage26> {
  final _rng = Random();
  int _moving = 0;
  final List<Offset> _offsets = List.generate(5, (_) => Offset.zero);
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _moving = _rng.nextInt(5);
    _t = Timer.periodic(const Duration(milliseconds: 1400), (t) {
      if (!mounted) return;
      setState(() {
        _offsets[_moving] = Offset.zero;
        _moving = _rng.nextInt(5);
        _offsets[_moving] = Offset((_rng.nextDouble() - 0.5) * 60, (_rng.nextDouble() - 0.5) * 60);
      });
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center,
      children: List.generate(5, (i) {
        final isMoving = i == _moving;
        return Transform.translate(offset: _offsets[i],
          child: _roundButton('PRESS', size: 75,
            color: isMoving ? P.rare : null,
            onTap: () {
              if (isMoving) { HapticFeedback.mediumImpact(); widget.onWin(); }
              else { HapticFeedback.heavyImpact(); widget.onFail(); }
            }));
      })));
  }
}

// ═══ المرحلة 27 — الكمين ═══
class _Stage27 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage27({required this.onWin, required this.onFail});
  @override
  State<_Stage27> createState() => _Stage27State();
}
class _Stage27State extends State<_Stage27> {
  final _rng = Random();
  int _target = 0;
  int _streak = 0;
  int _needed = 5;
  @override
  void initState() { super.initState(); _target = _rng.nextInt(4); }
  void _press(int i) {
    if (i == _target) {
      HapticFeedback.lightImpact();
      setState(() { _streak++; _target = _rng.nextInt(4); });
      if (_streak >= _needed) { HapticFeedback.mediumImpact(); widget.onWin(); }
    } else {
      HapticFeedback.heavyImpact();
      widget.onFail();
      setState(() { _streak = 0; _target = _rng.nextInt(4); });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('$_streak / $_needed', style: const TextStyle(color: P.mid, fontSize: 32, letterSpacing: 4)),
      const SizedBox(height: 30),
      Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
        children: List.generate(4, (i) => _roundButton(
          i == _target ? '●' : 'PRESS', size: 80,
          color: i == _target ? P.rare : null,
          onTap: () => _press(i)))),
    ]));
  }
}

// ═══ المرحلة 28 — الحبل ═══
class _Stage28 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage28({required this.onWin, required this.onFail});
  @override
  State<_Stage28> createState() => _Stage28State();
}
class _Stage28State extends State<_Stage28> {
  double _opacity = 1.0;
  Timer? _t;
  bool _done = false;
  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (!mounted || _done) return;
      setState(() => _opacity -= 0.03);
      if (_opacity <= 0) { t.cancel(); if (!_done) { HapticFeedback.heavyImpact(); widget.onFail(); } }
    });
  }
  @override
  void dispose() { _t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Center(child: Opacity(opacity: _opacity.clamp(0.0, 1.0), child: Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('اضغط قبل ما تختفي', textDirection: TextDirection.rtl,
        style: const TextStyle(color: P.dim, fontSize: 14)),
      const SizedBox(height: 40),
      _roundButton('PRESS', size: 130, onTap: () {
        if (_done) return;
        _done = true;
        _t?.cancel();
        HapticFeedback.mediumImpact();
        widget.onWin();
      }),
    ])));
  }
}

// ═══ المرحلة 29 — الاسم ═══
class _Stage29 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage29({required this.onWin, required this.onFail});
  @override
  State<_Stage29> createState() => _Stage29State();
}
class _Stage29State extends State<_Stage29> {
  final _ctrl = TextEditingController();
  String _name = '';
  bool _submitted = false;
  final _rng = Random();
  late List<bool> _isYou;
  @override
  void initState() {
    super.initState();
    _isYou = List.generate(4, (_) => false);
    _isYou[_rng.nextInt(4)] = true;
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  void _submit() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() { _name = _ctrl.text.trim(); _submitted = true; });
  }
  void _press(int i) {
    if (_isYou[i]) { HapticFeedback.mediumImpact(); widget.onWin(); }
    else { HapticFeedback.heavyImpact(); widget.onFail(); }
  }
  @override
  Widget build(BuildContext context) {
    if (!_submitted) {
      return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('اكتب اسمك', textDirection: TextDirection.rtl,
          style: TextStyle(color: P.white, fontSize: 18)),
        const SizedBox(height: 30),
        TextField(
          controller: _ctrl, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
          style: const TextStyle(color: P.white, fontSize: 22),
          decoration: const InputDecoration(
            hintText: '...', hintStyle: TextStyle(color: P.dim),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: P.dim)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: P.mid)),
          ),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 30),
        _roundButton('ادخل', size: 90, onTap: _submit),
      ])));
    }
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('اضغط على اسمك', textDirection: TextDirection.rtl,
        style: const TextStyle(color: P.dim, fontSize: 14)),
      const SizedBox(height: 40),
      Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
        children: List.generate(4, (i) {
          final label = _isYou[i] ? _name : _fakeName();
          return _roundButton(label, size: 90, onTap: () => _press(i));
        })),
    ]));
  }
  String _fakeName() {
    const pool = ['أحمد', 'سارة', 'محمد', 'نور', 'ياسمين', 'علي', 'ليلى', 'خالد'];
    return pool[_rng.nextInt(pool.length)];
  }
}

// ═══ المرحلة 30 — الباب الأخير ═══
class _Stage30 extends StatefulWidget {
  final VoidCallback onWin, onFail;
  const _Stage30({required this.onWin, required this.onFail});
  @override
  State<_Stage30> createState() => _Stage30State();
}
class _Stage30State extends State<_Stage30> {
  int _count = 0;
  bool _done = false;
  final List<String> _messages = [
    'افتح...',
    'افتح... أرجوك...',
    'خلاص.',
  ];
  void _tap() {
    if (_done) return;
    HapticFeedback.heavyImpact();
    setState(() => _count++);
    if (_count >= 3) {
      _done = true;
      HapticFeedback.vibrate();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) widget.onWin();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (_count > 0)
        Text(_messages[(_count - 1).clamp(0, _messages.length - 1)],
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: P.rare, fontSize: 20, letterSpacing: 2)),
      const SizedBox(height: 40),
      _roundButton('PRESS', size: 150, onTap: _tap),
      const SizedBox(height: 20),
      Text('$_count / 3', style: const TextStyle(color: P.dim, fontSize: 14)),
    ]));
  }
}
// ═══ شاشة GAME OVER ═══
class _GameOverScreen extends StatelessWidget {
  final Stage stage;
  final int score;
  final VoidCallback onRetry;
  final VoidCallback onRestart;
  const _GameOverScreen({required this.stage, required this.score, required this.onRetry, required this.onRestart});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: P.bg, body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('GAME OVER', style: TextStyle(color: P.rare, fontSize: 32, letterSpacing: 6, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        Text('فشلت في: ${stage.title}', textDirection: TextDirection.rtl, style: const TextStyle(color: P.white, fontSize: 16)),
        const SizedBox(height: 8),
        Text('نقاطك: $score', textDirection: TextDirection.rtl, style: const TextStyle(color: P.dim, fontSize: 14)),
        const SizedBox(height: 40),
        _actionButton('أعد المرحلة', onRetry),
        const SizedBox(height: 16),
        _actionButton('من البداية', onRestart),
      ])))));
  }
}

// ═══ شاشة النهاية ═══
class _EndingScreen extends StatelessWidget {
  final String title;
  final String body;
  final int code;
  final int score;
  final VoidCallback onRestart;
  const _EndingScreen({required this.title, required this.body, required this.code, required this.score, required this.onRestart});
  @override
  Widget build(BuildContext context) {
    final Color c;
    switch (code) {
      case 1: c = const Color(0xFF44AA44); break;
      case 2: c = const Color(0xFFAA8833); break;
      default: c = P.rare;
    }
    return Scaffold(backgroundColor: P.bg, body: SafeArea(child: Center(child: Padding(padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('ENDING // ${code.toString().padLeft(2, '0')}',
            style: TextStyle(color: c, fontSize: 14, letterSpacing: 6, fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        Text(title, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
            style: TextStyle(color: c, fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        Text(body, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
            style: const TextStyle(color: P.white, fontSize: 15, height: 1.9)),
        const SizedBox(height: 32),
        Text('النقاط النهائية: $score', style: TextStyle(color: c, fontSize: 14, letterSpacing: 2)),
        const SizedBox(height: 40),
        _actionButton('العب مرة تانية', onRestart),
      ])))));
  }
}