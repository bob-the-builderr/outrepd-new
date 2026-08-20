import 'package:flutter/material.dart';

import '../data.dart';
import '../onboarding_widgets.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';
import 'shell.dart';

/// The personalised setup questionnaire — 18 steps, mirroring the original
/// OUTREPD flow. Answers are kept locally and applied to [demoProfile].
class UserOnboardingScreen extends StatefulWidget {
  const UserOnboardingScreen({super.key});

  @override
  State<UserOnboardingScreen> createState() => _UserOnboardingScreenState();
}

class _UserOnboardingScreenState extends State<UserOnboardingScreen> {
  static const _totalSteps = 18;

  int _step = 0;

  // Collected answers
  final _usernameController = TextEditingController();
  String? _experience;
  String? _goal;
  String? _gender;
  int _age = 25;
  int _weight = 80;
  bool _weightKg = true;
  int _height = 175;
  bool _heightCm = true;
  String? _thinkShape;
  String? _energy;
  bool? _relateProgress;
  bool? _relateRoutine;

  // Steps that reveal their button only after the typing animation ends.
  bool _typingDone = false;

  /// Which way the last move went, so the slide runs the right way round.
  bool _goingBack = false;

  /// Set when a typed number is outside what a person can be. Cleared the
  /// moment they edit the field — an error that lingers after the fix reads
  /// as the app not noticing.
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _next() {
    final complaint = _validate(L.of(context));
    if (complaint != null) {
      setState(() => _error = complaint);
      return;
    }
    if (_step >= _totalSteps - 1) {
      _finish();
      return;
    }
    setState(() {
      _step++;
      _typingDone = false;
      _goingBack = false;
      _error = null;
    });
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      _step--;
      _typingDone = true; // going back, don't re-gate on typing
      _goingBack = true;
      _error = null;
    });
  }

  /// Age, weight and height come from wheels and rulers with their own limits,
  /// so nobody can type 700 kg in the first place. The one field a person can
  /// put anything into is the name, and a Continue button that simply goes
  /// dead tells them nothing about why.
  String? _validate(L l) {
    if (_step != 0) return null;
    final name = _usernameController.text.trim();
    return name.length >= 3 ? null : l.nameTooShortInline;
  }

  Future<void> _finish() async {
    final name = _usernameController.text.trim();
    if (name.isNotEmpty) demoProfile.username = name;
    demoProfile.age = _age;
    demoProfile.weightKg = _weightKg ? _weight : (_weight * 0.4536).round();
    demoProfile.heightCm = _heightCm ? _height : (_height * 2.54).round();
    await saveProfileStats();
    // Somebody answered twelve questions about themselves. Throwing that away
    // the moment the flow ends is the reason people resent onboarding.
    await saveOnboardingAnswers({
      'experience': _experience,
      'goal': _goal,
      'gender': _gender,
      'thinkShape': _thinkShape,
      'energy': _energy,
      'relateProgress': _relateProgress?.toString(),
      'relateRoutine': _relateRoutine?.toString(),
    });

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (_) => false,
    );
  }

  /// What each answer is for. Steps that need no explanation return null and
  /// the line simply is not drawn.
  String? _whyWeAsk(L l) => switch (_step) {
    0 => l.whyName,
    1 => l.whyExperience,
    2 => l.whyGoal,
    5 => l.whyAge,
    6 => l.whyWeight,
    7 => l.whyHeight,
    10 || 11 => l.whyHabits,
    _ => null,
  };

  bool get _canProceed => switch (_step) {
    // Deliberately live: a dead button explains nothing, so the tap is
    // allowed through and _validate says what is wrong.
    0 => true,
    1 => _experience != null,
    2 => _goal != null,
    4 => _gender != null,
    8 || 9 || 14 || 15 || 16 => _typingDone,
    10 => _thinkShape != null,
    11 => _energy != null,
    12 => _relateProgress != null,
    13 => _relateRoutine != null,
    _ => true,
  };

  @override
  Widget build(BuildContext context) {
    // The commitment (3) and success (17) steps supply their own controls.
    final showFooter = _step != 3 && _step != 17;
    final hideProgress = _step >= 14 && _step <= 16;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        actions: [
          TextButton(
            onPressed: _finish,
            child: Text(
              L.of(context).skip,
              style: TextStyle(color: context.colors.muted),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (showFooter && !hideProgress)
              OnboardingProgress(step: _step, totalSteps: _totalSteps),
            Expanded(
              // A question and three answers are shorter than a phone, and
              // top-anchoring them left the bottom half of every step empty.
              // Centring costs nothing and the void goes away.
              child: LayoutBuilder(
                builder: (context, box) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: box.maxHeight - 32),
                    // Full width, centred vertically. A bare Center would
                    // shrink-wrap the column to its widest line, and then
                    // everything narrower than the heading — the logo ring
                    // most visibly — centres against that line instead of
                    // against the screen, and sits a few pixels off.
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        // Steps slide in from the leading edge, so moving forward and
                        // moving back look different — otherwise a wrong answer and
                        // its correction feel like the same event.
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: Offset(
                                        _goingBack ? -0.06 : 0.06,
                                        0,
                                      ),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                          child: KeyedSubtree(
                            key: ValueKey(_step),
                            child: _buildStep(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (showFooter)
              OnboardingFooter(
                step: _step,
                totalSteps: _totalSteps,
                canProceed: _canProceed,
                showProgress: false,
                why: _whyWeAsk(L.of(context)),
                onNext: _next,
                label: _step == _totalSteps - 2
                    ? L.of(context).finish2
                    : L.of(context).continueLabel,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() => switch (_step) {
    0 => _usernameStep(),
    1 => _choiceStep(
      L.of(context).qExperience,
      [
        ('none', L.of(context).expNone),
        ('beginner', L.of(context).expBeginner),
        ('intermediate', L.of(context).expIntermediate),
        ('advanced', L.of(context).expAdvanced),
      ],
      _experience,
      (v) => setState(() => _experience = v),
    ),
    2 => _choiceStep(
      L.of(context).qGoal,
      [
        ('stronger', L.of(context).goalStronger),
        ('consistent', L.of(context).goalConsistent),
        ('lean', L.of(context).goalLean),
        ('mass', L.of(context).goalMass),
      ],
      _goal,
      (v) => setState(() => _goal = v),
    ),
    3 => _commitmentStep(),
    4 => _genderStep(),
    5 => _ageStep(),
    6 => _weightStep(),
    7 => _heightStep(),
    8 => _transitionStep(L.of(context).aboutYou),
    9 => _transitionStep(L.of(context).transitionPartOfIt),
    10 => _choiceStep(
      L.of(context).qThinkAbout,
      [
        ('never', L.of(context).freqNever),
        ('sometimes', L.of(context).freqSometimes),
        ('often', L.of(context).freqOften),
        ('all_time', L.of(context).freqAllTime),
      ],
      _thinkShape,
      (v) => setState(() => _thinkShape = v),
    ),
    11 => _choiceStep(
      L.of(context).qEnergy,
      [
        ('low', L.of(context).energyLow),
        ('drops', L.of(context).energyDrops),
        ('hard', L.of(context).energyHard),
        ('high', L.of(context).energyHigh),
      ],
      _energy,
      (v) => setState(() => _energy = v),
    ),
    12 => _statementStep(
      L.of(context).stProgress,
      _relateProgress,
      (v) => setState(() => _relateProgress = v),
    ),
    13 => _statementStep(
      L.of(context).stRoutine,
      _relateRoutine,
      (v) => setState(() => _relateRoutine = v),
    ),
    14 => _imageStep(
      'assets/images/effort-alone.png',
      L.of(context).stEffortTitle,
      L.of(context).stEffortBody,
    ),
    15 => _imageStep(
      'assets/images/training-alone.png',
      L.of(context).stAloneTitle,
      L.of(context).stAloneBody,
    ),
    16 => _rivalStep(),
    _ => _successStep(),
  };

  // ---------------------------------------------------------------- steps

  Widget _usernameStep() {
    return Column(
      children: [
        const SizedBox(height: 24),
        StepHeading(title: L.of(context).qName),
        const SizedBox(height: 40),
        TextField(
          controller: _usernameController,
          // Clearing the error on the first keystroke, not on the next tap of
          // Continue, is what makes it feel like the app is watching.
          onChanged: (_) => setState(() => _error = null),
          textAlign: TextAlign.center,
          style: context.type.title.copyWith(color: context.colors.text),
          decoration: InputDecoration(
            hintText: L.of(context).usernamePlaceholder,
            hintStyle: const TextStyle(color: Color(0xFF444444)),
            filled: true,
            fillColor: const Color(0xFF111111),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF444444), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.colors.brand, width: 2.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _error ?? L.of(context).nameHint,
          textAlign: TextAlign.center,
          style: context.type.label.copyWith(color: _error == null ? context.colors.muted : AppColors.loss),
        ),
      ],
    );
  }

  Widget _choiceStep(
    String title,
    List<(String, String)> options,
    String? selected,
    ValueChanged<String> onSelect,
  ) {
    return Column(
      children: [
        const SizedBox(height: 24),
        StepHeading(title: title),
        const SizedBox(height: 36),
        ...options.map(
          (o) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: OptionCard(
              label: o.$2,
              selected: selected == o.$1,
              onTap: () => onSelect(o.$1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _commitmentStep() => _CommitmentStep(onComplete: _next);

  Widget _genderStep() {
    Widget card(String key, IconData icon, String label) {
      final selected = _gender == key;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _gender = key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? context.colors.brand
                    : const Color(0xFF444444),
                width: 2.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 64, color: context.colors.brand),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: context.type.heading.copyWith(color: selected
                        ? context.colors.text
                        : const Color(0xFFBBBBBB)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        StepHeading(
          title: L.of(context).basicInfo,
          subtitle: L.of(context).iAm,
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            card('male', Icons.male, L.of(context).male),
            const SizedBox(width: 16),
            card('female', Icons.female, L.of(context).female),
          ],
        ),
      ],
    );
  }

  Widget _ageStep() {
    return Column(
      children: [
        const SizedBox(height: 24),
        StepHeading(title: L.of(context).qAge),
        const SizedBox(height: 32),
        SizedBox(
          height: 240,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 64,
            perspective: 0.004,
            diameterRatio: 1.8,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(initialItem: _age - 13),
            onSelectedItemChanged: (i) => setState(() => _age = 13 + i),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 88, // 13 – 100
              builder: (context, i) {
                final value = 13 + i;
                final selected = value == _age;
                return Center(
                  child: Text(
                    localNumber(context, value),
                    style: TextStyle(
                      color: selected
                          ? context.colors.brand
                          : context.colors.muted,
                      fontSize: selected ? 42 : 26,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _weightStep() {
    return Column(
      children: [
        const SizedBox(height: 24),
        StepHeading(title: L.of(context).qWeight),
        const SizedBox(height: 12),
        Text(
          L.of(context).weightWhy,
          textAlign: TextAlign.center,
          style: context.type.label.copyWith(color: context.colors.muted),
        ),
        const SizedBox(height: 24),
        UnitToggle(
          left: L.of(context).shortKg,
          right: L.of(context).shortLb,
          leftSelected: _weightKg,
          onChanged: (kg) => setState(() {
            if (kg == _weightKg) return;
            _weight = kg
                ? (_weight * 0.4536).round()
                : (_weight / 0.4536).round();
            _weightKg = kg;
          }),
        ),
        const SizedBox(height: 28),
        RulerPicker(
          key: ValueKey('weight-$_weightKg'),
          min: _weightKg ? 35 : 77,
          max: _weightKg ? 200 : 440,
          value: _weight,
          unitLabel: _weightKg ? L.of(context).shortKg : L.of(context).shortLb,
          onChanged: (v) => setState(() => _weight = v),
        ),
        const SizedBox(height: 20),
        Text(
          L.of(context).privateNote,
          textAlign: TextAlign.center,
          style: context.type.label.copyWith(color: Color(0xFF556070)),
        ),
      ],
    );
  }

  Widget _heightStep() {
    return Column(
      children: [
        const SizedBox(height: 24),
        StepHeading(title: L.of(context).qHeight),
        const SizedBox(height: 24),
        UnitToggle(
          left: L.of(context).shortCm,
          right: L.of(context).shortIn,
          leftSelected: _heightCm,
          onChanged: (cm) => setState(() {
            if (cm == _heightCm) return;
            _height = cm ? (_height * 2.54).round() : (_height / 2.54).round();
            _heightCm = cm;
          }),
        ),
        const SizedBox(height: 28),
        RulerPicker(
          key: ValueKey('height-$_heightCm'),
          min: _heightCm ? 130 : 51,
          max: _heightCm ? 220 : 87,
          value: _height,
          unitLabel: _heightCm ? L.of(context).shortCm : L.of(context).shortIn,
          onChanged: (v) => setState(() => _height = v),
        ),
      ],
    );
  }

  Widget _transitionStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: TypewriterText(
        text: text,
        onComplete: () => setState(() => _typingDone = true),
        style: context.type.statValue.copyWith(color: context.colors.text, height: 1.35),
      ),
    );
  }

  Widget _statementStep(
    String statement,
    bool? selected,
    ValueChanged<bool> onSelect,
  ) {
    Widget answer(String label, bool value, Color color) {
      final active = selected == value;
      return Expanded(
        child: GestureDetector(
          onTap: () => onSelect(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active
                  ? color.withValues(alpha: 0.15)
                  : const Color(0xFF111111),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: active ? color : const Color(0xFF444444),
                width: 2.5,
              ),
            ),
            child: Text(
              label,
              style: context.type.heading.copyWith(color: active ? color : const Color(0xFFDDDDDD)),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        StepHeading(title: L.of(context).qRelate),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.colors.surfaceRaised),
          ),
          child: Text(
            '"$statement"',
            textAlign: TextAlign.center,
            style: context.type.heading.copyWith(color: context.colors.text, height: 1.45, fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            answer(L.of(context).yes, true, context.colors.brand),
            const SizedBox(width: 14),
            answer(L.of(context).no, false, context.colors.muted),
          ],
        ),
      ],
    );
  }

  Widget _imageStep(String asset, String headline, String subtext) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Image.asset(asset, height: 260, fit: BoxFit.contain),
        const SizedBox(height: 28),
        TypewriterText(
          text: headline,
          onComplete: () => setState(() => _typingDone = true),
          style: context.type.statValue.copyWith(color: context.colors.text, height: 1.25),
        ),
        const SizedBox(height: 14),
        Text(
          subtext,
          textAlign: TextAlign.center,
          style: context.type.heading.copyWith(color: Color(0xFF888888), height: 1.5),
        ),
      ],
    );
  }

  Widget _rivalStep() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Image.asset('assets/images/workout-battle.png', height: 220),
          const SizedBox(height: 32),
          Text(
            L.of(context).grindTitle,
            textAlign: TextAlign.center,
            style: context.type.statValue.copyWith(color: context.colors.text, height: 1.3),
          ),
          const SizedBox(height: 16),
          TypewriterText(
            text: L.of(context).grindBody,
            onComplete: () => setState(() => _typingDone = true),
            style: context.type.heading.copyWith(color: Color(0xFF888888), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _successStep() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Image.asset('assets/images/logo.png', height: 140),
          const SizedBox(height: 28),
          Text(
            L.of(context).allSet,
            textAlign: TextAlign.center,
            style: context.type.statValue.copyWith(color: context.colors.text),
          ),
          const SizedBox(height: 12),
          Text(
            L
                .of(context)
                .welcomeLifter(
                  _usernameController.text.trim().isEmpty
                      ? L.of(context).lifter
                      : _usernameController.text.trim(),
                ),
            textAlign: TextAlign.center,
            style: context.type.heading.copyWith(color: Color(0xFF888888), height: 1.5),
          ),
          const SizedBox(height: 40),
          FilledButton(onPressed: _finish, child: Text(L.of(context).enterApp)),
        ],
      ),
    );
  }
}

/// Hold-the-logo confirmation. Releasing early resets the ring.
class _CommitmentStep extends StatefulWidget {
  const _CommitmentStep({required this.onComplete});
  final VoidCallback onComplete;

  @override
  State<_CommitmentStep> createState() => _CommitmentStepState();
}

class _CommitmentStepState extends State<_CommitmentStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onComplete();
      });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        StepHeading(title: L.of(context).commitTitle),
        const SizedBox(height: 56),
        GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 6,
                        backgroundColor: context.colors.surfaceRaised,
                        valueColor: AlwaysStoppedAnimation(
                          context.colors.brand,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1 + _controller.value * 0.08,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 132,
                        height: 132,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        Text(
          L.of(context).holdLogo,
          textAlign: TextAlign.center,
          style: context.type.heading.copyWith(color: Color(0xFF888888)),
        ),
      ],
    );
  }
}
