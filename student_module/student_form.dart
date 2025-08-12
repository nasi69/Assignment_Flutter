import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_3/student_module/message.util.dart';
import 'package:flutter_application_3/student_module/student_model.dart';
import 'package:flutter_application_3/student_module/student_service.dart';

// Import your models and services accordingly
// import 'your_model_file.dart';
// import 'your_service_file.dart';

class StudentForm extends StatefulWidget {
  final Datum? item;
  final bool editMode;

  StudentForm({this.item, this.editMode = false});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _khmer_nameCtrl;
  late TextEditingController _latin_nameCtrl;
  late TextEditingController _genderCtrl; // string input for simplicity
  late TextEditingController _telCtrl;
  late TextEditingController _addressCtrl;

  bool _changed = false;
  String _output = "output";
  @override
  void initState() {
    super.initState();
    _khmer_nameCtrl = TextEditingController(
      text: widget.editMode ? widget.item?.khmer_name ?? "" : "",
    );
    _latin_nameCtrl = TextEditingController(
      text: widget.editMode ? widget.item?.latin_name ?? "" : "",
    );
    _genderCtrl = TextEditingController(
      text: widget.editMode ? widget.item?.gender ?? "" : "",
    );
    _telCtrl = TextEditingController(
      text: widget.editMode ? widget.item?.tel ?? "" : "",
    );
    _addressCtrl = TextEditingController(
      text: widget.editMode ? widget.item?.address ?? "" : "",
    );
  }

  @override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, res) {
      if (!didPop) {
        Navigator.of(context).pop(_changed);
      }
    },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(_changed);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(this.widget.editMode ? "Edit Student" : "Add Student"),
        actions: [this.widget.editMode ? _buildDeleteButton() :SizedBox()],
      ),
      body: _buildBody(),
    ),
  );
}

Future<bool?> _buildDeleteDialog() {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete Student"),
        content: const Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}

Widget _buildDeleteButton() {
  return IconButton(
    onPressed: () async {
      bool? deleted = await showDeleteDialog(context)??false;
      if (deleted) {
        StudentService.delete(widget.item!.id)
            .then((value) {
              setState(() {
                _output = value.toString();
              });
              _changed = value;
              Navigator.of(context).pop(_changed);
            })
            .onError((e, s) {
              setState(() {
                _output = "Error: ${e.toString()}";
              });
            });
      }
    },
    icon: const Icon(Icons.delete),
  );
}

Widget _buildBody() {
  return Form(
    key: _formKey,
    child: ListView(
      padding: const EdgeInsets.all(10),
      children: [
        _buildTextField(_khmer_nameCtrl, "Khmer Name"),
        const SizedBox(height: 12),
        _buildTextField(_latin_nameCtrl, "Latin Name"),
        const SizedBox(height: 12),
        _buildTextField(_genderCtrl, "Gender"),
        const SizedBox(height: 12),
        // _buildDobField(), // special date picker field
        const SizedBox(height: 12),
        _buildTextField(_telCtrl, "Telephone"),
        const SizedBox(height: 12),
        _buildTextField(_addressCtrl, "Address"),
        const SizedBox(height: 20),
        _buildButton(),
        const SizedBox(height: 12),
        _buildOutput(),
      ],
    ),
  );
}

Widget _buildTextField(TextEditingController controller, String label) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "$label is required.";
      }
      return null;
    },
  );
}

Widget _buildNameField() {
  return TextFormField(
    controller: _latin_nameCtrl,
    decoration: const InputDecoration(
      labelText: "Name",
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Name is required.";
      }
      return null;
    },
  );
}

Widget _buildButton() {
  return ElevatedButton(
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        if (widget.editMode) {
          _onUpdateStudent();
        } else {
          _onAddStudent();
        }
      }
    },
    child: const Text("Save Student"),
  );
}

Widget _buildOutput() {
  return Text(_output);
}

  void _onAddStudent() {
    Datum item = Datum(
      id: 0,
      khmer_name: _khmer_nameCtrl.text.trim(),
      latin_name: _latin_nameCtrl.text.trim(),
      gender: _genderCtrl.text.trim(),
      dob: DateTime.now().toIso8601String(),
      tel: _telCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    StudentService.insert(item)
        .then((value) {
          setState(() {
            _output = value.toString();
            _changed = value;
          });
          if (value == true) {
          Navigator.of(context).pop(true); // Pop and return true to signal change
        }
        })
        .onError((e, s) {
          setState(() {
            _output = "Error: ${e.toString()}";
          });
        });
  }

  void _onUpdateStudent() {
    Datum item = Datum(
      id: widget.item!.id,
      khmer_name: _khmer_nameCtrl.text.trim(),
      latin_name: _latin_nameCtrl.text.trim(),
      gender: _genderCtrl.text.trim(),
      dob: widget.item!.dob,
      tel: _telCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      createdAt: widget.item!.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
    StudentService.update(item)
        .then((value) {
          setState(() {
            _output = value.toString();
            _changed = value;
          });
          if (value == true) {
          Navigator.of(context).pop(true); // Pop and return true to signal change
        }
        })
        .onError((e, s) {
          setState(() {
            _output = "Error: ${e.toString()}";
          });
        });
  }
}
