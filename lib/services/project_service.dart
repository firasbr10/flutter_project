import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';

class ProjectService {
  final CollectionReference _projectsCollection = FirebaseFirestore.instance.collection('projects');

  Future<void> createProject(Project project) async {
    await _projectsCollection.add(project.toMap());
  }

  Future<List<Project>> getUserProjects(String uid) async {
    final query = await _projectsCollection
        .where('members.$uid', isGreaterThanOrEqualTo: '')
        .get();

    return query.docs.map((doc) => Project.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addMember(String projectId, String memberUid, String role) async {
    await _projectsCollection.doc(projectId).update({
      'members.$memberUid': role,
    });
  }

  Future<Project?> getProjectById(String projectId) async {
    final doc = await _projectsCollection.doc(projectId).get();
    if (doc.exists) {
      return Project.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
