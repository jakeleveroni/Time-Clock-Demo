import 'package:flutter/material.dart';

class OverlayBuilder {
  static buildLoadingOverlay() {
    return new Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(
            dismissible: false,
            color: Colors.grey
          )
        ),
        Center(
          child: new CircularProgressIndicator()
        )
      ],
    );
  }
}