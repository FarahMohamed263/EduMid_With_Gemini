import 'package:flutter/material.dart';
import 'package:ai_study_app/app_palette.dart';
import '../l10n/app_localizations.dart';
import '../localization_helper.dart';

// ignore: duplicate_import
import '../localization_helper.dart';

class TaskItem {
  TaskItem({
    required this.title,
    required this.icon,
    this.completed = false,
    this.color = Colors.blue,
  });

  final String title;
  final IconData icon;
  bool completed;
  final Color color;
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();

  final List<TaskItem> _tasks = [];

  int get _completedCount =>
      _tasks.where((TaskItem task) => task.completed).length;

  int get _totalTaskCount => _tasks.length;

  double get _progress => _totalTaskCount == 0
      ? 0.0
      : (_completedCount / _totalTaskCount).clamp(0.0, 1.0);

  final List<IconData> _fallbackIcons = [
    Icons.task_alt,
    Icons.local_fire_department,
    Icons.auto_graph,
    Icons.local_florist,
    Icons.lightbulb,
    Icons.volunteer_activism,
    Icons.nature_people,
    Icons.favorite,
  ];

  final List<Color> _fallbackColors = [
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.cyanAccent,
    Colors.yellowAccent,
    Colors.tealAccent,
  ];

  IconData _iconForTask(String title) {
    final text = title.toLowerCase();
    if (text.contains('water') || text.contains('ماء')) return Icons.water_drop;
    if (text.contains('walk') || text.contains('run') || text.contains('مشي')) {
      return Icons.directions_walk;
    }
    if (text.contains('write') ||
        text.contains('note') ||
        text.contains('thought') ||
        text.contains('اكتب') ||
        text.contains('كتابة') ||
        text.contains('تفكير')) {
      return Icons.edit_note;
    }
    if (text.contains('breath') ||
        text.contains('meditate') ||
        text.contains('تنفس') ||
        text.contains('هدوء')) {
      return Icons.self_improvement;
    }
    if (text.contains('smile') ||
        text.contains('happy') ||
        text.contains('ابتسم')) {
      return Icons.emoji_emotions;
    }
    if (text.contains('read') || text.contains('قراءة')) return Icons.menu_book;
    if (text.contains('study') || text.contains('دراسة')) return Icons.school;
    if (text.contains('drink') || text.contains('شرب')) {
      return Icons.local_drink;
    }
    if (text.contains('exercise') || text.contains('تمرين')) {
      return Icons.fitness_center;
    }
    if (text.contains('music') || text.contains('موسيقى')) {
      return Icons.music_note;
    }
    if (text.contains('sleep') || text.contains('نوم')) return Icons.bedtime;
    return _fallbackIcons[title.hashCode.abs() % _fallbackIcons.length];
  }

  Color _colorForTask(String title) {
    final text = title.toLowerCase();
    if (text.contains('water') ||
        text.contains('drink') ||
        text.contains('ماء') ||
        text.contains('شرب')) {
      return Colors.lightBlueAccent;
    }
    if (text.contains('walk') || text.contains('run') || text.contains('مشي')) {
      return Colors.orangeAccent;
    }
    if (text.contains('write') ||
        text.contains('note') ||
        text.contains('thought') ||
        text.contains('اكتب') ||
        text.contains('كتابة') ||
        text.contains('تفكير')) {
      return Colors.pinkAccent;
    }
    if (text.contains('breath') ||
        text.contains('meditate') ||
        text.contains('تنفس') ||
        text.contains('هدوء')) {
      return Colors.amber;
    }
    if (text.contains('smile') ||
        text.contains('happy') ||
        text.contains('ابتسم')) {
      return Colors.greenAccent;
    }
    if (text.contains('read') ||
        text.contains('study') ||
        text.contains('قراءة') ||
        text.contains('دراسة')) {
      return Colors.tealAccent;
    }
    if (text.contains('exercise') || text.contains('تمرين')) {
      return Colors.redAccent;
    }
    if (text.contains('music') || text.contains('موسيقى')) {
      return Colors.deepPurpleAccent;
    }
    if (text.contains('sleep') || text.contains('نوم')) {
      return Colors.indigoAccent;
    }
    return _fallbackColors[title.hashCode.abs() % _fallbackColors.length];
  }

  TaskItem _createTaskItem(String title) {
    return TaskItem(
      title: title,
      icon: _iconForTask(title),
      color: _colorForTask(title),
    );
  }

  Future<bool> _confirmDelete(int index) async {
    final palette = AppPalette.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: palette.surfaceAlt,
              title: Text(
                CustomLocalizations.of(context).get('deleteTaskTitle'),
                style: TextStyle(color: palette.textPrimary),
              ),
              content: Text(
                CustomLocalizations.of(context).get('deleteTaskConfirmation'),
                style: TextStyle(color: palette.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(CustomLocalizations.of(context).get('cancel')),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    CustomLocalizations.of(context).get('delete'),
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            );
          },
        ) ==
        true;
  }

  void _showDeletedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(CustomLocalizations.of(context).get('taskDeleted')),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _toggleTask(int index, bool? checked) {
    setState(() {
      _tasks[index].completed = checked ?? false;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _addTask() {
    final String text = _taskController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _tasks.add(_createTaskItem(text));
      _taskController.clear();
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          localizations.microTasks,
          style: TextStyle(color: palette.textPrimary, fontSize: 22),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: palette.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 120,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: palette.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Small steps, big changes',
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProgressCard(),
                  const SizedBox(height: 20),
                  Expanded(child: _buildTaskList()),
                  const SizedBox(height: 16),
                  _buildAddTaskField(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Progress",
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$_completedCount/$_totalTaskCount',
            style: TextStyle(color: palette.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: palette.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                _progress >= 1 && _totalTaskCount > 0
                    ? Colors.greenAccent
                    : palette.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final palette = AppPalette.of(context);
    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.list_alt,
              size: 72,
              color: palette.textSecondary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet. Add one below!',
              style: TextStyle(color: palette.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final TaskItem task = _tasks[index];
        return Dismissible(
          key: ValueKey(task.title + index.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(index),
          onDismissed: (_) {
            _removeTask(index);
            _showDeletedSnackBar();
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.border),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: task.completed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  activeColor: palette.primary,
                  side: BorderSide(
                    color: palette.textSecondary.withOpacity(0.4),
                  ),
                  onChanged: (value) => _toggleTask(index, value),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: task.completed
                              ? palette.textSecondary
                              : palette.textPrimary,
                          fontSize: 16,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: task.color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.completed ? 'Completed' : 'Not done yet',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(task.icon, color: task.color, size: 26),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    final bool confirmed = await _confirmDelete(index);
                    if (confirmed) {
                      _removeTask(index);
                      _showDeletedSnackBar();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddTaskField() {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              style: TextStyle(color: palette.textPrimary),
              decoration: InputDecoration(
                hintText: CustomLocalizations.of(context).get('addCustomTask'),
                hintStyle: TextStyle(color: palette.textSecondary),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addTask(),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _addTask,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: palette.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
