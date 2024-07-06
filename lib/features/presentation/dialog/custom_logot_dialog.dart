import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomLogOutDialog extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onUnregister;

  const CustomLogOutDialog(
      {required this.onUnregister, Key? key, required this.onLogout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Iconsax.logout, color: Colors.red),
                const Text(
                  'Sign Out?',
                  style: TextStyle(fontFamily: 'PaynetB', fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Iconsax.close_circle,
                      color: const Color(0xFFF26B6C)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Do you want unregister or logout?',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'PaynetB', fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: onUnregister,
                  child: const Text(
                    'Unregister',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26B6C),
                  ),
                  onPressed: onLogout,
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
