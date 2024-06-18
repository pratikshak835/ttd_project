import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/bloc/authentication_state.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/cubit/authentication_cubit.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/widgets/add_user_dialog.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/widgets/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();

  void getUser() {
    context.read<AuthenticationCubit>().getUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          debugPrint("test message ${state.message}");
        } else if (state is UserCreated) {
          getUser();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUser
              ? const LoadingColumn(message: "Fetching User")
              : state is CreatingUser
                  ? const LoadingColumn(message: "Creating User")
                  : state is UserLoaded
                      ? Center(
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              return ListTile(
                                leading: Image.network(user.avatar),
                                title: Text(user.name),
                                subtitle: Text(user.createdAt.substring(10)),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) => AddUserDialog(
                          nameController: nameController,
                        ));
              },
              icon: const Icon(Icons.add),
              label: const Text("Add user")),
        );
      },
    );
  }
}
