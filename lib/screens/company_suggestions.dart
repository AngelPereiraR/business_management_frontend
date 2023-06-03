// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';

int? idCompanySuggestionsCompany;
String? usernameSuggestionsCompany;

class CompanySuggestionsScreen extends StatefulWidget {
  final int? id;
  final String? username;
  const CompanySuggestionsScreen({Key? key, this.id, this.username})
      : super(key: key);

  @override
  State<CompanySuggestionsScreen> createState() =>
      _CompanySuggestionsScreenState();
}

class _CompanySuggestionsScreenState extends State<CompanySuggestionsScreen> {
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
    idCompanySuggestionsCompany = widget.id;
    usernameSuggestionsCompany = widget.username;
    if (getServices.isLoading) return const LoadingScreen();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 97, 0),
          leading: const Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.comment_rounded),
              SizedBox(width: 10),
            ],
          ),
          leadingWidth: 45,
          titleTextStyle: const TextStyle(fontSize: 15),
          title: Text('$usernameSuggestionsCompany - Suggestions  '),
          actions: [
            Tooltip(
              message: "Return",
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CompanyScreen(username: widget.username)));
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
                      builder: (context) => CompanySuggestionsScreen(
                          id: widget.id, username: widget.username)));
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return MySlidable9(
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

class MySlidable9 extends StatefulWidget {
  final String commentary;
  final String state;
  final int id;
  final int index;
  final String username;
  final int? counter;
  const MySlidable9({
    Key? key,
    required this.commentary,
    required this.state,
    required this.id,
    required this.index,
    required this.username,
    this.counter,
  }) : super(key: key);

  @override
  State<MySlidable9> createState() => _MySlidable9State();

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}

class _MySlidable9State extends State<MySlidable9> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    final updateService = Provider.of<UpdateServices>(context);
    final isSlidable = widget.state == "Pending";

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
            onPressed: (BuildContext context) {
              updateService.acceptSuggestion(widget.id);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanySuggestionsScreen(
                          id: idCompanySuggestionsCompany,
                          username: usernameSuggestionsCompany)));
            },
            backgroundColor: const Color.fromARGB(255, 0, 154, 5),
            foregroundColor: Colors.white,
            icon: Icons.check_circle_rounded,
            label: 'Accept',
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
                updateService.denegateSuggestion(widget.id);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanySuggestionsScreen(
                            id: idCompanySuggestionsCompany,
                            username: usernameSuggestionsCompany)));
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.cancel_rounded,
              label: 'Denegate',
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
            const SizedBox(width: 16.0),
            Visibility(
                visible: isSlidable,
                child: Row(
                  children: [
                    Icon(
                      widget.counter! >= 0
                          ? Icons.thumb_up_rounded
                          : Icons.thumb_down_rounded,
                      color: widget.counter! >= 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 16.0),
                    Text(widget.counter.toString()),
                  ],
                )),
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
                    style: TextStyle(
                        fontSize: 18,
                        color: widget.state == "Accepted"
                            ? Colors.green
                            : widget.state == "Denegated"
                                ? Colors.red
                                : Colors.grey[700]),
                  ),
                ),
                Text(
                  widget.state,
                  style: TextStyle(
                      fontSize: 12,
                      color: widget.state == "Accepted"
                          ? Colors.green
                          : widget.state == "Denegated"
                              ? Colors.red
                              : Colors.grey[700]),
                ),
              ],
            ),
            const Spacer(),
            Text(widget.username,
                style: TextStyle(
                    color: widget.state == "Accepted"
                        ? Colors.green
                        : widget.state == "Denegated"
                            ? Colors.red
                            : Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
