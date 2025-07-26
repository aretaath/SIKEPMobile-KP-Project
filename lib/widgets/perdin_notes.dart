import 'package:flutter/material.dart';

class PerdinNotes extends StatelessWidget {
  final bool showForm;
  final List<String> savedNotes;
  final TextEditingController controller;
  final VoidCallback toggleForm;
  final void Function(String) onSave;

  const PerdinNotes({
    super.key,
    required this.showForm,
    required this.savedNotes,
    required this.controller,
    required this.toggleForm,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF38C7A8),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 12),
          if (showForm) _noteForm(context),
          ...savedNotes.map((e) => _noteCard(e)).toList(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Catatan Perjalanan Dinas',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      GestureDetector(
        onTap: toggleForm,
        child: Icon(showForm ? Icons.close : Icons.add, color: Colors.white),
      ),
    ],
  );

  Widget _noteForm(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Color(0x3f000000),
          offset: Offset(0, 0),
          blurRadius: 5,
        ),
      ],
    ),
    padding: const EdgeInsets.all(14),
    child: Column(
      children: [
        TextField(
          controller: controller,
          maxLines: null,
          expands: false,
          decoration: InputDecoration(
            hintText: 'Tulis catatan ...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff3cbb92),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () {
              if (controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Catatan tidak boleh kosong')),
                );
                return;
              }
              onSave(controller.text.trim());
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
  );

  Widget _noteCard(String note) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(12),
    child: Text(note, style: const TextStyle(fontSize: 16)),
  );
}
