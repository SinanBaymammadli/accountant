import 'package:accountant/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class PaymentService {
  create({
    @required int amount,
    @required DocumentReference clientRef,
    @required bool toUs,
  }) async {
    // final DocumentReference paymentRef =
    //     await Firestore.instance.collection('payments').add({});

    return Firestore.instance.runTransaction((transaction) async {
      final clientSnap = await transaction.get(clientRef);
      final Client client = Client.fromSnapshot(clientSnap);

      // await transaction.update(paymentRef, {
      //   'client_ref': clientRef,
      //   'amount': amount,
      //   'date': Timestamp.now(),
      //   'to_us': toUs,
      // });

      await Firestore.instance.collection('payments').add({
        'client_ref': clientRef,
        'amount': amount,
        'date': Timestamp.now(),
        'to_us': toUs,
      });

      if (toUs) {
        await transaction
            .update(clientRef, {'balance': client.balance + amount});
      } else {
        await transaction
            .update(clientRef, {'balance': client.balance - amount});
      }
    });
  }
}
