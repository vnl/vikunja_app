import 'dart:async';

import 'package:vikunja_app/api/client.dart';
import 'package:vikunja_app/api/service.dart';
import 'package:vikunja_app/models/user.dart';
import 'package:vikunja_app/service/services.dart';

class UserAPIService extends APIService implements UserService {
  UserAPIService(Client client) : super(client);

  @override
  Future<UserTokenPair> login(String? username, password) async {
    var token = await client!.post('/login', body: {
      'username': username,
      'password': password
    }).then((response) => response.body['token']);
    return UserAPIService(Client(token, client!.base))
        .getCurrentUser()
        .then((user) => UserTokenPair(user, token));
  }

  @override
  Future<UserTokenPair> register(String? username, email, password) async {
    var newUser = await client!.post('/register', body: {
      'username': username,
      'email': email,
      'password': password
    }).then((response) => response.body['username']);
    return login(newUser, password);
  }

  @override
  Future<User> getCurrentUser() {
    return client!.get('/user').then((response) => User.fromJson(response.body));
  }
}
