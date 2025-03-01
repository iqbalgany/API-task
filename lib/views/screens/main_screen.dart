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
  List<UserModel> _foundUsers = [];

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
      _foundUsers = List.from(_users);
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
      _foundUsers = List.from(_users);
    });
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        _foundUsers = List.from(_users);
      });
    } else {
      setState(() {
        _foundUsers = _users
            .where(
              (user) =>
                  user.firstName.toLowerCase().contains(
                        enteredKeyword.toLowerCase(),
                      ) ||
                  user.lastName.toLowerCase().contains(
                        enteredKeyword.toLowerCase(),
                      ),
            )
            .toList();
      });
    }
  }

  void resetSearch() {
    setState(() {
      _foundUsers = List.from(_users);
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
        body: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: _foundUsers.length + 1,
                itemBuilder: (context, index) {
                  if (index < _foundUsers.length) {
                    final user = _foundUsers[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == _foundUsers.length - 1 ? 20 : 0,
                      ),
                      child: UserCard(
                        user: user,
                      ),
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
            ),
          ],
        ));
  }
}
