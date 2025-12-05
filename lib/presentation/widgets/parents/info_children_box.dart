import 'package:flutter/material.dart';

class InfoChildrenBox extends StatefulWidget {
  final String childrenName;
  final DateTime? birthDate;
  final Function(String) onNameChanged;
  final Function(DateTime) onBirthDateChanged;

  const InfoChildrenBox({
    super.key,
    required this.childrenName,
    this.birthDate,
    required this.onNameChanged,
    required this.onBirthDateChanged,
  });

  @override
  State<InfoChildrenBox> createState() => _InfoChildrenBoxState();
}

class _InfoChildrenBoxState extends State<InfoChildrenBox> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.childrenName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8A5CF6),
              onPrimary: Colors.white,
              onSurface: Color(0xFF170444),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.birthDate) {
      widget.onBirthDateChanged(picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'DD/MM/AAAA';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     width: 362,
      height: 92,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Nombre section
          Positioned(
            left: 30,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: Color(0xFF8A5CF6),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Nombre',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF170444),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showNameEditDialog(context),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Color(0xFF8A5CF6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 120,
                  child: Center(
                    child: Text(
                      widget.childrenName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF170444),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider vertical
          Positioned(
            left: 181,
            top: 0,
            child: Container(
              width: 1,
              height: 92,
              color: const Color(0xFFE6E6E6),
            ),
          ),
          // Fecha de nacimiento section
          Positioned(
            left: 210,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Color(0xFF8A5CF6),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Fecha de Nacimiento',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF170444),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 40),
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        Text(
                          _formatDate(widget.birthDate),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xFF170444),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit,
                          size: 18,
                          color: Color(0xFF8A5CF6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNameEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Editar nombre',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF170444),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xFF170444),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Nombre del niño',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8A5CF6), width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF8A5CF6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            widget.onNameChanged(_nameController.text);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8A5CF6),
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
