import 'package:flutter/material.dart';
import 'package:javabus/models/payment.dart';
import 'package:javabus/services/payment_service.dart';

class PaymentViewModel extends ChangeNotifier {
  Payment? payment;
  String? paymentUrl;
  String? errorMsg;
  bool isLoading = false;

  Future<void> addPayment({
    required int grossAmount,
    required int bookingId,
  }) async {
    try {
      isLoading = true;
      errorMsg = null;
      notifyListeners();

      paymentUrl = await PaymentService().createSnapPayment(
        grossAmount: grossAmount,
        bookingId: bookingId,
      );

      print('Payment URL didapat: $paymentUrl');
    } catch (e) {
      errorMsg = e.toString();
      print('Error di ViewModel: $errorMsg');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaymentByBookingId(int bookingId) async {
    try {
      errorMsg = null;
      payment = await PaymentService().getPaymentByBookingId(bookingId);
      notifyListeners();
    } catch (e) {
      errorMsg = e.toString();
      notifyListeners();
    }
  }
}
