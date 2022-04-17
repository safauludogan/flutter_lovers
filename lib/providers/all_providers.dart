import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/user_view_model.dart';

final userViewModelProvider = ChangeNotifierProvider((ref) {
  return UserViewModel();
});
