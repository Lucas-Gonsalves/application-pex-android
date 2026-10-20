enum ContactChannel { whatsapp, instagram, facebook, linkedin }

abstract final class ContactDestinations {
  static const String whatsappUrl = 'https://wa.me/554734400866';
  static const String instagramUrl =
      'https://www.instagram.com/movedistribuidorasolar?exln=MXdoOThreXFlZGZuMA==';
  static const String facebookUrl =
      'https://www.facebook.com/share/1BFoW9Lywf/';
  static const String linkedInUrl =
      'https://www.linkedin.com/company/move-distribuidora-solar/home/';

  static Uri forChannel(ContactChannel channel) {
    final value = switch (channel) {
      ContactChannel.whatsapp => whatsappUrl,
      ContactChannel.instagram => instagramUrl,
      ContactChannel.facebook => facebookUrl,
      ContactChannel.linkedin => linkedInUrl,
    };
    return Uri.parse(value);
  }
}

extension ContactChannelName on ContactChannel {
  String get displayName => switch (this) {
    ContactChannel.whatsapp => 'WhatsApp',
    ContactChannel.instagram => 'Instagram',
    ContactChannel.facebook => 'Facebook',
    ContactChannel.linkedin => 'LinkedIn',
  };
}
