import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vikunja_app/global.dart';
import 'package:vikunja_app/models/task.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback? onEdit;
  final ValueSetter<bool?>? onMarkedAsDone;
  final bool loading;

  const TaskTile(
      {Key? key,
      required this.task,
      this.onEdit,
      this.loading = false,
      this.onMarkedAsDone})
      : assert(task != null),
        super(key: key);

  @override
  TaskTileState createState() {
    return new TaskTileState(this.task, this.loading);
  }
}

class TaskTileState extends State<TaskTile> {
  bool _loading;
  Task _currentTask;

  TaskTileState(this._currentTask, this._loading)
      : assert(_currentTask != null),
        assert(_loading != null);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: Checkbox.width,
              width: Checkbox.width,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              )),
        ),
        title: Text(widget.task.title!),
        subtitle: widget.task.description == null || widget.task.description!.isEmpty
            ? null
            : Text(widget.task.description!),
        trailing: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => widget.onEdit,
        ),
      );
    }
    return CheckboxListTile(
      title: Text(widget.task.title!),
      controlAffinity: ListTileControlAffinity.leading,
      value: widget.task.done ?? false,
      subtitle: widget.task.description == null || widget.task.description!.isEmpty
          ? null
          : Text(widget.task.description!),
      secondary: IconButton(
        icon: Icon(Icons.settings),
        onPressed: widget.onEdit,
      ),
      onChanged: widget.onMarkedAsDone,
    );
  }

  void _change(bool value) async {
    setState(() {
      this._loading = true;
    });
    Task newTask = await _updateTask(widget.task, value);
    setState(() {
      //this.widget.task = newTask;
      this._loading = false;
    });
  }

  Future<Task> _updateTask(Task task, bool checked) {
    // TODO use copyFrom
    return VikunjaGlobal.of(context)!.taskService.update(Task(
          id: task.id,
          done: checked,
          title: task.title,
          description: task.description,
          createdBy: null,
        ));
  }
}

typedef Future<void> TaskChanged(Task task, bool newValue);
