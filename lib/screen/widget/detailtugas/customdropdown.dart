import 'package:flutter/material.dart';

Widget levelDropdownWidget(
    BuildContext context, String initialValue, ValueChanged<String> onChanged) {
  // Track whether the menu is open
  bool isMenuOpen = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Pilih Role User",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  isMenuOpen = !isMenuOpen;
                });
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      initialValue,
                      style: const TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 16,
                      ),
                    ),
                    AnimatedRotation(
                      turns: isMenuOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Custom dropdown menu that always appears below the field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height:
                isMenuOpen ? (2 * 44.0) + 1 : 0, // Height for 2 items + divider
            margin: const EdgeInsets.only(top: 4),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isMenuOpen
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMenuItem("Member", initialValue, () {
                    onChanged("Member");
                    setState(() {
                      isMenuOpen = false;
                    });
                  }),
                  const Divider(height: 1, thickness: 1),
                  _buildMenuItem("Admin", initialValue, () {
                    onChanged("Admin");
                    setState(() {
                      isMenuOpen = false;
                    });
                  }),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget visibilityDropdownWidget(
    BuildContext context, String initialValue, ValueChanged<String> onChanged) {
  // Track whether the menu is open
  bool isMenuOpen = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Visibilitas",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'Helvetica',
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  isMenuOpen = !isMenuOpen;
                });
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      initialValue,
                      style: const TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 16,
                      ),
                    ),
                    AnimatedRotation(
                      turns: isMenuOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Custom dropdown menu that always appears below the field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height:
                isMenuOpen ? (2 * 44.0) + 1 : 0, // Height for 2 items + divider
            margin: const EdgeInsets.only(top: 4),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isMenuOpen
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMenuItem("Public", initialValue, () {
                    onChanged("Public");
                    setState(() {
                      isMenuOpen = false;
                    });
                  }),
                  const Divider(height: 1, thickness: 1),
                  _buildMenuItem("Private", initialValue, () {
                    onChanged("Private");
                    setState(() {
                      isMenuOpen = false;
                    });
                  }),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Helper method to build menu items
Widget _buildMenuItem(String value, String selectedValue, VoidCallback onTap) {
  final isSelected = value == selectedValue;

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
      child: Text(
        value,
        style: TextStyle(
          fontFamily: 'Helvetica',
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF293066) : Colors.black,
        ),
      ),
    ),
  );
}
