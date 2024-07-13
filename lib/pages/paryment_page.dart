import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:food_delivery_app/components/my_button.dart';
import 'package:food_delivery_app/models/restaurant.dart';
import 'delivery_progress_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;

  // Assuming you have a reference to your Restaurant class
  final Restaurant restaurant = Restaurant();

  void _userTappedPay() {
    if (_formKey.currentState!.validate()) {
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              _buildDialogRow("Card Number:", _cardNumber),
              _buildDialogRow("Expiry Date:", _expiryDate),
              _buildDialogRow("Card Holder Name:", _cardHolderName),
              _buildDialogRow("CVV:", _cvvCode),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliveryProgressPage(),
                ),
              );
              restaurant
                  .clearCart(); // Call clearCart() after payment confirmation
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text("$title $value"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents keyboard overflow
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: _cardNumber,
              expiryDate: _expiryDate,
              cardHolderName: _cardHolderName,
              cvvCode: _cvvCode,
              showBackView: _isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CreditCardForm(
                formKey: _formKey,
                cardNumber: _cardNumber,
                expiryDate: _expiryDate,
                cardHolderName: _cardHolderName,
                cvvCode: _cvvCode,
                onCreditCardModelChange: (CreditCardModel data) {
                  setState(() {
                    _cardNumber = data.cardNumber;
                    _expiryDate = data.expiryDate;
                    _cardHolderName = data.cardHolderName;
                    _cvvCode = data.cvvCode;
                  });
                },
                obscureCvv: true,
                obscureNumber: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyButton(
                text: "Pay Now",
                onTap: _userTappedPay,
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
