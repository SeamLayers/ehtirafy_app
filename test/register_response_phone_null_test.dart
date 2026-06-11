import 'package:flutter_test/flutter_test.dart';
import 'package:ehtirafy_app/features/shared/auth/data/models/register_response_model.dart';
import 'package:ehtirafy_app/features/shared/auth/data/models/login_model.dart';

void main() {
  // Exact response shape the backend returns for a phone-less registration.
  final registerData = {
    'name': 'th',
    'email': 'th@gmail.com',
    'ip_address': '197.43.178.85',
    'sex': null,
    'material_status': null,
    'phone': null,
    'country_code': '966',
    'device_token': '6666666',
    'Identity_number': null,
    'updated_at': '2026-06-02T22:25:33.000000Z',
    'created_at': '2026-06-02T22:25:33.000000Z',
    'id': 4,
    'token': '8|pYX15KNgHx9G35VQmk5Pz8kPqpyFdijcvehyYqiJ9af41c11',
  };

  test('RegisterResponseModel parses phone:null without throwing', () {
    final model = RegisterResponseModel.fromJson(registerData);
    expect(model.phone, ''); // null coerced to empty string
    expect(model.id, 4);
    expect(model.name, 'th');
    expect(model.email, 'th@gmail.com');
    expect(model.countryCode, '966');
    expect(model.token, isNotNull);
    expect(model.token!.isNotEmpty, true);
  });

  test('LoginModel parses a user with phone:null without throwing', () {
    final model = LoginModel.fromJson({
      'user': registerData,
      'token': '8|sometoken',
    });
    expect(model.user.phone, '');
    expect(model.token, '8|sometoken');
  });
}
