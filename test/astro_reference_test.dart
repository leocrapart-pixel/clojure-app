import 'package:flutter_test/flutter_test.dart';

import '../lib/cljd-out/clojure-app/astro.dart' as astro;
import '../lib/cljd-out/clojure-app/cycle.dart' as cyc;

/// Jour julien d'un instant UTC.
double jdOf(int y, int m, int d, int h, int min) =>
    DateTime.utc(y, m, d, h, min).millisecondsSinceEpoch / 86400000.0 + 2440587.5;

void main() {
  // Valeurs publiées par voyage-de-venus.pages.dev pour le 25/10/2026 08:25 UTC.
  final jd = jdOf(2026, 10, 25, 8, 25);

  test('positions de référence du 25 octobre 2026', () {
    final elong = astro.elongation(jd) as num;
    final sun = astro.sun_lon(jd) as num;
    final moon = astro.moon_lon(jd) as num;

    expect(elong.toDouble(), closeTo(-1.9, 0.3),
        reason: 'élongation de Vénus');
    expect(sun.toDouble(), closeTo(211.94, 0.3), reason: 'longitude du Soleil');
    expect(moon.toDouble(), closeTo(21.0, 0.5), reason: 'longitude de la Lune');
  });

  test('Vénus est bien à 0°1′ du Scorpion', () {
    final lon = astro.venus_lon(jd) as num;
    final lat = astro.venus_lat(jd) as num;

    expect(lon.toDouble(), closeTo(210.0, 0.3), reason: 'longitude de Vénus');
    expect(lat.toDouble(), closeTo(-6.3, 0.3), reason: 'latitude de Vénus');
    expect(cyc.fmt_lon(lon) as String, startsWith('0°'));
  });

  test('le cycle encadre bien le 25 octobre 2026', () {
    final start = (cyc.cycle_start(jd) as num).toDouble();
    final end = (cyc.cycle_end(jd) as num).toDouble();
    final length = (cyc.cycle_length_of(jd) as num).toDouble();

    // Cycle attendu : 24/10/2026 -> 01/06/2028, soit 586 jours.
    expect(cyc.fmt_date(start) as String, contains('2026'));
    expect(cyc.fmt_date(end) as String, contains('2028'));
    expect(length, closeTo(586.0, 3.0));
    expect(start, lessThanOrEqualTo(jd));
    expect(end, greaterThan(jd));
  });

  test('un portail suit le moment observé', () {
    final portalJd = (cyc.next_portal_jd(jd) as num).toDouble();
    final date = cyc.fmt_date(portalJd) as String;

    // Les portails sont les conjonctions Vénus-Lune : la suivante tombe
    // quelques semaines plus tard, dans la même année.
    expect(portalJd, greaterThan(jd));
    expect(portalJd - jd, lessThan(60.0));
    expect(date, contains('2026'));
  });
}
