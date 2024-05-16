import 'package:flutter/material.dart';
import 'package:frenc_app/model/tutor.dart';
import 'package:frenc_app/repository/global.repository.dart';

class NewTutorScreen extends StatefulWidget {
  const NewTutorScreen({super.key});

  @override
  State<NewTutorScreen> createState() => _NewTutorScreenState();
}

class _NewTutorScreenState extends State<NewTutorScreen> {
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayInputDiaglog,
        backgroundColor: Colors.blue.shade400,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('New Tutor'),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _messagesListView(),
      ],
    ));
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseRepository.getTutors(),
        builder: (context, snapshots) {
          List tutors = snapshots.data?.docs ?? [];
          if (tutors.isEmpty) {
            return const Center(
              child: Text('No tutors found'),
            );
          }
          return ListView.builder(
              itemCount: tutors.length,
              itemBuilder: (context, index) {
                Tutor tutor = tutors[index].data();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(tutor.name),
                    subtitle: Text(tutor.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        //_databaseRepository.deleteTutor(tutors[index].id);
                      },
                    ),
                    onLongPress: () {
                      _databaseRepository.deleteTutor(tutors[index].id);
                    },
                  ),
                );
              });
        },
      ),
    );
  }

  void _displayInputDiaglog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("New tutor"),
            content: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Tutor tutor = Tutor(
                    name: _controller.text,
                    email: 'test',
                    password: 'test',
                    code: 123,
                  );
                  _databaseRepository.addTutor(tutor);
                  Navigator.pop(context);
                  _controller.clear();
                },
                color: Colors.blue.shade300,
                textColor: Colors.white,
                child: const Text('Save'),
              )
            ],
          );
        });
  }
}
