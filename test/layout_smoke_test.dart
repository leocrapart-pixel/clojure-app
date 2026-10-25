import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/cljd-out/clojure-app/ui.dart' as ui;

/// Rend l'écran complet à une taille donnée et vérifie qu'aucune exception
/// de mise en page (débordement, contrainte infinie...) n'est levée.
Future<void> pumpAt(WidgetTester tester, double width, double height) async {
  tester.view.devicePixelRatio = 2.0;
  tester.view.physicalSize = Size(width * 2.0, height * 2.0);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(MaterialApp(home: ui.preview() as Widget));
  await tester.pump(const Duration(milliseconds: 200));

  expect(tester.takeException(), isNull, reason: 'rendu $width×$height');
}

void main() {
  testWidgets('l’écran se rend sur un téléphone', (tester) async {
    await pumpAt(tester, 390.0, 844.0);
    expect(find.textContaining('Vénus'), findsWidgets);
  });

  testWidgets('l’écran se rend sur un petit téléphone', (tester) async {
    await pumpAt(tester, 320.0, 640.0);
  });

  testWidgets('l’écran se rend sur un écran large', (tester) async {
    await pumpAt(tester, 1280.0, 800.0);
  });
}
