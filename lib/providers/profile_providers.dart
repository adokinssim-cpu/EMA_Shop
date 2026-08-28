import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/user.dart';

final userProfileProvider = Provider<User>((ref) {
  return const User(
    id: 'user001',
    name: 'Marc ADOKINSSI',
    email: 'adokinssim@gmail.com',
    phone: '+229 0196520079',
    avatarUrl: 'https://i.pravatar.cc/300?img=12',
  );
});
