import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'form_provider.dart';

class AutoDisposeExampleScreen extends ConsumerWidget {
  const AutoDisposeExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(formProvider);
    final counter = ref.watch(tempCounterProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: _buildBackgroundDecoration(),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFormTitle(),
              const SizedBox(height: 24),

              // Name Field
              _buildTextField(
                label: 'Name',
                value: formData.name,
                onChanged: (value) =>
                    ref.read(formProvider.notifier).updateName(value),
                hintText: 'Enter your name',
              ),
              const SizedBox(height: 16),

              // Email Field
              _buildTextField(
                label: 'Email',
                value: formData.email,
                onChanged: (value) =>
                    ref.read(formProvider.notifier).updateEmail(value),
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Message Field
              _buildTextArea(
                label: 'Message',
                value: formData.message,
                onChanged: (value) =>
                    ref.read(formProvider.notifier).updateMessage(value),
                hintText: 'Enter your message',
              ),
              const SizedBox(height: 24),

              // Submit Button
              _buildSubmitButton(context, ref),

              const SizedBox(height: 48),

              // Temp Counter Example
              _buildCounterCard(ref, counter),

              const SizedBox(height: 24),

              // Info Card
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  // Build App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('AutoDispose Provider Example'),
      backgroundColor: Colors.green,
    );
  }

  // Build Background Decoration
  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green[50]!, Colors.blue[50]!],
      ),
    );
  }

  // Build Form Title
  Widget _buildFormTitle() {
    return const Text(
      'Contact Form',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Build Submit Button
  Widget _buildSubmitButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final success = await ref.read(formProvider.notifier).submit();
        if (success) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Form submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Reset form after submission
          ref.read(formProvider.notifier).reset();
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Please fill all fields correctly!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Submit Form',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Build Counter Card
  Widget _buildCounterCard(WidgetRef ref, int counter) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Temporary Counter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Count: $counter',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      ref.read(tempCounterProvider.notifier).state--,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(tempCounterProvider.notifier).state++,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This counter will reset when you leave the page',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build Info Card
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'AutoDispose Provider Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'These providers will be automatically disposed when you navigate away from this page, cleaning up resources and preventing memory leaks.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Check the console for initialization and disposal messages.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          controller: TextEditingController(text: value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildTextArea({
    required String label,
    required String value,
    required Function(String) onChanged,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          controller: TextEditingController(text: value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
