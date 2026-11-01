/// Why there are about to be ads, said once, just before the first: as the
/// last ad-free game's result is left, on an iPhone, ahead of Apple's own
/// tracking question so that question does not arrive cold.
///
/// Continue goes on to Apple's question. Nothing here is a reward for
/// answering either way, and the button does not say Allow — Apple asks for
/// both (App Review 5.1.2). Pro is not offered here any more: it has its own
/// button beside the bell and in Settings (the user's call, 2026-11-01).
library;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';

/// Pops when Continue is pressed, or on back.
class AdAskScreen extends StatelessWidget {
  const AdAskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;

    return PopScope(
      // Back is Continue: the question still has to be put.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(false);
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: box.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.surfaceRaised,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.brand.withValues(alpha: 0.18),
                                  blurRadius: 50,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.shield_outlined,
                              size: 60,
                              color: colors.brand,
                            ),
                          ),
                          const SizedBox(height: 34),
                          Text(
                            l.adAskTitle,
                            key: const Key('adAskTitle'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 30,
                              height: 1.18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l.adAskBody,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.muted,
                              fontSize: 16,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 26),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: colors.border,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              l.adAskCamera,
                              style: TextStyle(
                                color: colors.muted,
                                fontSize: 14.5,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        key: const Key('adAskContinue'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.brand,
                          foregroundColor: colors.background,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          l.continueLabel,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
