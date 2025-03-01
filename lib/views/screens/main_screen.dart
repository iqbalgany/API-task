import 'package:api_task/models/user_model.dart';
import 'package:api_task/services/user_service.dart';
import 'package:api_task/views/components/user_card.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController controller = ScrollController();
  List<UserModel> _users = [];
  bool hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadCachedUsers();
    _fetchUsers();
    controller.addListener(
      () {
        if (controller.position.maxScrollExtent == controller.offset) {
          _fetchUsers();
        }
      },
    );
  }

  Future<void> _loadCachedUsers() async {
    List<UserModel> cachedUser = await UserService().getCachedUsers();
    setState(() {
      _users = cachedUser;
    });
  }

  Future<void> _fetchUsers() async {
    const perPage = 8;
    List<UserModel> users =
        await UserService().fetchListUser(_currentPage, perPage);
    setState(() {
      _currentPage++;

      if ((users.length < perPage)) {
        hasMore = false;
      }

      _users.addAll(users);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HOME'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _fetchUsers,
          child: ListView.builder(
            controller: controller,
            itemCount: _users.length + 1,
            itemBuilder: (context, index) {
              if (index < _users.length) {
                final user = _users[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == _users.length - 1 ? 20 : 0,
                  ),
                  child: UserCard(user: user),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Center(
                    child: hasMore
                        ? CircularProgressIndicator()
                        : Text('No more user to load'),
                  ),
                );
              }
            },
          ),
        ));
  }
}
