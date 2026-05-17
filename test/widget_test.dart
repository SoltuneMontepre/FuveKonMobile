import 'package:flutter_test/flutter_test.dart';
import 'package:fuvekonmobile/core/utils/validators.dart';

void main() {
  test('email validator rejects empty input', () {
    expect(Validators.email(''), isNotNull);
    expect(Validators.email('user@example.com'), isNull);
  });

  test('password validator enforces minimum length', () {
    expect(Validators.password('123'), isNotNull);
    expect(Validators.password('123456'), isNull);
  });
}
