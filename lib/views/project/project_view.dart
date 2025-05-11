import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sup4_dev_trello/models/user_model.dart';
import 'package:sup4_dev_trello/providers/auth_provider.dart';
import 'package:sup4_dev_trello/providers/project_provider.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? _selectedOwner;
  String? _selectedProjectId;
  List<UserModel> _allUsers = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);

    projectProvider.loadUserProjects(authProvider.user!.uid);

    authProvider.fetchAllUsers().then((users) {
      setState(() {
        _allUsers = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);

    // Validating if the selected owner exists in the list
    String? validSelectedOwner = _allUsers.any((u) => u.uid == _selectedOwner) ? _selectedOwner : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Projets")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Créer un projet", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Titre')),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),

            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: validSelectedOwner,
              decoration: const InputDecoration(labelText: 'Sélectionner le propriétaire'),
              items: _allUsers.map((user) {
                return DropdownMenuItem(
                  value: user.uid,
                  child: Text(user.username), // Display username instead of email
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedOwner = val;
                });
              },
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_selectedOwner == null) return;

                await projectProvider.createProject(
                  _titleController.text.trim(),
                  _descController.text.trim(),
                  _selectedOwner!, // Ensure selected owner is valid
                );

                _titleController.clear();
                _descController.clear();
                setState(() {
                  _selectedOwner = null;
                });
              },
              child: const Text("Créer"),
            ),

            const SizedBox(height: 30),
            const Text("Mes projets", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...projectProvider.projects.map((p) => ListTile(
                  title: Text(p.title),
                  subtitle: Text("Chef: ${p.ownerId}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () {
                      setState(() {
                        _selectedProjectId = p.id;
                      });
                      _showAddMemberDialog(context);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    String? _memberUid;
    String _selectedRole = 'invité';

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Ajouter un membre"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _memberUid,
                  hint: const Text("Sélectionner un utilisateur"),
                  items: _allUsers.map((user) {
                    return DropdownMenuItem(
                      value: user.uid,
                      child: Text(user.username), // Display username instead of email
                    );
                  }).toList(),
                  onChanged: (val) {
                    _memberUid = val;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: _selectedRole,
                  onChanged: (val) {
                    _selectedRole = val!;
                  },
                  items: const [
                    DropdownMenuItem(value: 'invité', child: Text('Invité')),
                    DropdownMenuItem(value: 'propriétaire', child: Text('Propriétaire')),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_memberUid != null && _selectedProjectId != null) {
                  await Provider.of<ProjectProvider>(context, listen: false)
                      .addMemberToProject(_selectedProjectId!, _memberUid!, _selectedRole);
                  Navigator.pop(context);
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }
}
