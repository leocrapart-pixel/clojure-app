# clojure-app — Le Voyage de Vénus

Une application **ClojureDart + Flutter** qui reprend l'allure et les données de
[voyage-de-venus.pages.dev](https://voyage-de-venus.pages.dev) : le cycle
synodique de Vénus, ses portails, la descente des sept chakras et l'inframonde.

Tout est calculé dans l'application, hors ligne : aucune requête réseau, aucune
donnée précalculée.

## Ce que fait l'application

- **Prochain portail** : la prochaine conjonction Vénus–Lune, son degré zodiacal
  et le nom de la porte.
- **Moment observé** : la date courante, avec des boutons −1 j, +1 j, +7 j,
  +30 j et retour à aujourd'hui.
- **Cycle en cours** : les conjonctions inférieure, supérieure et inférieure
  qui bornent le cycle synodique.
- **Le cycle en un tour** : bande de progression avec les seize portails.
- **Lecture du ciel** : phase, élongation, longitude et latitude de Vénus,
  mouvement, Lune du jour, fenêtre d'inframonde.
- **Les vêtements d'Inanna** : les sept centres, du sommet à la racine ; on
  touche un centre pour lire le vêtement et la date de la porte.
- **Inframonde** : les trois jours autour de la conjonction supérieure.

## Éphéméride

| Grandeur | Source | Précision |
|---|---|---|
| Vénus (géocentrique, tropicale) | série VSOP87 tronquée (Terre + Vénus), précession générale en longitude | ≲ 1′ |
| Lune | Meeus, *Astronomical Algorithms*, ch. 47 (termes principaux) | ≲ 0,2° |
| Conjonctions / portails | recherche de zéro par bissection sur les longitudes | quelques heures |

Les séries VSOP sont reprises du paquet MIT
[`astronomy-engine`](https://github.com/cosinekitty/astronomy) ; elles-mêmes
dérivées de VSOP87 (Bretagnon & Francou).

Vérification effectuée sur le 25 octobre 2026 à 08:25 UTC : Vénus à 0°1′ du
Scorpion, latitude −6,3°, élongation −1,9° — valeurs identiques à celles du site
de référence.

## Vérifications

`flutter test` exécute deux suites :

- `test/astro_reference_test.dart` compare l'éphéméride compilée aux valeurs
  publiées par le site de référence (Vénus à 0°1′ du Scorpion le 25/10/2026,
  élongation −1,9°, cycle 24/10/2026 → 01/06/2028) ;
- `test/layout_smoke_test.dart` rend l'écran complet en 320×640, 390×844 et
  1280×800 et échoue sur tout débordement de mise en page.

## Construire

La compilation passe par **GitHub Actions** : le JDK, la CLI Clojure, Flutter et
la cible Android sont provisionnés par le workflow.

```sh
clojure -M:cljd compile   # ClojureDart -> Dart (lib/cljd-out)
flutter build apk --release
flutter build web --release
```

À chaque `push` sur `main`, `.github/workflows/build.yml` :

1. génère l'hôte Android correspondant au Flutter installé
   (`flutter create --platforms=android .`) ;
2. compile le ClojureDart en Dart ;
3. produit un APK release (artefact `clojure-app-android`) ;
4. produit le build web et le déploie sur GitHub Pages.

Installation de l'APK : télécharger l'artefact du dernier workflow vert, ou

```sh
gh run download --repo leocrapart-pixel/clojure-app --name clojure-app-android
adb install app-release.apk
```

Le build web est publié sur
<https://leocrapart-pixel.github.io/clojure-app/>.

## Structure

```
src/clojure_app/
  main.cljd            point d'entrée, état (date observée, porte ouverte)
  astro.cljd           éphéméride Vénus / Soleil / Lune
  astro/vsop.cljd      séries VSOP87 tronquées (données)
  cycle.cljd           conjonctions, cycle, portails, lecture du ciel
  theme.cljd           palette, cartes
  ui.cljd              composition de l'écran
lib/main.dart          entrée Flutter générée (exporte cljd-out)
web/                   coquille web (manifest, index)
```

## Licence

MIT.
