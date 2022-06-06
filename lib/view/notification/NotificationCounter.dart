import 'package:flutter/material.dart';

class NotificationCounter {
  ValueNotifier<int> notificationCounterValueNotifer = ValueNotifier(0);
  void incrementNotifier(ValueNotifier notificationCounterValueNotifer) {
    notificationCounterValueNotifer.value++;
  }

  void decrementCounter() {
    notificationCounterValueNotifer.value--;
  }
}
