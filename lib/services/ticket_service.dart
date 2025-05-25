import 'package:javabus/const/api_url.dart' as url;
import 'package:http/http.dart' as http;

class TicketService{
  final String apiUrl = '${url.baseUrl}/Ticket';

  Future<bool> createTicket(int bookingId) async {
    final response = await http.post(Uri.parse('$apiUrl/snapshot/$bookingId'));

    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

  
}