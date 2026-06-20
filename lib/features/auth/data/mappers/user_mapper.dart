import 'package:fuvekonmobile/features/auth/data/models/user_model.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/user.dart';

abstract final class UserMapper {
  static User toEntity(UserModel model) {
    return User(id: model.id, email: model.email, name: model.name);
  }
}
