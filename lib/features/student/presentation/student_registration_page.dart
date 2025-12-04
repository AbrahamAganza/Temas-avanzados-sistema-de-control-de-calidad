import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tads/features/student/models/student_model.dart';
import 'package:tads/providers/accessibility_text_provider.dart';
import 'package:tads/providers/student_provider.dart';
import 'package:tads/providers/subject_provider.dart';
import 'package:tads/providers/text_to_speech_provider.dart';
import 'package:tads/providers/voice_assistant_provider.dart';

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({super.key});

  @override
  State<StudentRegistrationPage> createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _paternalSurnameController = TextEditingController();
  final _maternalSurnameController = TextEditingController();
  final _unidad1Controller = TextEditingController();
  final _unidad2Controller = TextEditingController();
  final _unidad3Controller = TextEditingController();

  String? _selectedCarrera;
  String? _selectedSemestre;
  Map<String, bool> _factores = {
    'Académico': false,
    'Psicosocial': false,
    'Institucional': false,
    'Económico': false,
    'Contextual': false,
  };

  final List<String> _carreras = ['Ingeniería de Software', 'Ingeniería Civil', 'Medicina', 'Derecho'];
  final List<String> _semestres = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  bool _isEditing = false;
  String? _editingId;
  bool _isSaving = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _paternalSurnameController.dispose();
    _maternalSurnameController.dispose();
    _unidad1Controller.dispose();
    _unidad2Controller.dispose();
    _unidad3Controller.dispose();
    super.dispose();
  }
  
  Widget _buildSpeakableWidget({required Widget child, required String speechText}) {
    final voiceAssistantProvider = context.watch<VoiceAssistantProvider>();
    final ttsProvider = context.read<TextToSpeechProvider>();

    return Listener(
      onPointerDown: (_) {
        if (voiceAssistantProvider.isEnabled) {
          ttsProvider.speak(speechText);
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityTextProvider = Provider.of<AccessibilityTextProvider>(context, listen: false);
    accessibilityTextProvider.setDescription(
      'Página de registro de estudiantes. Rellene el formulario con los datos del estudiante, incluyendo ID, nombre, apellidos, carrera, semestre, calificaciones y factores de riesgo. Use el botón Guardar para añadir o actualizar un estudiante. La tabla en la parte inferior muestra los estudiantes ya registrados.'
    );

    final studentProvider = context.watch<StudentProvider>();
    final subjectProvider = context.watch<SubjectProvider>();

    if (subjectProvider.selectedSubjectId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Por favor, selecciona una materia antes de registrar estudiantes.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Registro de Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForm(studentProvider, subjectProvider.selectedSubjectId!),
              if (studentProvider.saveStatus != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    studentProvider.saveStatus!,
                    style: TextStyle(
                      color: studentProvider.saveStatus!.startsWith('ERROR') ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              _buildSpeakableWidget(
                speechText: 'Tabla de estudiantes registrados en esta materia',
                child: Text('Estudiantes Registrados', style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: studentProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildStudentTable(studentProvider.students, context.read<StudentProvider>()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(StudentProvider studentProvider, String subjectId) {
     return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpeakableWidget(
            speechText: 'Campo para ID del estudiante',
            child: _buildTextFormField('ID Estudiante', controller: _idController, enabled: !_isEditing),
          ),
          const SizedBox(height: 16),
           _buildSpeakableWidget(
            speechText: 'Campo para nombre del estudiante',
            child: _buildTextFormField(
              'Nombre(s)', 
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) return 'El nombre es obligatorio';
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Solo se permiten letras';
                return null;
              }
            ),
          ),
          const SizedBox(height: 16),
           Row(
            children: [
              Expanded(child: _buildSpeakableWidget(
                speechText: 'Campo para apellido paterno',
                child: _buildTextFormField(
                  'Apellido Paterno', 
                  controller: _paternalSurnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'El apellido es obligatorio';
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Solo se permiten letras';
                    return null;
                  }
                )
              )),
              const SizedBox(width: 16),
              Expanded(child: _buildSpeakableWidget(
                speechText: 'Campo para apellido materno',
                child: _buildTextFormField(
                  'Apellido Materno', 
                  controller: _maternalSurnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'El apellido es obligatorio';
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Solo se permiten letras';
                    return null;
                  }
                )
              )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSpeakableWidget(
                speechText: 'Menú para seleccionar la carrera',
                child: _buildDropdown('Carrera', _carreras, _selectedCarrera, (val) => setState(() => _selectedCarrera = val))
              )),
              const SizedBox(width: 16),
              Expanded(child: _buildSpeakableWidget(
                speechText: 'Menú para seleccionar el semestre',
                child: _buildDropdown('Semestre', _semestres, _selectedSemestre, (val) => setState(() => _selectedSemestre = val))
              )),
            ],
          ),
          const SizedBox(height: 16),
          _buildGradesSection(),
          const SizedBox(height: 16),
          _buildFactorCheckboxes(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _isSaving 
                ? const CircularProgressIndicator() 
                : _buildSpeakableWidget(
                    speechText: _isEditing ? 'Botón para actualizar estudiante' : 'Botón para guardar nuevo estudiante',
                    child: ElevatedButton(
                      onPressed: () => _saveStudent(studentProvider, subjectId),
                      child: Text(_isEditing ? 'Actualizar' : 'Guardar'),
                    ),
                  ),
              const SizedBox(width: 8),
              _buildSpeakableWidget(
                speechText: 'Botón para cancelar y limpiar el formulario',
                child: TextButton(
                  onPressed: _clearForm,
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildGradesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpeakableWidget(
          speechText: 'Sección de calificaciones por unidad',
          child: Text('Calificaciones por Unidad', style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildSpeakableWidget(speechText: 'Campo para calificación de la unidad 1', child: _buildGradeFormField('Unidad 1', _unidad1Controller))),
            const SizedBox(width: 16),
            Expanded(child: _buildSpeakableWidget(speechText: 'Campo para calificación de la unidad 2', child: _buildGradeFormField('Unidad 2', _unidad2Controller))),
            const SizedBox(width: 16),
            Expanded(child: _buildSpeakableWidget(speechText: 'Campo para calificación de la unidad 3', child: _buildGradeFormField('Unidad 3', _unidad3Controller))),
          ],
        ),
      ],
    );
  }

  TextFormField _buildGradeFormField(String label, TextEditingController controller) {
    return _buildTextFormField(
      label,
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        final n = int.tryParse(value);
        if (n == null) return 'Inválido';
        if (n < 0 || n > 100) return '0-100';
        return null;
      },
    );
  }


  TextFormField _buildTextFormField(String label, {required TextEditingController controller, TextInputType? keyboardType, bool enabled = true, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : (label.contains('Nombre') || label.contains('Apellido'))
              ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))]
              : [],
    );
  }

  DropdownButtonFormField<String> _buildDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      value: selectedValue,
      items: items.map((value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Campo obligatorio' : null,
    );
  }

  Widget _buildFactorCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpeakableWidget(
          speechText: 'Sección de factores de riesgo',
          child: const Text('Factores de Riesgo'),
        ),
        Row(
          children: _factores.keys.map((key) {
            return Expanded(
              child: _buildSpeakableWidget(
                speechText: 'Marcar si el factor de riesgo ${key.toLowerCase()} aplica',
                child: CheckboxListTile(
                  title: Text(key),
                  value: _factores[key],
                  onChanged: (value) => setState(() => _factores[key] = value!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  DataTable _buildStudentTable(List<Student> students, StudentProvider studentProvider) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nombre Completo')),
        DataColumn(label: Text('Carrera')),
        DataColumn(label: Text('Semestre')),
        DataColumn(label: Text('Acciones')),
      ],
      rows: students.map((student) {
        final hasGrades = student.calificaciones.values.any((g) => g > 0);
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(student.id)),
            DataCell(Text(student.fullName)),
            DataCell(Text(student.carrera)),
            DataCell(Text(student.semestre)),
            DataCell(Row(
              children: [
                _buildSpeakableWidget(
                  speechText: 'Botón para editar al estudiante ${student.fullName}',
                  child: IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _startEdit(student)),
                ),
                _buildSpeakableWidget(
                  speechText: 'Botón para eliminar al estudiante ${student.fullName}',
                  child: IconButton(
                    icon: Icon(Icons.delete, color: hasGrades ? Colors.grey : Colors.red),
                    onPressed: () {
                      if (hasGrades) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error al Eliminar'),
                            content: const Text('No es posible eliminar a un estudiante que ya tiene calificaciones registradas.'),
                            actions: [
                              TextButton(
                                child: const Text('Aceptar'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        studentProvider.deleteStudent(student.id);
                      }
                    },
                  ),
                ),
              ],
            )),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _saveStudent(StudentProvider studentProvider, String subjectId) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      if (!_isEditing && studentProvider.students.any((s) => s.id == _idController.text)) {
        setState(() {
          studentProvider.saveStatus = 'ERROR: Ya existe un estudiante con el ID ingresado.';
          _isSaving = false;
        });
        return;
      }

      final newStudent = Student(
        id: _idController.text,
        name: _nameController.text.toUpperCase(),
        paternalSurname: _paternalSurnameController.text.toUpperCase(),
        maternalSurname: _maternalSurnameController.text.toUpperCase(),
        carrera: _selectedCarrera ?? '',
        semestre: _selectedSemestre ?? '',
        subjectId: subjectId,
        calificaciones: {
          'Unidad 1': int.tryParse(_unidad1Controller.text) ?? 0,
          'Unidad 2': int.tryParse(_unidad2Controller.text) ?? 0,
          'Unidad 3': int.tryParse(_unidad3Controller.text) ?? 0,
        },
        asistencias: {}, // Let the provider handle the initial value
        factoresRiesgo: Map<String, bool>.from(_factores),
      );

      if (_isEditing) {
        await studentProvider.updateStudent(newStudent, preserveAttendance: true);
      } else {
        await studentProvider.addStudent(newStudent);
      }
      
      _clearForm();
      setState(() => _isSaving = false);
    }
  }

  void _startEdit(Student student) {
    setState(() {
      _isEditing = true;
      _editingId = student.id;

      _idController.text = student.id;
      _nameController.text = student.name;
      _paternalSurnameController.text = student.paternalSurname;
      _maternalSurnameController.text = student.maternalSurname;
      _selectedCarrera = student.carrera;
      _selectedSemestre = student.semestre;
      
      _unidad1Controller.text = student.calificaciones['Unidad 1']?.toString() ?? '';
      _unidad2Controller.text = student.calificaciones['Unidad 2']?.toString() ?? '';
      _unidad3Controller.text = student.calificaciones['Unidad 3']?.toString() ?? '';

      _factores = Map<String, bool>.from(student.factoresRiesgo);
    });
  }

  void _clearForm() {
    setState(() {
      _formKey.currentState?.reset();
      _idController.clear();
      _nameController.clear();
      _paternalSurnameController.clear();
      _maternalSurnameController.clear();
      _unidad1Controller.clear();
      _unidad2Controller.clear();
      _unidad3Controller.clear();
      _selectedCarrera = null;
      _selectedSemestre = null;
      _factores.updateAll((key, value) => false);
      _isEditing = false;
      _editingId = null;
    });
  }
}
