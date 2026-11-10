import 'package:coffeeapp/MainPage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool isObsecure = true;

  // ================= LOGIN INFORMATION =================
  // You can change these values
  final String correctUsername = "sitha";
  final String correctPassword = "123";

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ================= LOGIN FUNCTION =================
  void login() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Check if both fields are empty
    if (username.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check username
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your username'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check password
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check username and password
    if (username == correctUsername &&
        password == correctPassword) {

      // Login successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Go to MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Mainpage(),
        ),
      );
    } else {
      // Wrong username or password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              children: [

                const SizedBox(height: 45),

                // ================= LOGO =================
                Container(
                  width: 90,
                  height: 90,

                  decoration: BoxDecoration(
                    color: const Color(0xFF6F4E37),
                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.local_cafe_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),

                // ================= TITLE =================
                const Text(
                  'Welcome Back!',

                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Login to continue your coffee journey',

                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 40),

                // ================= USERNAME LABEL =================
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Username',

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown[800],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ================= USERNAME =================
                TextField(
                  controller: usernameController,

                  decoration: InputDecoration(
                    label: const Text(
                      'Enter your Username',
                    ),

                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),

                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF6F4E37),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide: BorderSide(
                        color: Colors.brown[100]!,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide: const BorderSide(
                        color: Color(0xFF6F4E37),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= PASSWORD LABEL =================
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Password',

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown[800],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ================= PASSWORD =================
                TextField(
                  controller: passwordController,

                  obscureText: isObsecure,

                  decoration: InputDecoration(
                    label: const Text(
                      'Enter your password',
                    ),

                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF6F4E37),
                    ),

                    // ================= SHOW / HIDE PASSWORD =================
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObsecure = !isObsecure;
                        });
                      },

                      icon: Icon(
                        isObsecure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,

                        color: Colors.grey[600],
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide: BorderSide(
                        color: Colors.brown[100]!,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(14),

                      borderSide: const BorderSide(
                        color: Color(0xFF6F4E37),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ================= LOGIN BUTTON =================
                SizedBox(
                  width: 140,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: login,

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF6F4E37),

                      foregroundColor: Colors.white,

                      elevation: 4,

                      shadowColor:
                      Colors.brown.withOpacity(0.35),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      'Login',

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}