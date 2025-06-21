import 'package:flutter/material.dart';
import 'meeting.dart';

class Course {
  final String name;
  final List<Meeting> meetings;

  Course({required this.name, required this.meetings});
}