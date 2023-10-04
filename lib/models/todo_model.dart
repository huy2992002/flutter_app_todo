class TodoModel {
  int? id;
  String? text;
  bool? isDone;
  bool? deleted;

  TodoModel({this.id, this.text, this.isDone, this.deleted=false});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    isDone = json['isDone'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'isDone': isDone,'deleted': deleted};
  }
}

final todosInit = [
  TodoModel(id: 1, text: 'Dinner with Jenny',deleted: true),
  TodoModel(id: 2, text: 'Work on mobile apps for 2 hours',deleted: true),
  TodoModel(id: 3, text: 'Team Meeting',isDone: true),
  TodoModel(id: 4, text: 'Check Emails'),
  TodoModel(id: 5, text: 'Buy Grocies'),
  TodoModel(id: 6, text: 'Morning Exercise'),
  TodoModel(id: 7, text: 'Breakfast with Flutter Pro Dev'),
  TodoModel(id: 8, text: 'Code Flutter Apps'),
  TodoModel(id: 9, text: 'Do Flutter Exercise'),
  TodoModel(id: 10, text: 'Learn Java in Softech Aptech'),
];