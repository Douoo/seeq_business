class Ticket {
  final String name;
  final String? description;
  final int quantity;
  final int? quantitySold;
  final bool free;
  final bool? ticketAvailable;
  final bool? soldOut;
  final double price;
  final int? number;

  Ticket(
      {required this.name,
      this.description,
      required this.quantity,
      this.quantitySold,
      required this.free,
      this.ticketAvailable,
      this.soldOut,
      required this.price,
      this.number});

  Map toJson() => {
        'ticket_name': name,
        'quantity_total': quantity,
        'free': free,
        'price': free ? '0.00' : price
      };

  factory Ticket.fromJson(dynamic json) {
    return Ticket(
        name: json['ticket_name'],
        quantity: json['quantity_total'],
        free: json['free'],
        price: 0.0);
  }
}
