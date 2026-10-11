/// How close the camera gets, measured against the lifter.
///
/// The one screen in the app that is about the app rather than about training.
/// It exists because the counter's accuracy was argued about for months
/// without ever being a number anybody could look at — and because the data
/// to answer it was already being collected and thrown into a running total.
///
/// Four figures rather than one. "87% accurate" is the kind of number that
/// ends an investigation; exact on 87%, within one rep on 96%, half a rep
/// biased high, worst miss four — that tells somebody what to go and fix.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../reps/count_accuracy.dart';
import '../theme.dart';
import '../widgets.dart';

class CounterAccuracyScreen extends StatelessWidget {
  const CounterAccuracyScreen({super.key, this.samples});

  /// The sets to describe. Defaults to this device's record; the preview route
  /// hands it a made-up one, because the populated screen is the one worth
  /// looking at and a fresh browser has never counted anything.
  final List<CountSample>? samples;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final sets = samples ?? countSamples;
    final report = AccuracyReport.of(sets);
    final needed = math.max(0, kMinimumUsefulSamples - sets.length);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l.counterAccuracy)),
      body: report.empty
          ? EmptyState(
              icon: Icons.straighten,
              title: l.accNothingYet,
              body: l.accNothingYetBody,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 28),
              children: [
                Text(
                  l.measuredOverSets(localNumber(context, report.sets)),
                  style: TextStyle(color: context.colors.muted, fontSize: 14),
                ),
                if (needed > 0) ...[
                  const SizedBox(height: 8),
                  // Said out loud rather than hidden. A screen that shows
                  // "100% exact" after two sets invites exactly the wrong
                  // conclusion, and the person reading it is the one who will
                  // act on it.
                  _Note(l.accNeedMore(localNumber(context, needed))),
                ],

                const SizedBox(height: 14),
                // The pair has to agree on a height or the cards sit at
                // different sizes with the same kind of number in them, which
                // reads as one mattering more. Stretch alone cannot do it in a
                // list — nothing there has a height to stretch to.
                _Pair(
                  left: _Figure(
                    label: l.accExact,
                    value: '${localNumber(context, percent(report.exactRate))}%',
                    highlight: true,
                  ),
                  right: _Figure(
                    label: l.accWithinOne,
                    value:
                        '${localNumber(context, percent(report.withinOneRate))}%',
                  ),
                ),
                const SizedBox(height: 7),
                _Pair(
                  left: _Figure(
                    label: l.accAverageMiss,
                    value: reps(report.meanAbsoluteError),
                    unit: l.reps,
                  ),
                  right: _Figure(
                    label: l.accWorstMiss,
                    value: localNumber(context, report.worst.abs()),
                    unit: l.reps,
                  ),
                ),

                const SizedBox(height: 7),
                _Bias(report: report),

                const SizedBox(height: 20),
                Text(
                  l.accRecentSets.toUpperCase(),
                  style: TextStyle(
                    color: context.colors.muted,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 9),
                for (final sample in sets.reversed.take(15))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _SampleRow(sample: sample),
                  ),

                const SizedBox(height: 14),
                _Note(l.accHowItWorks),
              ],
            ),
    );
  }
}

/// A record to look at in the web preview, where nobody has done a push-up.
///
/// Deliberately unflattering: a couple of bad misses among the exact ones, so
/// the screen gets reviewed as it will look on a real phone rather than as a
/// column of hundreds.
List<CountSample> demoAccuracySamples() {
  final now = DateTime.now();
  const errors = [0, 0, 1, 0, -1, 0, 0, 3, 0, 0, -1, 0, 0, -4, 0, 1, 0];
  const lifter = [12, 9, 15, 11, 8, 14, 10, 13, 7, 16, 11, 9, 12, 18, 10, 13, 8];
  return [
    for (var i = 0; i < errors.length; i++)
      CountSample(
        camera: lifter[i] + errors[i],
        lifter: lifter[i],
        at: now.subtract(Duration(hours: (errors.length - i) * 7)),
      ),
  ];
}

/// Two cards side by side, the same height as each other.
class _Pair extends StatelessWidget {
  const _Pair({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: 7),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: child,
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    this.unit,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String? unit;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scaled to fit rather than ShrinkText: the pair above measures its
          // children's height to make the two cards agree, and a LayoutBuilder
          // cannot answer that question. This can, and it never clips.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: highlight
                          ? context.colors.brand
                          : context.colors.text,
                      fontSize: 26,
                      height: 1.2,
                    ),
                  ),
                  if (unit case final unit?)
                    TextSpan(
                      text: ' $unit',
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Which way it is wrong, which matters as much as by how much.
class _Bias extends StatelessWidget {
  const _Bias({required this.report});

  final AccuracyReport report;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final bias = report.bias;

    // Under a tenth of a rep either way is not a lean, it is rounding.
    final direction = bias.abs() < 0.1
        ? l.accCountsEven
        : bias > 0
            ? l.accCountsHigh
            : l.accCountsLow;
    final colour = bias.abs() < 0.1
        ? context.colors.muted
        : bias > 0
            ? context.colors.rival
            : context.colors.brand;

    return _Card(
      child: Row(
        children: [
          Expanded(
            child: Text(
              l.accTendsTo,
              style: TextStyle(color: context.colors.muted, fontSize: 14),
            ),
          ),
          Flexible(
            child: ShrinkText(
              bias.abs() < 0.1
                  ? direction
                  : '$direction · ${reps(bias)}',
              maxLines: 1,
              style: TextStyle(color: colour, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _SampleRow extends StatelessWidget {
  const _SampleRow({required this.sample});

  final CountSample sample;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colour =
        sample.exact ? context.colors.brand : context.colors.rival;

    return _Card(
      child: Row(
        children: [
          Container(
            width: 5,
            height: 22,
            decoration: BoxDecoration(
              color: colour,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${l.accCameraSaid} ${localNumber(context, sample.camera)}'
              '  ·  ${l.accYouSaid} ${localNumber(context, sample.lifter)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.colors.text, fontSize: 14),
            ),
          ),
          Text(
            sample.exact
                ? localNumber(context, 0)
                : '${sample.error > 0 ? '+' : '−'}'
                    '${localNumber(context, sample.error.abs())}',
            style: TextStyle(color: colour, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: context.colors.faint,
        fontSize: 13,
        height: 1.6,
      ),
    );
  }
}
