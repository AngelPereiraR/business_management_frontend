// ignore_for_file: non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

int? idCompanySuggestionsAdmin;
String? usernameSuggestionsAdmin;

class AdminSuggestionsScreen extends StatefulWidget {
  final int? id;
  final String? username;
  const AdminSuggestionsScreen({Key? key, this.id, this.username})
      : super(key: key);

  @override
  State<AdminSuggestionsScreen> createState() => _AdminSuggestionsScreenState();
}

class _AdminSuggestionsScreenState extends State<AdminSuggestionsScreen> {
  List<Suggestion> suggestions = [];
  final getServices = GetServices();
  Future refresh() async {
    setState(() => suggestions.clear());
    await getServices.getSuggestionsFromCompany(widget.id);
    await getServices.getSuggestionsFromCompany(widget.id);
    setState(() {
      suggestions = getServices.suggestions;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    idCompanySuggestionsAdmin = widget.id;
    usernameSuggestionsAdmin = widget.username;
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
              Icon(Icons.comment_rounded),
              SizedBox(width: 10),
              Text('Suggestions  '),
            ],
          ),
          leadingWidth: 150,
          actions: [
            Tooltip(
              message: "Insert Suggestion",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminInsertSuggestionScreen(
                                idCompany: widget.id,
                                username: widget.username)));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
            Tooltip(
              message: "Return to Companies",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminCompaniesScreen(
                                username: widget.username)));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child:
                      const Icon(Icons.business_rounded, color: Colors.white)),
            )
          ],
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: const ExampleExpandableFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: RefreshIndicator(
            onRefresh: () async {
              refresh();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminSuggestionsScreen(
                          id: widget.id, username: widget.username)));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable8(
                  id: suggestions[index].id,
                  index: index,
                  commentary: suggestions[index].commentary,
                  state: suggestions[index].state,
                );
              },
              itemCount: suggestions.length,
            )),
      ),
    );
  }
}

class MySlidable8 extends StatelessWidget {
  final String commentary;
  final String state;
  final int id;
  final int index;
  const MySlidable8({
    Key? key,
    required this.commentary,
    required this.state,
    required this.id,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteSuggestionservice = Provider.of<DeleteServices>(context);
    return Slidable(

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
                  text: "Are you sure you want to delete this suggestion?",
                  showCancelBtn: true,
                  confirmBtnColor: Colors.red,
                  confirmBtnText: 'Delete',
                  onConfirmBtnTap: () {
                    deleteSuggestionservice.deleteSuggestion(id);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminSuggestionsScreen(
                                id: idCompanySuggestionsAdmin,
                                username: usernameSuggestionsAdmin)));
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
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
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminUpdateSuggestionScreen(
                              idCompany: idCompanySuggestionsAdmin,
                              username: usernameSuggestionsAdmin,
                              idSuggestion: id,
                              commentary: commentary,
                              state: state)));
                },
                backgroundColor: const Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.manage_accounts_rounded,
                label: 'Edit',
              ),
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
          title: Text(commentary),
          subtitle: Text(state),
        ));
  }

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}
