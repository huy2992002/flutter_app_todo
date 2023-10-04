import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/deleted_item.dart';
import '../models/authen.dart';
import '../models/todo_model.dart';
import '../resources/app_color.dart';
import '../services/local/shared_preferences_helper.dart';
import 'login_page.dart';

class DeletedPage extends StatefulWidget {
  const DeletedPage({super.key});

  @override
  State<DeletedPage> createState() => _DeletedPageState();
}

class _DeletedPageState extends State<DeletedPage> {
  List<TodoModel> _todosdeleted = [];
  List<TodoModel> _todos = [];
  final SharedPreferencesHelper _prefs = SharedPreferencesHelper();

  _getTodos() {
    _prefs.getTodos().then((value) {
      _todos = value ?? todosInit;
      _todosdeleted =
          _todos.where((element) => (element.deleted == true)).toList();

      setState(() {});
    });
  }

  @override
  void initState() {
    _getTodos();
    super.initState();
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
                title: const Text('😍'),
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
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('OK'),
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
          title: 'Mục đã xóa'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const Divider(
                    height: 2,
                    color: AppColor.grey,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        TodoModel todo = _todosdeleted.reversed.toList()[index];
                        return DeletedItem(
                          todo: todo,
                          onRefresh: () async {
                            bool? status = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Thông Báo',
                                    style: TextStyle(color: Colors.red)),
                                content: const Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Bạn muốn khôi phục lại Todo?',
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
                                    child: const Text('Không'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Đúng'),
                                  ),
                                ],
                              ),
                            );
                            if (status ?? false == true) {
                              setState(() {
                                todo.deleted = false;
                                _prefs.addTodos(_todos);
                                _getTodos();
                              });
                            }
                          },
                          onDeleted: () {
                            setState(() {
                              _todos.remove(todo);
                              _prefs.addTodos(_todos);

                              _getTodos();
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemCount: _todosdeleted.length)
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () async {
                  bool? status = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Thông Báo',
                          style: TextStyle(color: Colors.red)),
                      content: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Bạn muốn xóa tất cả?',
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
                    setState(() {
                      _todos
                          .removeWhere((element) => (element.deleted == true));
                      _prefs.addTodos(_todos);
                      _getTodos();
                    });
                  }
                },

                // () {
                //   setState(() {
                //     _todos
                //         .removeWhere((element) => (element.deleted == true));
                //     _prefs.addTodos(_todos);
                //     _getTodos();
                //   });
                // },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.6),
                          offset: const Offset(3, 3),
                          blurRadius: 7,
                        )
                      ]),
                  child: const Text(
                    'Xóa Tất cả',
                    style: TextStyle(color: AppColor.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
