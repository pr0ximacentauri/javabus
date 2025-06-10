
import 'package:flutter/material.dart';
import 'package:javabus/services/ticket_service.dart';

class TicketViewModel extends ChangeNotifier{
  final TicketService _service = TicketService();
  String? msg;

  Future<bool> createSnapshot(int bookingId) async{
    final result = await _service.createTicket(bookingId);
    if(!result){
      msg = "Gagal membuat snapshot";
    }
    return result;
  }
}