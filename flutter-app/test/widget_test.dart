import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/main.dart';

/// Taille de référence : un téléphone, comme la maquette (430 px de large).
void _usePhoneViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('Vesta affiche l’écran de connexion au démarrage', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const VestaApp());
    await tester.pump();

    // Marque + onglets d’authentification visibles.
    expect(find.text('Vesta'), findsWidgets);
    expect(find.text('CONNEXION'), findsOneWidget);
    expect(find.text('INSCRIPTION'), findsOneWidget);
    expect(find.text('Explorer sans compte'), findsOneWidget);
  });

  testWidgets('L’entrée sans compte ouvre la liste des biens', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const VestaApp());
    await tester.pump();

    final entry = find.text('Explorer sans compte');
    await tester.ensureVisible(entry);
    await tester.pumpAndSettle();
    await tester.tap(entry);
    await tester.pumpAndSettle();

    // La liste des annonces du jeu de démo s’affiche.
    expect(find.text('Villa des Oliviers'), findsOneWidget);
    expect(find.text('Le Patio Bleu'), findsOneWidget);

    // Laisse le toast de confirmation se terminer (timer de 3,5 s).
    await tester.pump(const Duration(milliseconds: 4000));
    await tester.pumpAndSettle();
  });

  testWidgets('Les erreurs de formulaire s’affichent (connexion vide)', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const VestaApp());
    await tester.pump();

    final submit = find.text('SE CONNECTER');
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    expect(find.text('Entrez une adresse e-mail valide.'), findsOneWidget);
  });

  testWidgets('Une annonce s’ouvre en détail et le retour revient à la liste', (tester) async {
    _usePhoneViewport(tester);
    await tester.pumpWidget(const VestaApp());
    await tester.pump();

    // Entrée visiteur → liste.
    final entry = find.text('Explorer sans compte');
    await tester.ensureVisible(entry);
    await tester.pumpAndSettle();
    await tester.tap(entry);
    await tester.pump(const Duration(milliseconds: 4000));
    await tester.pumpAndSettle();

    // Ouvre la première annonce (Villa des Oliviers).
    await tester.tap(find.text('Villa des Oliviers'));
    await tester.pumpAndSettle();

    // Écran détail : prix, section « À propos », bouton Contacter.
    expect(find.text('À propos de ce bien'), findsOneWidget);
    expect(find.text('Contacter'), findsOneWidget);

    // Retour à la liste.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Villa des Oliviers'), findsOneWidget);
  });
}
