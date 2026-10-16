# application-pex-android

Aplicação Flutter para Android da MOVE Distribuidora Solar, desenvolvida para a atividade acadêmica. A tela principal reproduz a página institucional de referência e adapta as seções para rolagem e larguras de celular.

## Tecnologias

- Flutter e Dart.
- url_launcher para abrir os canais oficiais da MOVE.
- Assets locais para a logo e as fotografias.

## Executar

Instale as dependências com o Flutter SDK:

        flutter pub get

Para abrir a versão web de apresentação:

    flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

Depois acesse http://localhost:8080.

Para executar em um dispositivo ou emulador Android conectado ao ambiente, use flutter run -d <id-do-dispositivo>. Para gerar um APK de depuração, use:

    flutter build apk --debug

## Canais oficiais

- WhatsApp: https://wa.me/554734400866
- Instagram: https://www.instagram.com/movedistribuidorasolar?exln=MXdoOThreXFlZGZuMA==
- Facebook: https://www.facebook.com/share/1BFoW9Lywf/
- LinkedIn: https://www.linkedin.com/company/move-distribuidora-solar/home/

O botão de contato e a linha do WhatsApp abrem a mesma conversa. As três redes sociais abrem seus perfis oficiais.

## Recursos visuais

- Logo MOVE: web/logo/logo-move.png (arquivo disponibilizado no projeto).
- Logo de rodapé para fundo escuro: web/logo/logo-move-footer.png, derivada do original com a tipografia azul em branco e o amarelo oficial preservado.
- Fotos fornecidas da empresa: web/images/move-guaramirim-matriz.png (Portfólio) e web/images/move-tubarao-cd.png (Contato). O Flutter as inclui no bundle mobile como assets locais.
- Foto de pôr do sol da Home: foto de Bernd Dittrich, disponível em [Unsplash](https://unsplash.com/photos/solar-farm-in-rural-landscape-bheTycKOh9Q) e empacotada em assets/images/solar-sunset.jpg.

As três fotografias usadas pela aplicação são empacotadas localmente, sem depender de conexão à internet. Os ícones das redes sociais são desenhados com widgets Flutter.

## Análise e testes

    flutter analyze
    flutter test
