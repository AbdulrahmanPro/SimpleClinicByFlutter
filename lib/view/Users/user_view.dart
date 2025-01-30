import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/usermodel.dart';
import 'package:test_provider_mvvm/provider/user_provider.dart';
import 'package:test_provider_mvvm/view/Users/create_account.dart';
import 'package:test_provider_mvvm/view/widgets/show_delete_dialog.dart';

class UserView extends ConsumerWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersLists = ref.watch(userViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: usersLists.when(
        data: (users) => ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserTile(
                key: Key(user.id.toString()),
                user: user,
                onDelete: () async {
                  bool? confirmDelete =
                      await DialogMassage.showConfirmDeleteDialog(context);
                  if (confirmDelete == true) {
                    ref
                        .read(userViewModelProvider.notifier)
                        .deleteUser(user.id);
                  }
                },
                onTap: () {
                  ref
                      .read(userViewModelProvider.notifier)
                      .updateUser(user.id, user);
                  DialogMassage.showSuccessDialog(
                      context, 'Update user Success');
                },
              );
            }),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CreateAccount()))),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UserTile({
    required Key key,
    required this.user,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListTile(
            leading: const Icon(Icons.supervised_user_circle_sharp),
            title: Text(
              user.userName,
              style: const TextStyle(
                //   color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              user.name,
              style: const TextStyle(
                // color: Color.fromARGB(255, 233, 233, 233),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                // color: Colors.white,
              ),
              onPressed: (onDelete),
              splashRadius: 46,
            ),
            onTap: onTap,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        // Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Colors.green,
        //         Colors.blueAccent,
        //       ],
        //       begin: Alignment.topRight,
        //       end: Alignment.bottomLeft,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
