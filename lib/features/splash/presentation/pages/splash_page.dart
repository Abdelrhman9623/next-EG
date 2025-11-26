import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';

/// Splash screen page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Check version when page loads
    context.read<SplashCubit>().checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          // Navigate to next screen when version check is complete
          if (state.isVersionChecked) {
            // TODO: Navigate to home or login screen
            // For now, just show a message
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.orange,
                ),
              );
            }

            // Navigate after a short delay
            Future.delayed(const Duration(seconds: 1), () {
              // Example: Navigate to home
              // Navigator.of(context).pushReplacementNamed('/home');
            });
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo or Icon
                Icon(
                  Icons.flutter_dash,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // App Name
                Text(
                  'Next App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),

                // Loading indicator
                if (state.isLoading)
                  const CircularProgressIndicator()
                else if (state.isVersionChecked)
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
              ],
            ),
          );
        },
      ),
    );
  }
}
