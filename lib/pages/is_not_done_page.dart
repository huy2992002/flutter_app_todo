import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/search_box.dart';
import '../components/todo_item.dart';
import '../models/authen.dart';
import '../models/todo_model.dart';
import '../resources/app_color.dart';
import '../services/local/shared_preferences_helper.dart';
import 'login_page.dart';

class IsNotDonePage extends StatefulWidget {
  const IsNotDonePage({super.key});

  @override
  State<IsNotDonePage> createState() => _IsNotDonePageState();
}

class _IsNotDonePageState extends State<IsNotDonePage> {
  final _searchController = TextEditingController();
  final _addController = TextEditingController();
  final _addFocus = FocusNode();
  bool _showAddBox = false;
  final SharedPreferencesHelper _prefs = SharedPreferencesHelper();
  List<TodoModel> _searches = [];
  List<TodoModel> _todos = [];
  List<TodoModel> _todosNoDone = [];

  @override
  void initState() {
    _getTodos();
    super.initState();
  }

  _getTodos() {
    _prefs.getTodos().then((value) {
      _todos = value ?? todosInit;
      _todosNoDone = _todos
          .where(
              (element) => (element.isDone != true && element.deleted != true))
          .toList();

      _searches = [..._todosNoDone];
      setState(() {});
    });
  }

  _searchTodos(String searchText) {
    searchText = searchText.toLowerCase();
    _searches = _todosNoDone
        .where((element) =>
            (element.text ?? '').toLowerCase().contains(searchText))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: CustomAppBar(
          leftPressed: () async {
            bool? status = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Thông Báo',
                    style: TextStyle(color: Colors.red)),
                content: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bạn có muốn Đăng Xuất?',
                        style: TextStyle(fontSize: 22.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Không'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Đúng'),
                  ),
                ],
              ),
            );
            if (status ?? false) {
             Authen.username = Authen.username;
              Authen.password = Authen.password;
              Authen.isLogin = false;
              await Authen.saveData();
              await Authen.loadData();
              Route route = MaterialPageRoute(
                builder: (context) => const LoginPage(),
              );
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                context,
                route,
                (Route<dynamic> route) => false,
              );
              
            }
          },
          title: 'Chưa Hoàn Thành'),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(top: 12.0, bottom: 92.0),
                child: Column(
                  children: [
                    SearchBox(
                        onChange: (value) =>
                            setState(() => _searchTodos(value)),
                        controller: _searchController),
                    const Divider(
                        height: 32.6, thickness: 1.36, color: AppColor.grey),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _searches.length,
                      itemBuilder: (context, index) {
                        TodoModel todo = _searches.reversed.toList()[index];

                        return TodoItem(
                          onChanged: () {
                            setState(() {
                              todo.isDone = true;

                              _prefs.addTodos(_todos);
                              _getTodos();
                            });
                          },
                          onDeleted: () async {
                            bool? status = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('😍'),
                                content: const Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Do you want to remove the todo?',
                                        style: TextStyle(fontSize: 22.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            if (status ?? false) {
                              setState(() {
                                todo.deleted = true;
                              _prefs.addTodos(_todos);

                                _getTodos();
                              });
                            }
                          },
                          todo: todo,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16.8),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 14.6,
            child: Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: _showAddBox,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5.6),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(color: AppColor.blue),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColor.shadow,
                            offset: Offset(0.0, 3.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _addController,
                        focusNode: _addFocus,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a new todo item',
                          hintStyle: TextStyle(color: AppColor.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                GestureDetector(
                  onTap: () {
                    _showAddBox = !_showAddBox;

                    if (_showAddBox) {
                      setState(() {});
                      _addFocus.requestFocus();
                      return;
                    }
                    String text = _addController.text.trim();
                    if (text.isEmpty) {
                      setState(() {});
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    int id = 1;
                    if (_todos.isNotEmpty) {
                      id = (_todos.last.id ?? 0) + 1;
                    }

                    TodoModel todo = TodoModel()
                      ..id = id
                      ..text = text;
                    setState(() {
                      _todos.add(todo);
                      _prefs.addTodos(_todos);
                      _getTodos();
                    });
                    _addController.clear();
                    _searchController.clear();
                    _searchTodos('');
                    setState(() {});
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14.6),
                    decoration: BoxDecoration(
                      color: AppColor.blue,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.shadow,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add,
                        size: 32.0, color: AppColor.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
    );
  }
}
