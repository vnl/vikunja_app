import 'package:vikunja_app/models/user.dart';
import 'package:meta/meta.dart';

class Task {
  final int id;
  final DateTime created, updated, due;
  final List<DateTime> reminders;
  final String title, description;
  final bool done;
  final User owner;

  Task(
      {@required this.id,
      this.created,
      this.updated,
      this.reminders,
      this.due,
      @required this.title,
      this.description,
      @required this.done,
      @required this.owner});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        updated = DateTime.parse(json['updated']),
        created = DateTime.parse(json['created']),
        reminders = (json['reminder_dates'] as List<dynamic>)
            ?.map((r) => DateTime.parse(r))
            ?.toList(),
        due =
            json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
        description = json['description'],
        title = json['title'],
        done = json['done'],
        owner = User.fromJson(json['created_by']);

  toJSON() => {
        'id': id,
        'updated': updated?.toIso8601String(),
        'created': created?.toIso8601String(),
        'reminder_dates':
            reminders?.map((date) => date.toIso8601String())?.toList(),
        'due_date': due?.toIso8601String(),
        'description': description,
        'title': title,
        'done': done ?? false,
        'created_by': owner?.toJSON()
      };
}
