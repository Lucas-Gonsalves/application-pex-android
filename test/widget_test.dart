import 'package:application_pex_android/config/contact_destinations.dart';
import 'package:application_pex_android/main.dart';
import 'package:application_pex_android/screens/move_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mostra o conteúdo final da MOVE e os assets corretos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MoveApp());
    await tester.pumpAndSettle();

    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).title, 'MOVE');
    expect(find.byKey(const ValueKey<String>('move-header')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('nav-home')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('nav-portfolio')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('nav-contact')), findsOneWidget);

    expect(find.text('Energia solar\npara um futuro melhor'), findsOneWidget);
    expect(
      find.text(
        'Soluções em distribuição de equipamentos\n'
        'solares com qualidade e confiança.',
      ),
      findsOneWidget,
    );
    expect(find.text('Conheça nossos produtos'), findsNothing);

    expect(find.text('Portfólio'), findsAtLeastNWidgets(2));
    expect(find.text('PROJETOS RESIDENCIAIS'), findsNothing);
    expect(
      find.text(
        'Equipamentos solares para projetos\n'
        'residenciais em Guaramirim - SC',
      ),
      findsOneWidget,
    );
    expect(find.text('Alta eficiência'), findsOneWidget);
    expect(find.text('Segurança'), findsOneWidget);
    expect(find.text('Sustentabilidade'), findsOneWidget);

    expect(find.text('Contato'), findsAtLeastNWidgets(2));
    expect(find.text('FALE CONOSCO'), findsNothing);
    expect(find.text('Estamos prontos\npara te atender'), findsOneWidget);
    expect(
      find.textContaining('Entre em contato para solicitar um orçamento'),
      findsOneWidget,
    );
    expect(find.text('Entrar em contato'), findsOneWidget);

    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('Iniciar conversa'), findsOneWidget);
    expect(find.text('Acessar perfil'), findsNWidgets(3));
    expect(
      find.text(
        '© 2024 Move Distribuidora Solar.\n'
        'Todos os direitos autorais reservados.',
      ),
      findsOneWidget,
    );
    expect(find.text('Energia que move o seu futuro.'), findsOneWidget);

    _expectAsset(
      tester,
      portfolioImageTestKey,
      'web/images/move-guaramirim-matriz.png',
    );
    _expectAsset(tester, contactImageTestKey, 'web/images/move-tubarao-cd.png');
    _expectAsset(tester, footerLogoTestKey, 'web/logo/logo-move-footer.png');
  });

  test('usa os destinos oficiais de cada canal', () {
    expect(
      ContactDestinations.forChannel(ContactChannel.whatsapp).toString(),
      'https://wa.me/554734400866',
    );
    expect(
      ContactDestinations.forChannel(ContactChannel.instagram).toString(),
      'https://www.instagram.com/movedistribuidorasolar?exln=MXdoOThreXFlZGZuMA==',
    );
    expect(
      ContactDestinations.forChannel(ContactChannel.linkedin).toString(),
      'https://www.linkedin.com/company/move-distribuidora-solar/home/',
    );
    expect(
      ContactDestinations.forChannel(ContactChannel.facebook).toString(),
      'https://www.facebook.com/share/1BFoW9Lywf/',
    );
  });

  testWidgets('cada ação solicita a URI da plataforma correspondente', (
    WidgetTester tester,
  ) async {
    final openedUris = <Uri>[];
    await tester.pumpWidget(
      MoveApp(
        launchUri: (Uri uri) async {
          openedUris.add(uri);
          return true;
        },
      ),
    );
    await tester.pumpAndSettle();

    for (final channel in ContactChannel.values) {
      await tester.ensureVisible(
        find.byKey(ValueKey<String>('social-${channel.name}')),
      );
      await tester.tap(find.byKey(ValueKey<String>('social-${channel.name}')));
      await tester.pumpAndSettle();
      expect(openedUris.last, ContactDestinations.forChannel(channel));
    }

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('cta-contact')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('cta-contact')));
    await tester.pumpAndSettle();
    expect(
      openedUris.last,
      ContactDestinations.forChannel(ContactChannel.whatsapp),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a foto da seção Contato vem antes do botão no celular', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MoveApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('cta-contact')),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getRect(find.byKey(contactImageTestKey)).bottom,
      lessThan(
        tester.getRect(find.byKey(const ValueKey<String>('cta-contact'))).top,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('falha ao abrir um canal sem encerrar a aplicação', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MoveApp(launchUri: (_) async => throw StateError('falha simulada')),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('cta-contact')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('cta-contact')));
    await tester.pump();

    expect(find.text('Não foi possível abrir WhatsApp.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a navegação continua levando às seções', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MoveApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('nav-portfolio')));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(portfolioSectionTestKey)).dy,
      lessThan(100),
    );

    await tester.tap(find.byKey(const ValueKey<String>('nav-contact')));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(contactSectionTestKey)).dy,
      lessThan(100),
    );

    await tester.tap(find.byKey(const ValueKey<String>('nav-home')));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(heroTitleTestKey)).dy,
      lessThan(tester.view.physicalSize.height),
    );
    expect(tester.takeException(), isNull);
  });

  for (final viewport in <Size>[
    const Size(320, 800),
    const Size(360, 800),
    const Size(390, 844),
    const Size(1000, 1000),
  ]) {
    testWidgets(
      'layout sem overflow e alinhado em ${viewport.width}x${viewport.height}',
      (WidgetTester tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = viewport;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const MoveApp());
        await tester.pumpAndSettle();

        final width = viewport.width;
        final expectedGutter = width < 360 ? 16.0 : (width < 600 ? 20.0 : 40.0);
        final logoRect = tester.getRect(find.byKey(moveLogoTestKey));
        expect(logoRect.width, greaterThanOrEqualTo(118));

        for (final key in <ValueKey<String>>[
          const ValueKey<String>('nav-home'),
          const ValueKey<String>('nav-portfolio'),
          const ValueKey<String>('nav-contact'),
        ]) {
          final navigationRect = tester.getRect(find.byKey(key));
          expect(navigationRect.left, greaterThanOrEqualTo(0));
          expect(navigationRect.right, lessThanOrEqualTo(width));
          expect(
            (navigationRect.center.dy - logoRect.center.dy).abs(),
            lessThan(5),
          );
        }

        for (final key in <ValueKey<String>>[
          heroTitleTestKey,
          const ValueKey<String>('portfolio-section-title'),
          const ValueKey<String>('contact-section-title'),
          const ValueKey<String>('social-whatsapp'),
        ]) {
          expect(
            tester.getRect(find.byKey(key)).left,
            closeTo(expectedGutter, 1.5),
          );
        }

        for (final channel in ContactChannel.values) {
          final rowKey = ValueKey<String>('social-${channel.name}');
          await tester.ensureVisible(find.byKey(rowKey));
          final row = tester.getRect(find.byKey(rowKey));
          final platform = tester.widget<Text>(
            find.byKey(ValueKey<String>('social-platform-${channel.name}')),
          );
          final platformRect = tester.getRect(
            find.byKey(ValueKey<String>('social-platform-${channel.name}')),
          );
          final actionRect = tester.getRect(
            find.byKey(ValueKey<String>('social-action-${channel.name}')),
          );

          expect(platform.maxLines, 1);
          expect(platform.softWrap, isFalse);
          expect(platformRect.left, greaterThanOrEqualTo(row.left));
          expect(platformRect.right, lessThan(actionRect.left));
          expect(actionRect.right, lessThanOrEqualTo(row.right));
          expect(row.right, lessThanOrEqualTo(width - expectedGutter));
        }

        await tester.ensureVisible(find.byKey(footerCopyrightTestKey));
        await tester.pumpAndSettle();
        expect(
          tester.getRect(find.byKey(footerCopyrightTestKey)).left,
          closeTo(expectedGutter, 1.5),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  test('assets informados estão registrados para o bundle Flutter', () async {
    for (final asset in <String>[
      'web/images/move-guaramirim-matriz.png',
      'web/images/move-tubarao-cd.png',
      'web/logo/logo-move-footer.png',
    ]) {
      expect((await rootBundle.load(asset)).lengthInBytes, greaterThan(0));
    }
  });
}

void _expectAsset(WidgetTester tester, Key key, String expectedPath) {
  final image = tester.widget<Image>(find.byKey(key));
  expect(image.image, isA<AssetImage>());
  expect((image.image as AssetImage).assetName, expectedPath);
}
