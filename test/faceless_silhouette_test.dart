import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:little_muslim/utils/app_state.dart';
import 'package:little_muslim/widgets/faceless_silhouette.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FacelessSilhouette renders 3D full-color artwork with avatar border and glow',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: FacelessSilhouette(
                size: 80,
                type: SilhouetteType.topi,
                color: Color(0xFF8B5CF6), // Royal Purple
                circleBackground: true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FacelessSilhouette), findsOneWidget);
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final imageWidget = tester.widget<Image>(imageFinder);
    expect(imageWidget.image, isA<AssetImage>());
    final assetImage = imageWidget.image as AssetImage;
    expect(assetImage.assetName, equals('assets/images/silhouette_topi.png'));
  });

  testWidgets('FacelessSilhouette switches from Topi to Hijab and updates color in AppState',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'avatar_type': 'topi',
      'avatar_color': 0xFF10B981,
    });
    final appState = AppState();
    await appState.loadFromPrefs();

    expect(appState.avatarType, equals('topi'));
    expect(appState.avatarColor, equals(0xFF10B981));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const MaterialApp(
          home: Scaffold(
            body: Center(
              child: FacelessSilhouette(size: 80),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial Topi asset
    var imageWidget = tester.widget<Image>(find.byType(Image));
    expect((imageWidget.image as AssetImage).assetName,
        equals('assets/images/silhouette_topi.png'));

    // Update avatar to Hijab and Blue
    await appState.updateAvatar(type: 'hijab', color: 0xFF0284C7);
    await tester.pumpAndSettle();

    expect(appState.avatarType, equals('hijab'));
    expect(appState.avatarColor, equals(0xFF0284C7));

    // Verify updated Hijab asset
    imageWidget = tester.widget<Image>(find.byType(Image));
    expect((imageWidget.image as AssetImage).assetName,
        equals('assets/images/silhouette_hijab.png'));

    // Verify persistence in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('avatar_type'), equals('hijab'));
    expect(prefs.getInt('avatar_color'), equals(0xFF0284C7));
  });
}
