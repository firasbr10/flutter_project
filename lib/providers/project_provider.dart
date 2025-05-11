import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  Future<void> loadUserProjects(String uid) async {
    _projects = await _service.getUserProjects(uid);
    notifyListeners();
  }

  Future<void> createProject(String title, String description, String ownerId) async {
    final newProject = Project(
      id: '', 
      title: title,
      description: description,
      ownerId: ownerId,
      members: {ownerId: 'propriétaire'},
    );

    await _service.createProject(newProject);
    await loadUserProjects(ownerId);
  }

  Future<void> addMemberToProject(String projectId, String uid, String role) async {
    await _service.addMember(projectId, uid, role);
    notifyListeners();
  }
}
