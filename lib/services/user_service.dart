import 'package:api_task/models/user_model.dart';
import 'package:api_task/services/shared_preferences_service.dart';
import 'package:dio/dio.dart';

class UserService {
  Future<List<UserModel>> fetchListUser(int page, int per_page) async {
    final Dio _dio = Dio();

    try {
      final Response response = await _dio
          .get('https://reqres.in/api/users?page=$page&per_page=$per_page');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];

        List<UserModel> users =
            data.map((json) => UserModel.fromJson(json)).toList();

        await SharedPreferencesService().saveUsers(users);
        return users;
      } else {
        throw Exception('Gagal mengambil data user');
      }
    } catch (e) {
      throw Exception('Gagal mengambil data user: $e');
    }
  }

  Future<List<UserModel>> getCachedUsers() async {
    return await SharedPreferencesService().loadUsers();
  }
}
