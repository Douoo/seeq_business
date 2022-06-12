import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seeq_business/components/empty_data.dart';
import 'package:seeq_business/utils/constants.dart';

import '../../components/delete_dialog.dart';
import '../../models/ticket.dart';
import '../../services/main_db.dart';
import 'ticket_setup.dart';
// import 'package:animate_do/animate_do.dart';

class AddTicket extends StatefulWidget {
  static const String route = '/add_ticket';

  final List<Ticket>? tickets;

  const AddTicket({Key? key, this.tickets}) : super(key: key);

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  bool addButtonTouched = false;
  List<Ticket> eventTickets = [];

  @override
  void initState() {
    super.initState();
    eventTickets = widget.tickets ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // final tickets = ModalRoute.of(context)!.settings.arguments as List<Ticket>;
    final event = ScopedModel.of<AppModel>(context, rebuildOnChange: true);

    // event.setTicketList(tickets);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        backgroundColor: kBlackColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, event.tickets),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => setState(() => addButtonTouched = false),
        child: eventTickets.isEmpty
            ? EmptyData(
                image: 'images/ticket.png',
                title: 'No tickets',
                description:
                    "You don't have any tickets yet. Start adding now.")
            : ListView.separated(
                itemBuilder: (context, index) {
                  final Ticket ticket = eventTickets[index];
                  return Slidable(
                    key: Key(ticket.name),
                    startActionPane: ActionPane(motion: const ScrollMotion(),

                        // A pane can dismiss the Slidable.
                        // dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              confirmDeleteDialog(context, () {
                                eventTickets.removeWhere((foundTicket) =>
                                    ticket.name == foundTicket.name);
                              });
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Remove',
                          ),
                        ]),
                    child: ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: Text(ticket.name),
                      subtitle: Text('0/${ticket.quantity} Sold'),
                      trailing:
                          Text(ticket.free ? 'Free' : 'ETB ${ticket.price}'),
                      onTap: () async {
                        final createdTicket = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketSetup(
                              ticket: ticket,
                              ticketType: ticket.free
                                  ? TicketType.free
                                  : TicketType.paid,
                              tickets: eventTickets,
                            ),
                          ),
                        );
                        if (createdTicket != null && createdTicket is Ticket) {
                          setState(() => eventTickets[index] = createdTicket);
                        } else if (createdTicket != null) {
                          setState(() => eventTickets = createdTicket);
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Divider(),
                    ),
                itemCount: eventTickets.length),
      ),
      floatingActionButton: addButtonTouched
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() => addButtonTouched = true);
              },
              child: const Icon(Icons.add),
              backgroundColor: kSecondaryColor,
            ),
      bottomSheet: !addButtonTouched
          ? SizedBox()
          : FadeInRight(
              duration: Duration(
                milliseconds: 200,
              ),
              child: Container(
                height: 70,
                color: kSecondaryColor,
                child: Row(
                  children: [
                    Expanded(
                      child: IconTextButton(
                          icon: Icons.money_off_outlined,
                          label: 'Free',
                          onPressed: () async {
                            final Ticket newTicket = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TicketSetup(
                                  ticketType: TicketType.free,
                                ),
                              ),
                            );
                            if (newTicket != null) {
                              setState(() {
                                addButtonTouched = false;
                                eventTickets.add(newTicket);
                              });
                            }
                          }),
                    ),
                    Expanded(
                      child: IconTextButton(
                        icon: Icons.attach_money_outlined,
                        label: 'Paid',
                        onPressed: () async {
                          final Ticket newTicket = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketSetup(
                                ticketType: TicketType.paid,
                              ),
                            ),
                          );
                          if (newTicket != null) {
                            setState(() {
                              addButtonTouched = false;
                              eventTickets.add(newTicket);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const IconTextButton(
      {Key? key,
      required this.label,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 30, color: Colors.white),
          Text(label, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
