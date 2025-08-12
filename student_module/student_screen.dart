import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/student_module/message.util.dart';
import 'package:flutter_application_3/student_module/student_font_logic.dart';
import 'package:flutter_application_3/student_module/student_form.dart';
import 'package:flutter_application_3/student_module/student_model.dart';
import 'package:flutter_application_3/student_module/student_service.dart';
import 'package:flutter_application_3/student_module/student_theme_logic.dart';
import 'package:provider/provider.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late Future<StudentModel> _futureStudent;

  @override
  void initState() {
    super.initState();
    _futureStudent = StudentService.read();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Student Screen"),
      actions: [
        IconButton(
          onPressed: () async {
            bool edited = await Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => StudentForm()),
            );

            if (edited == true) {
              setState(() {
                _futureStudent = StudentService.read();
              });
            }
          },
          icon: const Icon(Icons.person_add),
        ),
      ],
    ),
    body: _buildBody(),
    drawer: _buildDrawer(),
  );
}


  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureStudent = StudentService.read();
          });
        },
        child: FutureBuilder<StudentModel>(
          future: _futureStudent,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildError(snapshot.error);
            }

            if (snapshot.connectionState == ConnectionState.done) {
              debugPrint("model: ${snapshot.data}");
              return _buildDataModel(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildError(Object? error) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48.0),
          const SizedBox(height: 16.0),
          Text('Error: $error', style: const TextStyle(fontSize: 16.0)),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _futureStudent = StudentService.read();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          )
        ],
      ),
    );
  }

  Widget _buildDataModel(StudentModel?model){
      if(model ==null){
        return SizedBox();
      } 
      return _buildListView(model.data);
  }
  void _deleteitem(Datum item)async{
    bool deleted = await showDeleteDialog(context)??false;
    if (deleted) {
      StudentService.delete(item.id).
      then((value) {
        if(value==true){
        setState(() {
          _futureStudent = StudentService.read();
        });
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error.toString()}")),
        );
      });
    }
  }
  Widget _buildListView(List<Datum> items) {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      debugPrint("item: ${item.latin_name}");
      return Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        confirmDismiss: (direction)async {
          if(direction == DismissDirection.endToStart) {
            _deleteitem(item);
             // Prevents the item from being dismissed immediately
          }
          // TODO: Handle delete logic here
        },
        background: Container(color: Colors.red),
        child: Card(
          child: ListTile(
            title: Text('${item.id},${item.khmer_name} (${item.latin_name})'), // Concatenate names
            subtitle: Text('${item.dob},${item.gender}'),
            trailing: IconButton(onPressed: ()async{
              _deleteitem(item);
            }, 
            icon: Icon(Icons.delete)),
            onTap: () async {
              final edited = await Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => StudentForm(item: item, editMode: true),
                ),
              );

              if (edited == true) {
                setState(() {
                  _futureStudent = StudentService.read();
                });
              }
            },
          ),
        ),
      );
    },
  );
}
Widget _buildDrawer(){
    
   int themeIndex = context.watch<StudentThemeLogic>().themeIndex;
  // final bool dark = context.watch<ThemeLogic>().dark;

  return Drawer(
    child: ListView(
      children: [
        
        // ListTile(
        //   leading: const Icon(CupertinoIcons.moon_fill),
        //   title: const Text("Night Mode"),
        //   // trailing: Switch(
        //   //   // value: dark,
        //   //   // onChanged: (value) {
        //   //   //   context.read<ThemeLogic>().setDark(value);
        //   //   },
        //   ),
        // ),
        ExpansionTile(
          title: const Text("Theme Color"),
          initiallyExpanded: true,
          children: [
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text("To System Mode"),
              onTap: () => context.read<StudentThemeLogic>().changeToSystem(),
              trailing: themeIndex == 0
                  ? const Icon(Icons.check_circle)
                  : null,
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("To Dark Mode"),
              onTap: () => context.read<StudentThemeLogic>().changeToDark(),
              trailing: themeIndex == 1
                  ? const Icon(Icons.check_circle)
                  : null,
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text("To Light Mode"),
              onTap: () => context.read<StudentThemeLogic>().changetoLight(),
              trailing: themeIndex == 2
                  ? const Icon(Icons.check_circle)
                  : null,
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => context.read<StudentFontLogic>().decrease(),
              icon: const Icon(Icons.text_decrease_rounded),
            ),
            IconButton(
              onPressed: () => context.read<StudentFontLogic>().increase(),
              icon: const Icon(Icons.text_increase_rounded),
            ),
          ],
        ),
      ],
    ),
  );

  }

}
