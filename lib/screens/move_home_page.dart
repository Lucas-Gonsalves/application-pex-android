import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/contact_destinations.dart';
import '../theme/move_theme.dart';

const ValueKey<String> portfolioSectionTestKey = ValueKey<String>(
  'portfolio-section',
);
const ValueKey<String> contactSectionTestKey = ValueKey<String>(
  'contact-section',
);
const ValueKey<String> footerSectionTestKey = ValueKey<String>(
  'footer-section',
);
const ValueKey<String> moveLogoTestKey = ValueKey<String>('move-logo');
const ValueKey<String> heroTitleTestKey = ValueKey<String>('hero-title');
const ValueKey<String> heroSubtitleTestKey = ValueKey<String>('hero-subtitle');
const ValueKey<String> portfolioImageTestKey = ValueKey<String>(
  'portfolio-image',
);
const ValueKey<String> contactImageTestKey = ValueKey<String>('contact-image');
const ValueKey<String> footerCopyrightTestKey = ValueKey<String>(
  'footer-copyright',
);
const ValueKey<String> footerLogoTestKey = ValueKey<String>('footer-logo');

typedef ContactUriLauncher = Future<bool> Function(Uri uri);

Future<bool> _launchExternalUri(Uri uri) =>
    launchUrl(uri, mode: LaunchMode.externalApplication);

enum _SocialBrand { whatsapp, instagram, facebook, linkedin }

class _SocialLink {
  const _SocialLink({
    required this.channel,
    required this.brand,
    required this.description,
    required this.action,
  });

  final ContactChannel channel;
  final _SocialBrand brand;
  final String description;
  final String action;
}

const List<_SocialLink> _socialLinks = <_SocialLink>[
  _SocialLink(
    channel: ContactChannel.whatsapp,
    brand: _SocialBrand.whatsapp,
    description:
        'Fale diretamente conosco para tirar dúvidas ou solicitar um orçamento.',
    action: 'Iniciar conversa',
  ),
  _SocialLink(
    channel: ContactChannel.instagram,
    brand: _SocialBrand.instagram,
    description:
        'Siga a nossa página no Instagram para acompanhar novidades, produtos e conteúdos sobre energia solar.',
    action: 'Acessar perfil',
  ),
  _SocialLink(
    channel: ContactChannel.facebook,
    brand: _SocialBrand.facebook,
    description:
        'Acompanhe nossas publicações e fique por dentro das nossas novidades no Facebook.',
    action: 'Acessar perfil',
  ),
  _SocialLink(
    channel: ContactChannel.linkedin,
    brand: _SocialBrand.linkedin,
    description:
        'Conecte-se conosco no LinkedIn e acompanhe nossas atualizações e parcerias.',
    action: 'Acessar perfil',
  ),
];

class MoveHomePage extends StatefulWidget {
  const MoveHomePage({super.key, this.launchUri});

  final ContactUriLauncher? launchUri;

  @override
  State<MoveHomePage> createState() => _MoveHomePageState();
}

class _MoveHomePageState extends State<MoveHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeAnchor = GlobalKey(debugLabel: 'home-anchor');
  final GlobalKey _portfolioAnchor = GlobalKey(debugLabel: 'portfolio-anchor');
  final GlobalKey _contactAnchor = GlobalKey(debugLabel: 'contact-anchor');
  String _activeSection = 'Home';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveSection);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateActiveSection)
      ..dispose();
    super.dispose();
  }

  void _updateActiveSection() {
    if (!_scrollController.hasClients) {
      return;
    }

    var nextSection = 'Home';
    if (_anchorIsAbove(_portfolioAnchor, 145)) {
      nextSection = 'Portfólio';
    }
    if (_anchorIsAbove(_contactAnchor, 145) ||
        _scrollController.position.extentAfter < 24) {
      nextSection = 'Contato';
    }

    if (nextSection != _activeSection && mounted) {
      setState(() => _activeSection = nextSection);
    }
  }

  bool _anchorIsAbove(GlobalKey key, double threshold) {
    final object = key.currentContext?.findRenderObject();
    if (object is! RenderBox || !object.hasSize) {
      return false;
    }
    return object.localToGlobal(Offset.zero).dy <= threshold;
  }

  Future<void> _scrollTo(GlobalKey anchor, String section) async {
    final targetContext = anchor.currentContext;
    if (targetContext == null) {
      return;
    }
    setState(() => _activeSection = section);
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  Future<void> _openChannel(ContactChannel channel) async {
    final uri = ContactDestinations.forChannel(channel);

    try {
      final launched = await (widget.launchUri ?? _launchExternalUri)(uri);
      if (!launched && mounted) {
        _showChannelMessage('Não foi possível abrir ${channel.displayName}.');
      }
    } catch (_) {
      if (mounted) {
        _showChannelMessage('Não foi possível abrir ${channel.displayName}.');
      }
    }
  }

  void _showChannelMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _MoveHeader(
              activeSection: _activeSection,
              onHome: () => _scrollTo(_homeAnchor, 'Home'),
              onPortfolio: () => _scrollTo(_portfolioAnchor, 'Portfólio'),
              onContact: () => _scrollTo(_contactAnchor, 'Contato'),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(key: _homeAnchor, child: const _HeroSection()),
                    Container(
                      key: _portfolioAnchor,
                      child: const KeyedSubtree(
                        key: portfolioSectionTestKey,
                        child: _PortfolioSection(),
                      ),
                    ),
                    Container(
                      key: _contactAnchor,
                      child: KeyedSubtree(
                        key: contactSectionTestKey,
                        child: _ContactSection(
                          onContact: () =>
                              _openChannel(ContactChannel.whatsapp),
                          onOpenChannel: _openChannel,
                        ),
                      ),
                    ),
                    KeyedSubtree(
                      key: footerSectionTestKey,
                      child: const _MoveFooter(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoveHeader extends StatelessWidget {
  const _MoveHeader({
    required this.activeSection,
    required this.onHome,
    required this.onPortfolio,
    required this.onContact,
  });

  final String activeSection;
  final VoidCallback onHome;
  final VoidCallback onPortfolio;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final compact = constraints.maxWidth < 360;
        final small = constraints.maxWidth < 480;
        final narrow = constraints.maxWidth < 700;
        final logoWidth = compact
            ? 118.0
            : (small ? 128.0 : (narrow ? 154.0 : 204.0));
        final navFontSize = compact
            ? 12.5
            : (small ? 13.5 : (narrow ? 14.0 : 16.0));
        final logo = Semantics(
          button: true,
          label: 'MOVE Distribuidora Solar. Ir para Home.',
          child: InkWell(
            onTap: onHome,
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'web/logo/logo-move.png',
              key: moveLogoTestKey,
              width: logoWidth,
              height: narrow ? 42 : 52,
              fit: BoxFit.contain,
              semanticLabel: 'MOVE Distribuidora Solar',
            ),
          ),
        );
        final navItems = <Widget>[
          _NavigationItem(
            key: const ValueKey<String>('nav-home'),
            label: 'Home',
            active: activeSection == 'Home',
            onTap: onHome,
            fontSize: navFontSize,
          ),
          _NavigationItem(
            key: const ValueKey<String>('nav-portfolio'),
            label: 'Portfólio',
            active: activeSection == 'Portfólio',
            onTap: onPortfolio,
            fontSize: navFontSize,
          ),
          _NavigationItem(
            key: const ValueKey<String>('nav-contact'),
            label: 'Contato',
            active: activeSection == 'Contato',
            onTap: onContact,
            fontSize: navFontSize,
          ),
        ];
        final headerContent = Row(
          children: <Widget>[
            logo,
            SizedBox(width: small ? 6 : 16),
            Expanded(
              child: Row(
                children: navItems
                    .map((Widget item) => Expanded(child: Center(child: item)))
                    .toList(growable: false),
              ),
            ),
          ],
        );

        return Container(
          key: const ValueKey<String>('move-header'),
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: narrow ? 9 : 13),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: MoveLayout.maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MoveLayout.horizontalPagePadding(
                    constraints.maxWidth,
                  ),
                ),
                child: headerContent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    required this.fontSize,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: 'Ir para $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SizedBox(
            height: 40,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                        color: active ? MoveColors.yellow : MoveColors.navy,
                        fontSize: fontSize,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: active ? 32 : 0,
                    height: 2,
                    decoration: BoxDecoration(
                      color: MoveColors.yellow,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        final narrow = width < 600;
        final horizontalPadding = MoveLayout.horizontalPagePadding(width);
        final height = narrow
            ? (width < 360 ? 460.0 : 470.0)
            : (width * .72).clamp(540.0, 600.0).toDouble();
        final titleSize = width < 360
            ? 29.0
            : (width < 390
                  ? 32.0
                  : (narrow ? 35.0 : (width < 900 ? 48.0 : 58.0)));

        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                'assets/images/solar-sunset.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                semanticLabel: 'Painéis solares ao pôr do sol',
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Color(0xC8001028),
                      Color(0x8A00142E),
                      Color(0x1200142E),
                    ],
                    stops: <double>[0, .56, 1],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: MoveLayout.maxContentWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleSize,
                                height: 1.06,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.9,
                              ),
                              children: const <TextSpan>[
                                TextSpan(text: 'Energia solar\n'),
                                TextSpan(text: 'para um '),
                                TextSpan(
                                  text: 'futuro melhor',
                                  style: TextStyle(
                                    color: MoveColors.yellowHighlight,
                                  ),
                                ),
                              ],
                            ),
                            key: heroTitleTestKey,
                          ),
                          const SizedBox(height: 19),
                          Container(
                            width: 42,
                            height: 3,
                            decoration: BoxDecoration(
                              color: MoveColors.yellow,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 17),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Text(
                              'Soluções em distribuição de equipamentos\n'
                              'solares com qualidade e confiança.',
                              key: heroSubtitleTestKey,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: narrow ? 15.5 : 18,
                                height: 1.45,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection();

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      key: const ValueKey<String>('portfolio-frame'),
      color: MoveColors.offWhite,
      verticalPadding: 44,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _SectionTitle(
            key: ValueKey<String>('portfolio-section-title'),
            title: 'Portfólio',
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1.92,
              child: Image.asset(
                'web/images/move-guaramirim-matriz.png',
                key: portfolioImageTestKey,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                semanticLabel: 'Matriz da MOVE em Guaramirim, Santa Catarina',
              ),
            ),
          ),
          const SizedBox(height: 17),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final titleSize = constraints.maxWidth < 400 ? 21.5 : 30.0;
              return Text(
                'Equipamentos solares para projetos\n'
                'residenciais em Guaramirim - SC',
                style: TextStyle(
                  color: MoveColors.navy,
                  fontSize: titleSize,
                  height: 1.13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.45,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          const Text(
            'Distribuição de equipamentos fotovoltaicos de qualidade para '
            'projetos de energia limpa e economia na conta de luz.',
            style: TextStyle(
              color: MoveColors.secondaryText,
              fontSize: 15,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 27),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 320) {
                return const Column(
                  children: <Widget>[
                    _BenefitCard(
                      icon: Icons.wb_sunny_outlined,
                      title: 'Alta eficiência',
                      description:
                          'Equipamentos de qualidade das principais marcas do mercado.',
                      compact: true,
                    ),
                    SizedBox(height: 22),
                    _BenefitCard(
                      icon: Icons.verified_user_outlined,
                      title: 'Segurança',
                      description:
                          'Produtos certificados e com garantia de procedência.',
                      compact: true,
                    ),
                    SizedBox(height: 22),
                    _BenefitCard(
                      icon: Icons.eco_outlined,
                      title: 'Sustentabilidade',
                      description:
                          'Contribuindo para um futuro melhor com energia limpa e renovável.',
                      compact: true,
                    ),
                  ],
                );
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Expanded(
                      child: _BenefitCard(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Alta eficiência',
                        description:
                            'Equipamentos de qualidade das principais marcas do mercado.',
                      ),
                    ),
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: MoveColors.divider,
                    ),
                    const Expanded(
                      child: _BenefitCard(
                        icon: Icons.verified_user_outlined,
                        title: 'Segurança',
                        description:
                            'Produtos certificados e com garantia de procedência.',
                      ),
                    ),
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: MoveColors.divider,
                    ),
                    const Expanded(
                      child: _BenefitCard(
                        icon: Icons.eco_outlined,
                        title: 'Sustentabilidade',
                        description:
                            'Contribuindo para um futuro melhor com energia limpa e renovável.',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 8,
        vertical: compact ? 0 : 5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: MoveColors.yellow, size: compact ? 42 : 44),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MoveColors.navy,
                fontSize: compact ? 15 : 13.2,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MoveColors.secondaryText,
              fontSize: compact ? 13 : 11.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.onContact, required this.onOpenChannel});

  final VoidCallback onContact;
  final ValueChanged<ContactChannel> onOpenChannel;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      key: const ValueKey<String>('contact-frame'),
      color: MoveColors.paleBlue,
      verticalPadding: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _SectionTitle(
            key: ValueKey<String>('contact-section-title'),
            title: 'Contato',
          ),
          const SizedBox(height: 25),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final image = ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.18,
                  child: Image.asset(
                    'web/images/move-tubarao-cd.png',
                    key: contactImageTestKey,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    semanticLabel:
                        'Centro de distribuição da MOVE em Tubarão, Santa Catarina',
                  ),
                ),
              );
              final copy = const _ContactCopy();
              final photoAndContact = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  image,
                  const SizedBox(height: 16),
                  _ContactButton(onContact: onContact),
                ],
              );

              if (constraints.maxWidth < 580) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    copy,
                    const SizedBox(height: 22),
                    photoAndContact,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(flex: 5, child: copy),
                  const SizedBox(width: 28),
                  Expanded(flex: 5, child: photoAndContact),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          ..._socialLinks.map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _SocialRow(
                link: link,
                onTap: () => onOpenChannel(link.channel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCopy extends StatelessWidget {
  const _ContactCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final size = constraints.maxWidth < 400 ? 29.0 : 34.0;
            return Text(
              'Estamos prontos\npara te atender',
              style: TextStyle(
                color: MoveColors.navy,
                fontSize: size,
                height: 1.12,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.45,
              ),
            );
          },
        ),
        const SizedBox(height: 9),
        const Text(
          'Entre em contato para solicitar um orçamento ou tirar suas dúvidas '
          'sobre nossos produtos e serviços.',
          style: TextStyle(
            color: MoveColors.secondaryText,
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.onContact});

  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const ValueKey<String>('cta-contact'),
        onPressed: onContact,
        style: ElevatedButton.styleFrom(
          backgroundColor: MoveColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: const Row(
          children: <Widget>[
            _SocialBrandIcon(brand: _SocialBrand.whatsapp, size: 27),
            SizedBox(width: 10),
            Expanded(child: Text('Entrar em contato')),
            Icon(Icons.arrow_forward_rounded, size: 19),
          ],
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.link, required this.onTap});

  final _SocialLink link;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final compact = constraints.maxWidth < 560;
        final name = link.channel.displayName;
        final content = compact ? _compactContent(name) : _wideContent(name);

        return Semantics(
          button: true,
          label: '$name. ${link.description} ${link.action}.',
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              key: ValueKey<String>('social-${link.channel.name}'),
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 13 : 17,
                  vertical: compact ? 12 : 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x0D082858),
                      blurRadius: 12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    _SocialBrandIcon(brand: link.brand, size: 40),
                    SizedBox(width: compact ? 12 : 15),
                    Expanded(child: content),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _compactContent(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                name,
                key: ValueKey<String>('social-platform-${link.channel.name}'),
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(
                  color: MoveColors.navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              link.action,
              key: ValueKey<String>('social-action-${link.channel.name}'),
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF1749B8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_rounded,
              color: MoveColors.blue,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          link.description,
          key: ValueKey<String>('social-description-${link.channel.name}'),
          style: const TextStyle(
            color: MoveColors.secondaryText,
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _wideContent(String name) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 82,
          child: Text(
            name,
            key: ValueKey<String>('social-platform-${link.channel.name}'),
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(
              color: MoveColors.navy,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(width: 1, height: 38, color: MoveColors.divider),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            link.description,
            style: const TextStyle(
              color: MoveColors.secondaryText,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          link.action,
          key: ValueKey<String>('social-action-${link.channel.name}'),
          maxLines: 1,
          softWrap: false,
          style: const TextStyle(
            color: Color(0xFF1749B8),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(
          Icons.arrow_forward_rounded,
          color: MoveColors.blue,
          size: 17,
        ),
      ],
    );
  }
}

class _SocialBrandIcon extends StatelessWidget {
  const _SocialBrandIcon({required this.brand, required this.size});

  final _SocialBrand brand;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = switch (brand) {
      _SocialBrand.whatsapp => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF19BD5A),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.call_rounded, color: Colors.white, size: size * .57),
      ),
      _SocialBrand.instagram => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * .25),
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              Color(0xFFFEDA75),
              Color(0xFFFA7E1E),
              Color(0xFFD62976),
              Color(0xFF962FBF),
              Color(0xFF4F5BD5),
            ],
          ),
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
          size: size * .62,
        ),
      ),
      _SocialBrand.facebook => Container(
        width: size,
        height: size,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: const Color(0xFF1877F2),
          borderRadius: BorderRadius.circular(size * .16),
        ),
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * .88,
            height: 1.02,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      _SocialBrand.linkedin => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF0A66C2),
          borderRadius: BorderRadius.circular(size * .14),
        ),
        child: Text(
          'in',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * .48,
            height: 1,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    };

    return SizedBox(
      width: size,
      height: size,
      child: Center(child: icon),
    );
  }
}

class _MoveFooter extends StatelessWidget {
  const _MoveFooter();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final compact = constraints.maxWidth < 360;
        final narrow = constraints.maxWidth < 620;
        const copyright = Text(
          '© 2024 Move Distribuidora Solar.\n'
          'Todos os direitos autorais reservados.',
          key: footerCopyrightTestKey,
          style: TextStyle(color: Color(0xFFE7EDF8), fontSize: 12, height: 1.5),
        );
        final brand = _FooterBrand(width: narrow ? 142 : 178);

        return Container(
          color: MoveColors.deepNavy,
          child: Stack(
            children: <Widget>[
              const Positioned.fill(
                child: CustomPaint(painter: _FooterWavePainter()),
              ),
              Container(
                key: const ValueKey<String>('footer-content'),
                color: Colors.transparent,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: MoveLayout.maxContentWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MoveLayout.horizontalPagePadding(
                          constraints.maxWidth,
                        ),
                        vertical: narrow ? 25 : 34,
                      ),
                      child: compact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                copyright,
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: brand,
                                ),
                              ],
                            )
                          : Row(
                              children: <Widget>[
                                Expanded(child: copyright),
                                const SizedBox(width: 12),
                                brand,
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          'web/logo/logo-move-footer.png',
          key: footerLogoTestKey,
          width: width,
          fit: BoxFit.contain,
          semanticLabel: 'MOVE Distribuidora Solar',
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: width,
          child: Text(
            'Energia que move o seu futuro.',
            style: TextStyle(
              color: Colors.white,
              fontSize: width < 160 ? 10 : 11.5,
            ),
            textAlign: TextAlign.right,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

class _FooterWavePainter extends CustomPainter {
  const _FooterWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final first = Paint()..color = const Color(0x140B3975);
    final second = Paint()..color = const Color(0x100A326B);
    final path = Path()
      ..moveTo(0, size.height * .52)
      ..cubicTo(
        size.width * .22,
        size.height * .16,
        size.width * .42,
        size.height * .99,
        size.width * .66,
        size.height * .49,
      )
      ..cubicTo(
        size.width * .81,
        size.height * .19,
        size.width * .91,
        size.height * .33,
        size.width,
        size.height * .12,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, first);

    final lowerPath = Path()
      ..moveTo(0, size.height * .87)
      ..cubicTo(
        size.width * .28,
        size.height * .55,
        size.width * .46,
        size.height * .93,
        size.width * .75,
        size.height * .62,
      )
      ..cubicTo(
        size.width * .86,
        size.height * .5,
        size.width * .93,
        size.height * .69,
        size.width,
        size.height * .46,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(lowerPath, second);
  }

  @override
  bool shouldRepaint(covariant _FooterWavePainter oldDelegate) => false;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 6,
          height: 40,
          decoration: BoxDecoration(
            color: MoveColors.yellow,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: MoveColors.navy,
              fontSize: 36,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionFrame extends StatelessWidget {
  const _SectionFrame({
    super.key,
    required this.color,
    required this.verticalPadding,
    required this.child,
  });

  final Color color;
  final double verticalPadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final horizontalPadding = MoveLayout.horizontalPagePadding(
          constraints.maxWidth,
        );

        return ColoredBox(
          color: color,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: MoveLayout.maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
