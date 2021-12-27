import 'package:flutter/material.dart';
import 'package:students/data/commands/student_commands.dart';
import 'package:students/data/models/student.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Student> students;

  TextEditingController studentnameController = TextEditingController();
  TextEditingController studentAgeController = TextEditingController();
  TextEditingController studentIdContoller = TextEditingController();

  void refreshStudents() {
    getStudents().then((studentsData) {
      setState(() {
        students = studentsData;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  deleteStudent(students[index].id);
                  refreshStudents();
                });
              },
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.blue),
                        child: Text(
                          students[index].id.toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                title: Text(students[index].name),
                subtitle: Text("Age: " + students[index].age.toString()),
              ),
            );
          },
          itemCount: students.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // insertStudent(Student(id: 4, name: "Guja Markozashvili", age: 21));
          // refreshStudents();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("Create Student"),
                    content: Form(
                      key: _formKey,
                      child: SizedBox(
                        height: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              controller: studentIdContoller,
                              decoration: const InputDecoration(
                                  hintText: "Enter student id"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter valid id";
                                }
                              },
                            ),
                            TextFormField(
                              controller: studentnameController,
                              decoration: const InputDecoration(
                                  hintText: "Enter student name"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter valid name";
                                }
                              },
                            ),
                            TextFormField(
                              controller: studentAgeController,
                              decoration: const InputDecoration(
                                  hintText: "Enter student age"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter valid age";
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              insertStudent(Student(
                                  id: int.parse(studentIdContoller.text),
                                  name: studentnameController.text,
                                  age: int.parse(studentAgeController.text)));
                              studentIdContoller.clear();
                              studentnameController.clear();
                              studentAgeController.clear();
                              setState(() {
                                refreshStudents();
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Add")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))
                    ],
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
