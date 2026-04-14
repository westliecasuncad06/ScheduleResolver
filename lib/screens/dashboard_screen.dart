import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../services/ai_schedule_service.dart';
import '../providers/schedule_provider.dart';
import 'task_input_screen.dart';
import 'recomendation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final aiService = Provider.of<AiScheduleService>(context);
    final sortingTasks = List<TaskModel>.from(scheduleProvider.tasks);
    sortingTasks.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Resolver'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (aiService.errorMessage != null)
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    aiService.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            if (aiService.currentAnalysis != null)
              Card(
                color: Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Recommendation Ready!!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecommendationScreen(),
                          ),
                        ),
                        child: const Text('View Recommendation'),
                      ),
                    ],
                  ),
                ),
              ), // Card
            const SizedBox(height: 16),
            Expanded(
              child: sortingTasks.isEmpty
                  ? const Center(child: Text('No task!'))
                  : ListView.builder(
                      itemCount: sortingTasks.length,
                      itemBuilder: (context, index) {
                        final task = sortingTasks[index];
                        return Card(
                          child: ListTile(
                            title: Text(task.name),
                            subtitle: Text(
                              '${task.urgency} | ${task.startTime.hour} : ${task.startTime.minute}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  scheduleProvider.removeTask(task.id),
                            ),
                          ), // ListTile
                        ); // Card
                      },
                    ), // ListView.builder // Expanded
            ),
            if (sortingTasks.isNotEmpty)
              ElevatedButton(
                onPressed: aiService.isLoading
                    ? null
                    : () => aiService.analyzeSchedule(scheduleProvider.tasks),
                child: aiService.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Resolve Conflicts with AI'),
              ), // ElevatedButton
          ],
        ), // Column
      ), // Padding
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskInputScreen()),
        ),
        child: const Icon(Icons.add),
      ), // FloatingActionButton
    ); // Scaffold
  }
}