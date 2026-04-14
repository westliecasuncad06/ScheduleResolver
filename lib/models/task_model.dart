import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final String name;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int urgency; // 1-5
  final int importance; // 1-5
  final int energyLevel; // 1-5

  TaskModel({
    String? id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.urgency,
    required this.importance,
    required this.energyLevel,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'urgency': urgency,
      'importance': importance,
      'energyLevel': energyLevel,
    };
  }
}
