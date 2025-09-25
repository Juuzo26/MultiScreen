import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const UserListScreen(),
    );
  }
}

class User {
  final String name;
  final String email;
  final int age;

  const User({required this.name, required this.email, required this.age});

  User copyWith({String? name, String? email, int? age}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<User> _users = <User>[];

  Future<void> _addUser() async {
    final User? createdUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(builder: (context) => const UserFormScreen()),
    );

    if (createdUser != null) {
      setState(() {
        _users.insert(0, createdUser);
      });
    }
  }

  Future<void> _editUser(int index) async {
    final User existingUser = _users[index];
    final User? updatedUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => UserFormScreen(initialUser: existingUser),
      ),
    );

    if (updatedUser != null) {
      setState(() {
        _users[index] = updatedUser;
      });
    }
  }

  void _deleteUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body:
          _users.isEmpty
              ? const Center(child: Text('No users yet. Tap + to add.'))
              : ListView.separated(
                itemBuilder: (context, index) {
                  final User user = _users[index];
                  return Dismissible(
                    key: ValueKey('user-${user.email}-$index'),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.red.withOpacity(0.85),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red.withOpacity(0.85),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _deleteUser(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Deleted ${user.name}')),
                      );
                    },
                    child: ListTile(
                      title: Text(user.name),
                      subtitle: Text('${user.email} • Age ${user.age}'),
                      onTap: () => _editUser(index),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemCount: _users.length,
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserFormScreen extends StatefulWidget {
  final User? initialUser;

  const UserFormScreen({super.key, this.initialUser});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialUser?.name ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialUser?.email ?? '',
    );
    _ageController = TextEditingController(
      text:
          widget.initialUser != null ? widget.initialUser!.age.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final int age = int.parse(_ageController.text.trim());

    final User result = User(name: name, email: email, age: age);
    Navigator.pop(context, result);
  }

  String get _title => widget.initialUser == null ? 'Add User' : 'Edit User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final String text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return 'Please enter an email';
                  }
                  final RegExp emailRegex = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  );
                  if (!emailRegex.hasMatch(text)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final String text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return 'Please enter age';
                  }
                  final int? parsed = int.tryParse(text);
                  if (parsed == null) {
                    return 'Age must be a number';
                  }
                  if (parsed < 0) {
                    return 'Age cannot be negative';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _onSave(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onSave,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
