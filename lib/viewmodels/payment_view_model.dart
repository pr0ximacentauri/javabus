import 'package:flutter/material.dart';
import 'package:javabus/models/payment_request.dart';
import 'package:javabus/services/payment_service.dart';

class PaymentViewModel extends ChangeNotifier{ 
  final PaymentService _service = PaymentService();

  bool isLoading = false;
  String? paymentUrl;
  String? errorMsg;

  Future<void> createPaymentWithMidtrans(int userId, int scheduleId, int grossAmount) async{
    isLoading = true;
    errorMsg = null;
    notifyListeners();

    try{
      final request = PaymentRequest(userId: userId, scheduleId: scheduleId, grossAmount: grossAmount);
      paymentUrl = await _service.createPayment(request);
    }catch(e){
      errorMsg = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}