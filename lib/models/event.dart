import 'location.dart';
import 'ticket.dart';

class Event {
  final String? id;
  final String name;
  final String? coverImage;
  final Location? location;
  final String? place;
  final String description;
  final String startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final String type;
  final String? status;
  final String? organizersID;
  final List<Ticket>? tickets;

  Event({
    this.id,
    required this.name,
    this.coverImage,
    this.location,
    this.place,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.startTime,
    this.endTime,
    required this.type,
    required this.status,
    this.organizersID,
    this.tickets,
  });

  Map toJson() {
    List<Map>? tickets = this.tickets != null
        ? this.tickets!.map((Ticket ticket) => ticket.toJson()).toList()
        : null;
    return {
      'name': name,
      'picture_url': coverImage,
      'place': place,
      'description': description,
      'start': {'date': startDate, 'time': startTime},
      'end': {'date': endDate, 'time': endTime},
      'category': type,
      'status': status,
      'organizers_id': organizersID,
      'ticket_availability': {'tickets': tickets}
    };
  }

  factory Event.fromJson(dynamic json) {
    if (json['ticket_availability']['tickets'] != null) {
      final ticketList = json['ticket_availability']['tickets'] as List;
      List<Ticket> _tickets =
          ticketList.map((ticket) => Ticket.fromJson(ticket)).toList();
      return Event(
          id: json['_id'],
          name: json['name'],
          description: json['description'],
          coverImage: json['picture_url'],
          place: json['place'],
          startTime: json['start']['time'],
          startDate: json['start']['date'],
          endTime: json['end']['time'],
          endDate: json['end']['date'],
          status: json['status'],
          type: json['category'],
          tickets: _tickets);
    } else {
      return Event(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        coverImage: json['picture_url'],
        place: json['place'],
        startTime: json['start']['time'],
        startDate: json['start']['date'],
        endTime: json['end']['time'],
        endDate: json['end']['date'],
        status: json['status'],
        type: json['category'],
      );
    }
  }
}
