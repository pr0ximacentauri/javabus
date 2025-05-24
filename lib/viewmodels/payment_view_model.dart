import 'package:flutter/material.dart';
import 'package:javabus/services/payment_service.dart';

class PaymentViewModel extends ChangeNotifier {
  String? paymentUrl;
  String? errorMsg;

  Future<void> addPayment({
    required int grossAmount,
    required int bookingId,
  }) async {
    try {
      errorMsg = null;
      paymentUrl = await PaymentService().createSnapPayment(
        grossAmount: grossAmount,
        bookingId: bookingId,
      );
      print('Payment URL didapat: $paymentUrl');
      notifyListeners();
    } catch (e) {
      errorMsg = e.toString();
      print('Error di ViewModel: $errorMsg');
      notifyListeners();
    }
  }
}
