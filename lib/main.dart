// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'login.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'IP Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   // ✅ Create a TextEditingController
//   final TextEditingController _textController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // ✅ TextField with controller
//               TextField(
//                 controller: _textController,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Your Ip Address',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // ✅ ElevatedButton
//               ElevatedButton(
//                 onPressed: () {
//                   _send_data();
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _send_data() async{
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     sh.setString('url', 'http://${_textController.text}:8000/myapp');
//     sh.setString('img_url', 'http://${_textController.text}:8000');
//     Navigator.push(context, MaterialPageRoute(
//       // builder: (context) => MyLoginPage(title: "Login"),));
//       builder: (context) =>MyLoginPage(title: '',),));
//
//   }
//
// }



import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart'; // ← your actual login import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRM Setup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
      home: const IpSetupPage(title: 'Server Configuration'),
    );
  }
}

class IpSetupPage extends StatefulWidget {
  const IpSetupPage({super.key, required this.title});
  final String title;

  @override
  State<IpSetupPage> createState() => _IpSetupPageState();
}

class _IpSetupPageState extends State<IpSetupPage> with SingleTickerProviderStateMixin {
  final TextEditingController _ipController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _saveAndNavigate() async {
    if (_ipController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter server IP")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final cleanIp = _ipController.text.trim();

    await prefs.setString('url', 'http://$cleanIp:8000/myapp');
    await prefs.setString('img_url', 'http://$cleanIp:8000');

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyLoginPage(title: 'Login'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          const AnimatedGradientBackground(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 40),

                          // Logo / Icon area
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.cloud_upload_rounded,
                              size: 72,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 32),

                          Text(
                            "CRM Server Setup",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "Enter your server IP address to connect",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 48),

                          // Glassmorphism card
                          ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: BackdropFilter(
                              filter: const ColorFilter.mode(
                                Colors.white10,
                                BlendMode.srcOver,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.09),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: Colors.white12, width: 1.2),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Server IP",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _ipController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.go,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "192.168.1.100",
                                        hintStyle: TextStyle(color: Colors.white38),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.08),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 18,
                                        ),
                                      ),
                                      onSubmitted: (_) => _saveAndNavigate(),
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: FilledButton.icon(
                                        icon: const Icon(Icons.arrow_forward_rounded),
                                        label: const Text("Connect", style: TextStyle(fontSize: 17)),
                                        style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: _saveAndNavigate,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────
//  Subtle continuous animated gradient background
// ────────────────────────────────────────────────
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(_animation.value),
                math.sin(_animation.value),
              ),
              end: Alignment(
                math.cos(_animation.value + math.pi),
                math.sin(_animation.value + math.pi),
              ),
              colors: const [
                Color(0xFF2A1B5F),
                Color(0xFF44318D),
                Color(0xFF6B4BB3),
                Color(0xFF44318D),
                Color(0xFF2A1B5F),
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        );
      },
    );
  }
}
