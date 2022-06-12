import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:seeq_business/utils/constants.dart';

import '../../components/delete_dialog.dart';
import '../../services/main_db.dart';
import '../../utils/size_config.dart';
import '../../models/ticket.dart';
import 'add_ticket.dart';

//This is to check whether the ticke being created is free or paid
enum TicketType { free, paid }

class TicketSetup extends StatefulWidget {
  static const String route = '/setup_ticket';

  final Ticket? ticket;
  final TicketType? ticketType;
  final List<Ticket>? tickets;
  const TicketSetup({Key? key, this.ticket, this.ticketType, this.tickets})
      : super(key: key);

  @override
  State<TicketSetup> createState() => _TicketSetupState();
}

class _TicketSetupState extends State<TicketSetup> {
  String paymentOptions = 'Absorb';
  double price = 0.00;
  final TextEditingController _ticketName = TextEditingController();

  final TextEditingController _ticketDescription = TextEditingController();

  final TextEditingController _ticketQty = TextEditingController();
  final TextEditingController _ticketPrice = TextEditingController();
  final TextEditingController _minTicketPerOrder = TextEditingController();
  final TextEditingController _maxTicketPerOrder = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool shouldPop = true;

  @override
  void initState() {
    super.initState();
    _ticketName.text = widget.ticket?.name ?? '';
    _ticketDescription.text = widget.ticket?.description ?? '';
    _ticketQty.text = widget.ticket?.quantity.toString() ?? '';
    _ticketPrice.text = widget.ticket?.price.toString() ?? '';
  }

  calculatePrice(String priceType) {
    if (priceType == 'Absorb') {
      return price;
    }
    return price + price * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    final TicketType ticketType = widget.ticketType ??
        ModalRoute.of(context)!.settings.arguments as TicketType;
    final event = ScopedModel.of<AppModel>(context, rebuildOnChange: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlackColor,
        title: Text(
            ticketType == TicketType.free ? 'Free Ticket' : 'Paid Tickets'),
        actions: [
          widget.ticket == null
              ? SizedBox()
              : IconButton(
                  icon: Icon(CupertinoIcons.delete),
                  onPressed: () {
                    confirmDeleteDialog(
                      context,
                      () {
                        widget.tickets!.removeWhere((foundTicket) =>
                            _ticketName.text == foundTicket.name);
                        Navigator.pop(context);
                        Navigator.pop(context, widget.tickets);
                      },
                    );
                  },
                ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Ticket ticket = Ticket(
                    name: _ticketName.text,
                    description: _ticketDescription.text,
                    quantity: int.parse(_ticketQty.text),
                    price: _ticketPrice.text == ''
                        ? 0.0
                        : double.parse(_ticketPrice.text),
                    free: ticketType == TicketType.free ? true : false);
                Navigator.of(context).pop(ticket);
                // Navigator.pop(context, ticket);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            onWillPop: () async {
              if (!shouldPop) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            Text('Are you sure?', textAlign: TextAlign.center),
                        content: Text('Unsaved changes will be lost',
                            textAlign: TextAlign.center),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                            child: const Text('Discard',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () => Navigator.popUntil(
                                context, ModalRoute.withName(AddTicket.route)),
                          ),
                          // SizedBox(width: SizeConfig.screenWidth * 0.03),
                          TextButton(
                              child: Text('Cancel',
                                  style: TextStyle(color: kBlackColor)),
                              onPressed: () => Navigator.pop(context))
                        ],
                      );
                    });
                return shouldPop;
              }
              return shouldPop;
            },
            onChanged: () {
              _formKey.currentState!.setState(() {
                if (_ticketName.text != '' ||
                    _ticketQty.text != '' ||
                    _ticketDescription.text != '') {
                  shouldPop = false;
                  print(shouldPop);
                } else {
                  shouldPop = true;
                  print(shouldPop);
                }
              });
            },
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _ticketName,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ticket name is required';
                    }
                    return null;
                  },
                  decoration: kDefaultTextFieldDecoration.copyWith(
                    labelText: 'Ticket name, Ex. Free Ticket',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                TextFormField(
                  controller: _ticketDescription,
                  // validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Field is required';
                  // }
                  // return null;
                  // },
                  decoration: kDefaultTextFieldDecoration.copyWith(
                    labelText: 'Description (Optional)',
                  ),
                ),
                TextFormField(
                  controller: _ticketQty,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                  decoration: kDefaultTextFieldDecoration.copyWith(
                    labelText: 'Quantity',
                  ),
                ),
                ticketType == TicketType.free
                    ? SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ticketPrice,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value != '') {
                                  setState(() => price = double.parse(value));
                                } else {
                                  setState(() => price = 0);
                                }
                              },
                              decoration: InputDecoration(
                                  icon: Text('ETB ',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black54)),
                                  // labelText: '0.00',
                                  hintText: '0.00',
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          SizedBox(width: SizeConfig.screenWidth * 0.02),
                          Expanded(
                            child: DropdownButtonFormField(
                              value: paymentOptions,
                              items: [
                                DropdownMenuItem(
                                  value: 'Absorb',
                                  child: Text('Absorb'),
                                ),
                                DropdownMenuItem(
                                  value: 'Pass On',
                                  child: Text('Pass On'),
                                ),
                              ],
                              onChanged: (value) {
                                paymentOptions = value as String;
                                setState(() => calculatePrice(paymentOptions));
                              },
                            ),
                          ),
                        ],
                      ),
                ticketType == TicketType.free
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                    text:
                                        'Buyer total: ETB ${calculatePrice(paymentOptions)}0\n'),
                                TextSpan(
                                    text: 'Fee breakdown',
                                    style: TextStyle(color: Colors.blueAccent),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                  child: DataTable(
                                                columns: const <DataColumn>[
                                                  DataColumn(
                                                    label: Text(
                                                      'Cost to buyer',
                                                      // style: TextStyle(fontWeight: FontStyle..),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      '',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                ],
                                                rows: <DataRow>[
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      const DataCell(
                                                          Text('Ticket price')),
                                                      DataCell(Text(
                                                          'ETB ${calculatePrice(paymentOptions)}0')),
                                                    ],
                                                  ),
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      const DataCell(Text(
                                                          'Earning per ticket')),
                                                      DataCell(Text(
                                                          paymentOptions ==
                                                                  'Absorb'
                                                              ? 'ETB  ${calculatePrice(paymentOptions) - (price * 0.1)}0'
                                                              : 'ETB $price')),
                                                    ],
                                                  ),
                                                  DataRow(
                                                    cells: <DataCell>[
                                                      const DataCell(
                                                          Text('Service fee')),
                                                      DataCell(Text(
                                                          'ETB ${price * 0.1}0')),
                                                    ],
                                                  ),
                                                ],
                                              ));
                                            });
                                      })
                              ],
                            ),
                          ),
                        ),
                      ),
                ExpansionTile(
                  textColor: kBlackColor,
                  iconColor: kBlackColor,
                  title: Text('Advanced options'),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Limit the number of tickets which can be bought at a time ',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _minTicketPerOrder,
                            decoration: InputDecoration(
                              labelText: 'Minimum',
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.screenWidth * 0.02),
                        Expanded(
                          child: TextFormField(
                            controller: _maxTicketPerOrder,
                            decoration: InputDecoration(
                              labelText: 'Maximum',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
