// ignore_for_file: non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

String? usernameUsersAdmin;

class AdminUsersScreen extends StatefulWidget {
  final String? username;
  const AdminUsersScreen({Key? key, this.username}) : super(key: key);

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<User> users = [];
  final getServices = GetServices();
  Future refresh() async {
    setState(() => users.clear());
    await getServices.getUsers();
    await getServices.getUsers();
    setState(() {
      users = getServices.users;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    usernameUsersAdmin = widget.username;
    if (getServices.isLoading) return const LoadingScreen();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Row(
            children: const [
              SizedBox(width: 10),
              Icon(Icons.person_rounded),
              SizedBox(width: 10),
              Text('Users  '),
            ],
          ),
          leadingWidth: 150,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Tooltip(
                message: "Return to Companies",
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminCompaniesScreen(
                                    username: usernameUsersAdmin,
                                  )));
                    },
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.indigo.withOpacity(0.1)),
                        shape:
                            MaterialStateProperty.all(const StadiumBorder())),
                    child: const Icon(Icons.business_rounded,
                        color: Colors.white)))
          ],
        ),
        floatingActionButton: const ExampleExpandableFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: RefreshIndicator(
            onRefresh: () async {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminUsersScreen(
                            username: usernameUsersAdmin,
                          )));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable4(
                  id: users[index].id,
                  index: index,
                  email: users[index].email,
                  username: users[index].username,
                  password: users[index].password,
                  role: users[index].role,
                  enabled: users[index].enabled,
                );
              },
              itemCount: users.length,
            )),
      ),
    );
  }
}

class MySlidable4 extends StatelessWidget {
  final String email;
  final String username;
  final int id;
  final int index;
  final String password;
  final String role;
  final bool enabled;
  const MySlidable4({
    Key? key,
    required this.email,
    required this.username,
    required this.id,
    required this.index,
    required this.password,
    required this.role,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSlidable = role == "ROLE_USER";
    final deleteServices = Provider.of<DeleteServices>(context);
    final updateServices = Provider.of<UpdateServices>(context);
    return Slidable(
        enabled: isSlidable,

        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),
          dragDismissible: false,

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (BuildContext _) async {
                await CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  title: 'Are you sure?',
                  text: "Are you sure you want to delete this user?",
                  showCancelBtn: true,
                  confirmBtnColor: Colors.red,
                  confirmBtnText: 'Delete',
                  onConfirmBtnTap: () {
                    deleteServices.deleteUser(id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminUsersScreen(
                                  username: usernameUsersAdmin,
                                )));
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.person_remove_rounded,
              label: 'Delete',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Visibility(
              visible: true,
              child: SlidableAction(
                onPressed: (BuildContext context) {
                  updateServices.activateOrDeactivate(username);
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AdminUsersScreen(username: usernameUsersAdmin)));
                },
                backgroundColor:
                    enabled ? const Color(0xFFFE4A49) : const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: enabled
                    ? Icons.radio_button_unchecked_rounded
                    : Icons.check_circle_rounded,
                label: enabled ? 'Deactivate' : 'Activate',
              ),
            ),
          ],
        ),
        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
            title: Text(username),
            subtitle: Text(email),
            trailing: role == 'ROLE_ADMIN'
                ? const Icon(Icons.check_circle_rounded)
                : role == 'ROLE_COMPANY'
                    ? const Icon(Icons.check_circle_rounded)
                    : const Icon(Icons.swipe_rounded),
            leading: role == 'ROLE_USER'
                ? const Icon(Icons.person_rounded)
                : role == 'ROLE_ADMIN'
                    ? const Icon(Icons.admin_panel_settings_rounded)
                    : const Icon(Icons.business_rounded)));
  }

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}
