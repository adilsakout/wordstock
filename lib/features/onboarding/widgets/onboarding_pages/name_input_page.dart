import 'package:flutter/material.dart';
import 'package:wordstock/features/onboarding/cubit/cubit.dart';
import 'package:wordstock/widgets/button.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'What is your name?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your name will be used to personalize your experience.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffCECECE)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF77D728), width: 2),
              ),
              hintText: 'Enter your name',
              hintStyle: TextStyle(
                color: Color(0xffCECECE),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PushableButton(
                width: 200,
                height: 60,
                text: 'Next',
                onTap: () {
                  final name = _nameController.text.trim();
                  context.read<OnboardingCubit>().setUserName(name);
                },
              ),
              const SizedBox(width: 10),
              PushableButton(
                width: 90,
                height: 60,
                buttonColor: const Color(0xffFFC20E),
                shadowColor: const Color(0xffCDB054),
                text: 'Skip',
                onTap: () {
                  context.read<OnboardingCubit>().nextPage();
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
