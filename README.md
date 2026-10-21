# application-pex-android

Aplicação mobile desenvolvida com Flutter e Dart como projeto PEX da faculdade Católica. Apresenta a MOVE Distribuidora Solar, seu portfólio e seus canais oficiais de contato.

## Tecnologias

- Flutter
- Dart
- `url_launcher`

## Como executar

Pré-requisitos: Flutter SDK instalado e configurado para Android. Execute na pasta que contém o `pubspec.yaml`:

```bash
flutter pub get
flutter run
```

## Testes e análise

```bash
flutter test
flutter analyze lib test
```

## Build e publicação

O projeto possui alvos Android e Flutter Web. Os scripts abaixo usam somente o
Flutter SDK e podem ser executados na raiz do repositório em Windows, macOS ou
Linux:

```bash
dart run scripts/validate.dart
```

Esse comando resolve dependências, verifica a formatação de `lib`, `test` e
`scripts`, executa a análise estática e os testes automatizados.

Para gerar os artefatos Android de release, configure uma chave de assinatura
local em `android/key.properties`. O arquivo e a chave não devem ser enviados
ao Git. Ele precisa conter `storePassword`, `keyPassword`, `keyAlias` e
`storeFile`; este último deve apontar para a chave em relação a `android/app`.
Antes da primeira publicação na Google Play, confirme também um identificador
de pacote único e de sua propriedade, pois o projeto ainda usa
`com.example.app`.

```bash
dart run scripts/build_android.dart
```

O comando gera e confere estes artefatos:

- `build/app/outputs/flutter-apk/app-release.apk` para instalação direta.
- `build/app/outputs/bundle/release/app-release.aab` para envio a uma loja.

Para gerar a versão Web de produção:

```bash
dart run scripts/build_web.dart
```

O resultado fica em `build/web/`. O título, favicon e manifesto da aplicação
Web são preservados no build.

Não há destino remoto de publicação configurado neste repositório. Por isso,
`dart run scripts/deploy.dart` informa essa pendência e não publica nada. A
etapa de distribuição do APK, envio do AAB à loja ou hospedagem da versão Web
deve ser feita somente após a definição do destino e das credenciais externas.
