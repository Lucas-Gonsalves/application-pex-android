# Agenda 05 — TechFlow

Aplicativo Flutter desenvolvido para demonstrar os requisitos da atividade acadêmica **Agenda 05 — Aplicativo Flutter**.

## Tema

O TechFlow simula um pequeno portal de notícias sobre tecnologia, programação, desenvolvimento mobile, inteligência artificial e Flutter.

## Requisitos atendidos

- Scaffold, AppBar e Drawer para estrutura e navegação.
- Stack na seção de destaque da página inicial.
- Duas páginas: Início e Sobre.
- Componentes de layout como Container, Column, Row, Padding, Center, Align, Text, Icon e Card.
- MediaQuery para responsividade simples.
- Dados estáticos/mockados, sem API, login, banco de dados ou backend.

## Como executar

Com o Flutter SDK instalado:

```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Depois acesse:

```text
http://localhost:8080
```

Também é possível validar com:

```bash
flutter analyze
flutter test
```
