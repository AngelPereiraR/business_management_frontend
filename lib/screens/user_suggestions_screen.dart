// ignore_for_file: non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';

int? idCompanySuggestionsUser;
String? usernameSuggestionsUser;
String? companyUserSuggestionsUser;

class UserSuggestionsScreen extends StatefulWidget {
  final int? id;
  final String? username;
  final String? companyUser;
  const UserSuggestionsScreen(
      {Key? key, this.id, this.username, this.companyUser})
      : super(key: key);

  @override
  State<UserSuggestionsScreen> createState() => _UserSuggestionsScreenState();
}

class _UserSuggestionsScreenState extends State<UserSuggestionsScreen> {
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
    idCompanySuggestionsUser = widget.id;
    usernameSuggestionsUser = widget.username;
    companyUserSuggestionsUser = widget.companyUser;
    if (getServices.isLoading) return const LoadingScreen();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 123, 255),
          leading: const Row(
            children: [
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
                            builder: (context) => UserInsertSuggestionScreen(
                                idCompany: widget.id,
                                username: widget.username,
                                companyUser: widget.companyUser)));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.add, color: Colors.white)),
            ),
            Tooltip(
              message: "Return",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductScreen(
                                  id: widget.id,
                                  username: widget.username,
                                  companyUser: widget.companyUser,
                                )));
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          Colors.indigo.withOpacity(0.1)),
                      shape: MaterialStateProperty.all(const StadiumBorder())),
                  child: const Icon(Icons.keyboard_return_rounded,
                      color: Colors.white)),
            )
          ],
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              refresh();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoadingUserScreen(
                            id: widget.id,
                            username: widget.username,
                            companyUser: widget.companyUser,
                          )));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable10(
                    id: suggestions[index].id,
                    index: index,
                    commentary: suggestions[index].commentary,
                    state: suggestions[index].state,
                    username: suggestions[index].username,
                    counter: (suggestions[index]
                                .favorite?[0]
                                .userLikes
                                .length ??
                            0) -
                        (suggestions[index].favorite?[0].userDislikes.length ??
                            0));
              },
              itemCount: suggestions.length,
            )),
      ),
    );
  }
}

class MySlidable10 extends StatefulWidget {
  final String commentary;
  final String state;
  final int id;
  final int index;
  final String username;
  final int? counter;
  const MySlidable10({
    Key? key,
    required this.commentary,
    required this.state,
    required this.id,
    required this.index,
    required this.username,
    required this.counter,
  }) : super(key: key);

  @override
  State<MySlidable10> createState() => _MySlidable10State();

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}

class _MySlidable10State extends State<MySlidable10> {
  bool likeIsEnabled = false;
  bool dislikeIsEnabled = false;
  List<Suggestion> suggestions2 = [];

  int like = 0;
  int dislike = 0;

  final getService = GetServices();
  Future refresh() async {
    setState(() => suggestions2.clear());
    await getService.getSuggestionsFromCompany(idCompanySuggestionsUser);
    await getService.getSuggestionsFromCompany(idCompanySuggestionsUser);
    if (mounted) {
      setState(() {
        suggestions2 = getService.suggestions;
      });
    }

    if (suggestions2.isNotEmpty) {
      for (Suggestion s in suggestions2) {
        if (s.commentary == widget.commentary) {
          for (int i = 0; i < (s.favorite?[0].userLikes.length ?? 0); i++) {
            if (s.favorite?[0].userLikes[i].username ==
                usernameSuggestionsUser) {
              like += 1;
            }
          }

          if (like != 0) {
            setState(() {
              likeIsEnabled = false;
            });
          } else {
            setState(() {
              likeIsEnabled = true;
            });
          }

          for (int i = 0; i < (s.favorite?[0].userDislikes.length ?? 0); i++) {
            if (s.favorite?[0].userDislikes[i].username ==
                usernameSuggestionsUser) {
              dislike += 1;
            }
          }

          if (dislike != 0) {
            setState(() {
              dislikeIsEnabled = false;
            });
          } else {
            setState(() {
              dislikeIsEnabled = true;
            });
          }

          like = 0;
          dislike = 0;
        }
      }
    } else {
      if (mounted) {
        setState(() {
          likeIsEnabled = true;
          dislikeIsEnabled = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final isSlidable =
        widget.username == usernameSuggestionsUser && widget.state == "Pending";
    final isLikable = widget.state == "Pending";
    final deleteService = Provider.of<DeleteServices>(context);
    final updateService = Provider.of<UpdateServices>(context);

    return Column(
      children: [
        Slidable(
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
                    text: "Are you sure you want to delete this suggestion?",
                    showCancelBtn: true,
                    confirmBtnColor: Colors.red,
                    confirmBtnText: 'Delete',
                    onConfirmBtnTap: () {
                      deleteService.deleteSuggestion(widget.id);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoadingUserScreen(
                                    id: idCompanySuggestionsUser,
                                    username: usernameSuggestionsUser,
                                    companyUser: companyUserSuggestionsUser,
                                  )));
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
                            builder: (context) => UserUpdateSuggestionScreen(
                                idCompany: idCompanySuggestionsUser,
                                username: usernameSuggestionsUser,
                                idSuggestion: widget.id,
                                commentary: widget.commentary,
                                state: widget.state,
                                companyUser: companyUserSuggestionsUser)));
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Visibility(
                  visible: isLikable,
                  child: IconButton(
                    onPressed: likeIsEnabled
                        ? () async {
                            updateService.likeSuggestion(
                                widget.id, usernameSuggestionsUser);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoadingUserScreen(
                                          id: idCompanySuggestionsUser,
                                          username: usernameSuggestionsUser,
                                          companyUser:
                                              companyUserSuggestionsUser,
                                        )));
                          }
                        : null,
                    icon: Icon(Icons.thumb_up,
                        color: likeIsEnabled ? Colors.grey : Colors.green),
                  ),
                ),
                Visibility(
                    visible: isLikable, child: Text(widget.counter.toString())),
                Visibility(
                  visible: isLikable,
                  child: IconButton(
                    onPressed: dislikeIsEnabled
                        ? () async {
                            updateService.dislikeSuggestion(
                                widget.id, usernameSuggestionsUser);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoadingUserScreen(
                                          id: idCompanySuggestionsUser,
                                          username: usernameSuggestionsUser,
                                          companyUser:
                                              companyUserSuggestionsUser,
                                        )));
                          }
                        : null,
                    icon: Icon(Icons.thumb_down,
                        color: dislikeIsEnabled ? Colors.grey : Colors.red),
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: widget.commentary,
                      child: Text(
                        widget.commentary.length <= 22
                            ? widget.commentary
                            : "${widget.commentary.substring(0, 22)}...",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Text(
                      widget.state,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                Text(widget.username),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
