import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  bool _showUsers = false; // Controls visibility of user list

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    final user = await _authController.signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (user != null) {
      final newUser = UserModel(email: _emailController.text.trim());
      await _authController.addUserToFirestore(newUser);
      _showPopup("Success 🎉", "User registered successfully!");
    } else {
      _showPopup("Error ❌", "Registration failed. Please try again.");
    }
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    final user = await _authController.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (user != null) {
      _showPopup("Success 🎉", "User signed in successfully!");
    } else {
      _showPopup("Error ❌", "Sign-in failed. Check your credentials.");
    }
  }

  void _showPopup(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.pinkAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ✨ Stylish Card with Glass Effect
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.email, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                ElevatedButton(
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.pinkAccent,
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _signUp,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.deepPurpleAccent,
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                /// 🎀 Floating Toggle Button for User List
                FloatingActionButton.extended(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  onPressed: () {
                    setState(() {
                      _showUsers = !_showUsers;
                    });
                  },
                  label: Text(
                    _showUsers ? "Hide Registered Users" : "Show Registered Users",
                    style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.people, color: Colors.pinkAccent),
                ),

                /// 👇 Smooth Transition for User List
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _showUsers
                      ? Container(
                          key: const ValueKey(1),
                          margin: const EdgeInsets.only(top: 15),
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: StreamBuilder<List<UserModel>>(
                            stream: _authController.getUsers(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(child: Text("No users found"));
                              }
                              final users = snapshot.data!;
                              return ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  return ListTile(
                                    leading: const Icon(Icons.person, color: Colors.pinkAccent),
                                    title: Text(user.email, style: const TextStyle(color: Colors.black)),
                                    subtitle: Text(user.timestamp?.toDate().toString() ?? 'No timestamp'),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : const SizedBox(key: ValueKey(2)), // Empty space when hidden
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
