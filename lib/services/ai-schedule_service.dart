import "package:flutter/foundation.dart";
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/task_model.dart';
import '../models/schedule_analysis.dart';


class AiScheduleService extends ChangeNotifier{
    ScheduleAnalysis? _scheduleAnalysis;
    bool _isLoading = false;
    String? _errorMessage;

    final String _apikey = 'YOUR_API_KEY_HERE';


    ScheduleAnalysis get _currentAnalysis => _currentAnalysis;
    bool get isLoading => _isLoading;
    String? get errorMessage => _errorMessage;

Future<void> analyzeSchedule(List<TaskModel> tasks) async{
    if (_apikey.isEmpty || tasks.isEmpty) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

try {
    final model = GenerativeModel(Mmodel: 'gemini-2.5-flash', apiKey: _apikey);
    final tasksJson = jsonEncod (tasks.map((task) => task.toJson()).toList());
    final prompt = 
    '''


    You are a an expert student scheduling assistant. The user has provided the following tasks
    for their day in JSON format $tasksJson

    Your Job is to analyze these tasks, identify any overlaps or conflicts in 
    the their start and end times, and suggest a better balanced schedule Consider their
    urgency, importance, and required energy level.

    Provide exactly 4 sections of markdown text:

    1. ### Detected Conflicts 
    List any scheduling conflicts
    2. ### Ranked Tasks 
    Rank which tasks need attention first based on urgency, importance, and energy. Provide
    a brief reason for each.
    3. ### Suggested Schedule
    Provide a revised daily timeline view adjusting the tasks time to resolve conflicts and balanced
    the student's workload, study time and rest.
    4. ### Explanation
    Explanation why this recommendation was made in simple language that a student would easily
    understand.

    Ensure the markdown is well formatted and easy to read. Do not include extra text outside
    of these headers.

''',


final content = [content.text(prompt)]
final response = await model.generateContent(content);

// final text = response.text ?? '';

// final analysis = parseResponse(text);

// _currentAnalysis = analysis;


_currentAnalysis = _parseResponse(response.text ?? '');

} catch (e){
    _errorMessage = "failed to analyze schedule: \$e";
    
} finally {
    _isLoading = false;
    notifyListeners();
}

}

Sceduleanalysis _parseResponse(String fullText){
    String conflicts = '',
    rankedTasks = '',
    recommendedSchedule = '',
    explanation = '';

    final section = fullText..split('#### ');
    for (var section in sections){
        if (section.starstWith('Detected Conflicts')){
            conflicts = section.replaceFirst('Detected Conflicts', '').trim();
        } else if (section.startsWith('Ranked Tasks')){
            rankedTasks = section.replaceFirst('Ranked Tasks', '').trim();
        } else if (section.startsWith('Recommended Schedule')){
            recommendedSchedule = section.replaceFirst('Recommended Schedule', '').trim();
        } else if (section.startsWith('Explanation')){
            explanation = section.replaceFirst('Explanation', '').trim();
        }
    }
}

}