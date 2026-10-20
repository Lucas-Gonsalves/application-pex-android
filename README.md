# application-pex-android

Aplicação mobile desenvolvida em Flutter e Dart como projeto PEX da faculdade Católica. Apresenta a MOVE Distribuidora Solar, seu portfólio e seus canais oficiais de contato, com interface baseada na identidade visual da empresa.

## Tecnologias

- Flutter e Dart
- `url_launcher` para abrir links externos

## Executar

Na raiz do repositório, com o Flutter SDK instalado:

```sh
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

A versão web fica disponível em http://localhost:8080. Para executar em um dispositivo ou emulador Android conectado, use `flutter run -d <id-do-dispositivo>`.

Os links oficiais usados pela aplicação são [WhatsApp](https://wa.me/554734400866), [Instagram](https://www.instagram.com/movedistribuidorasolar?exln=MXdoOThreXFlZGZuMA==), [Facebook](https://www.facebook.com/share/1BFoW9Lywf/) e [LinkedIn](https://www.linkedin.com/company/move-distribuidora-solar/home/). A foto da tela inicial é de [Bernd Dittrich, via Unsplash](https://unsplash.com/photos/solar-farm-in-rural-landscape-bheTycKOh9Q).

## Verificações

```sh
flutter analyze lib test
flutter test
flutter build apk --debug
```
