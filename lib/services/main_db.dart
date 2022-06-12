import 'dart:collection';
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/event.dart';
import '../models/location.dart';
import '../models/ticket.dart';

class AppModel extends Model {
  bool _isLoading = false;
  bool _loadingEvent = false;
  final _db = FirebaseDatabase.instance.ref();
  int? _selectedIndex;
  List<Event> _eventList = [];
  List<Event> _draftEventList = [];
  List<Event> _archivedEventList = [];

  List<Ticket> _tickets = [];
  final _auth = FirebaseAuth.instance;

  final String url = 'https://warm-island-26970.herokuapp.com/events';

  // UserProfile? _user;

  bool get loadingEvent {
    return _loadingEvent;
  }

  set selectIndex(int index) {
    _selectedIndex = index;
  }

  List<Ticket> get tickets {
    return _tickets;
  }

  List<Event> get eventList {
    return _eventList;
  }

  set eventList(List<Event> eventList) {
    _eventList = eventList;
  }

  List<Event> get draftEventList {
    return _draftEventList;
  }

  List<Event> get archivedEventList {
    return _archivedEventList;
  }

  bool get isLoading {
    return _isLoading;
  }

  // UserProfile? get user {
  //   return _user;
  // }

  // set setUser(UserProfile? user) {
  //   _user = user;
  // }

  int? get selectedIndex {
    return _selectedIndex;
  }

  addTicket(Ticket ticket) {
    print('ticket added');
    tickets.add(ticket);
    notifyListeners();
  }

  updateTicket(int ticketId, Ticket ticket) {
    print('updating ticket');
    tickets.where((Ticket foundTickets) {
      if (foundTickets.name == ticket.name) {
        foundTickets = ticket;

        return true;
      }
      return false;
    });
    notifyListeners();
  }

  deleteTicket(String ticketName) {
    tickets.removeWhere((ticket) => ticket.name == ticketName);
    notifyListeners();
  }

  setTicketList(List<Ticket> ticket) {
    _tickets = ticket;
    notifyListeners();
  }

  Future<void> addEvent({
    required String name,
    Location? location,
    required String description,
    String? picture,
    required String startDate,
    String? place,
    String? startTime,
    String? endDate,
    String? endTime,
    required String type,
    String? status,
    List<Ticket>? ticket,
  }) async {
    _isLoading = true;
    notifyListeners();

    final List<Map<String, dynamic>> ticketList = [];

    ticket?.forEach((Ticket ticket) {
      final Map<String, dynamic> data = {
        'ticket_name': ticket.name,
        'quantity_total': ticket.quantity,
        // 'quantity_sold': Number,
        // 'minimum_quantity': ticket.minSalePerOrder,
        // 'maximum_quantity_per_order': ticket.maxSalePerOrder,
        'free': ticket.free,
        // 'has_available_tickets': Boolean,
        // 'is_sold_out': Boolean,
        'price': ticket.free ? 0 : ticket.price,
      };
      ticketList.add(data);
    });

    Map<String, dynamic> eventDetail = {
      'name': name,
      'picture_url': picture,
      'description': description,
      'start': {
        'date': startDate,
        'time': startTime,
      },
      'end': {
        'date': endDate,
        'time': endTime,
      },
      'age_restriction': '18+',
      'category': type,
      'status': status,
      'organizers_id': _auth.currentUser!.uid,
      'address': {
        'address1': '',
        'address2': '',
        'city': 'Addis Ababa',
        'latitude': '',
        'longitude': ''
      },
      'ticket_availability': {
        'currency': 'ETB',
        'tickets': ticketList,
      }
    };

    http.Response response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(eventDetail));

    if (response.statusCode == 200) {
      final Event event = Event(
          name: name,
          coverImage: picture,
          description: description,
          startDate: startDate,
          endDate: endDate,
          startTime: startTime,
          endTime: endTime,
          type: type,
          status: status,
          organizersID: _auth.currentUser!.uid);
      _eventList.add(event);
      _tickets.clear();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEvent([bool? isReload]) async {
    isReload == null ? _loadingEvent = true : _loadingEvent = false;
    notifyListeners();
    try {
      final response = await http
          .get(Uri.parse('$url?organizer_id=${_auth.currentUser!.uid}'));
      List<Event> fetchedEventList = [];

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> fetchData = json.decode(response.body);

        for (var value in fetchData) {
          Event event = Event.fromJson(value);
          fetchedEventList.add(event);
        }
        _eventList = fetchedEventList
            .where((Event event) => event.status == 'active')
            .toList();
        _draftEventList = fetchedEventList
            .where((Event event) => event.status == 'draft')
            .toList();
        _archivedEventList = fetchedEventList
            .where((Event event) => event.status == 'archived')
            .toList();

        _loadingEvent = false;
        notifyListeners();
      }
    } catch (exception) {
      print(exception);
      _loadingEvent = false;
      notifyListeners();
    }
  }

  Future<void> updateEvent(Event event) async {
    final eventDetail = event.toJson();
    print(eventDetail);
    http.Response response = await http.put(
        Uri.parse('https://warm-island-26970.herokuapp.com/events/${event.id}'),
        body: json.encode(eventDetail));
    print(response.body);
    if (response.statusCode == 200) {
      final Event updatedEvent = Event.fromJson(eventDetail);
      _eventList[_selectedIndex!] = updatedEvent;
      _selectedIndex = null;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id, String status) async {
    if (status == 'active') {
      _eventList.removeWhere((Event event) => event.id == id);
    } else if (status == 'draft') {
      _draftEventList.removeWhere((Event event) => event.id == id);
    } else {
      _archivedEventList.removeWhere((Event event) => event.id == id);
    }

    notifyListeners();
    await http.delete(
        Uri.parse('https://warm-island-26970.herokuapp.com/events/$id'));
  }
}
