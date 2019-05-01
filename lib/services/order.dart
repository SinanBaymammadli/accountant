import 'package:accountant/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class OrderService {
  create({
    @required DocumentReference clientRef,
    @required DocumentReference productRef,
    @required bool isBuy,
    @required double productAmount,
    @required double productPrice,
    @required bool hasPayment,
    int paymentAmount,
  }) async {
    DocumentReference paymentRef;

    return Firestore.instance.runTransaction((transaction) async {
      final clientSnap = await transaction.get(clientRef);
      final Client client = Client.fromSnapshot(clientSnap);

      if (hasPayment) {
        paymentRef = await Firestore.instance.collection('payments').add({});

        await transaction.update(paymentRef, {
          'client_ref': clientRef,
          'amount': paymentAmount,
          'date': Timestamp.now(),
          'to_us': !isBuy,
        });

        await transaction
            .update(clientRef, {'balance': client.balance + paymentAmount});
      }

      await Firestore.instance.collection('orders').add({
        'client_ref': clientRef,
        'product_ref': productRef,
        'product_amount': productAmount,
        'product_price': productPrice,
        'date': Timestamp.now(),
        'is_buy': isBuy,
        'payment_ref': paymentRef,
      });

      await transaction.update(clientRef, {
        'balance': client.balance +
            (productAmount * productPrice).round() * (isBuy ? 1 : -1)
      });
    });
  }
}
