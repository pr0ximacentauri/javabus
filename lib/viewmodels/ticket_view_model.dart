
import 'package:flutter/material.dart';
import 'package:javabus/services/ticket_service.dart';

class TicketViewModel extends ChangeNotifier{
  final TicketService _ticketService = TicketService();
  String? Msg;

  Future<bool> createSnapshot(int bookingId) async{
    final result = await _ticketService.createTicket(bookingId);
    if(!result){
      Msg = "Gagal membuat snapshot";
    }
    return result;
  }
}