import 'package:client_app/config.dart';
import 'package:client_app/models/cart.dart';
import 'package:client_app/models/order_payment.dart';
import 'package:client_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String cardHolderName = "";
  String cardNumber = "";
  String cardExp = "";
  String cardCVC = "";
  @override
  Widget build(BuildContext context) {
    final OrderPaymentModel = ref.watch(OrderPaymentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: ProgressHUD(
        child: Form(
          key: globalKey,
          child: _PaymentUI(context, ref),
        ),
        inAsyncCall: OrderPaymentModel.isLoading,
        opacity: 0.3,
        key: UniqueKey(),
      ),
    );
  }

  _PaymentUI(BuildContext context, WidgetRef ref) {
    final cartProvider = ref.watch(cartItemsProvider);

    if (cartProvider.cartModel != null) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                "Total Amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "${Config.currency}${cartProvider.cartModel!.gransTotal.toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "Card HolderName",
              "Card Holder",
              "Your name and surname",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
              },
              (onSaved) {
                cardHolderName = onSaved.toString().trim();
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.face),
              borderRadius: 10,
              contentPadding: 10,
              fontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade200,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200,
            ),
            SizedBox(
              height: 15,
            ),
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "CardNumber",
              "Card Number",
              "Card Number",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
              },
              (onSaved) {
                cardNumber = onSaved.toString().trim();
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.credit_card),
              borderRadius: 10,
              contentPadding: 10,
              fontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade200,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Flexible(
                  child: FormHelper.inputFieldWidgetWithLabel(
                    context,
                    "ValidExp",
                    "Valid Until",
                    "Month /Year",
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return "* Required";
                      }
                    },
                    (onSaved) {
                      cardExp = onSaved.toString().trim();
                    },
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.calendar_month),
                    borderRadius: 10,
                    contentPadding: 10,
                    fontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    prefixIconPaddingLeft: 10,
                    borderColor: Colors.grey.shade200,
                    textColor: Colors.black,
                    prefixIconColor: Colors.black,
                    hintColor: Colors.black.withOpacity(.6),
                    backgroundColor: Colors.grey.shade100,
                    borderFocusColor: Colors.grey.shade200,
                  ),
                ),
                Flexible(
                  child: FormHelper.inputFieldWidgetWithLabel(
                    context,
                    "CVV",
                    "CVV",
                    "CVV",
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return "* Required";
                      }
                    },
                    (onSaved) {
                      cardCVC = onSaved.toString().trim();
                    },
                    showPrefixIcon: false,
                    prefixIcon: const Icon(Icons.face),
                    borderRadius: 10,
                    contentPadding: 10,
                    fontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    prefixIconPaddingLeft: 10,
                    obscureText: true,
                    borderColor: Colors.grey.shade200,
                    textColor: Colors.black,
                    prefixIconColor: Colors.black,
                    hintColor: Colors.black.withOpacity(.6),
                    backgroundColor: Colors.grey.shade100,
                    borderFocusColor: Colors.grey.shade200,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: FormHelper.submitButton(
                "Procced to Confirm",
                () async {
                  //Navigator.of(context).pushNamed("/order-success");
                  if (validateAndSave()) {
                    final orderPaymentModel =
                        ref.read(OrderPaymentProvider.notifier);
                    await orderPaymentModel.processPayment(
                      cardHolderName,
                      cardNumber,
                      cardExp,
                      cardCVC,
                      cartProvider.cartModel!.gransTotal.toString(),
                    );

                    final orderPaymentResponseModel =
                        ref.watch(OrderPaymentProvider);

                    if (!orderPaymentResponseModel.isSuccess) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        orderPaymentResponseModel.message,
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      //redirect
                      Navigator.of(context).pushNamed("/order-success");
                    }
                  }
                },
                btnColor: Colors.blue,
                borderColor: Colors.white,
                txtColor: Colors.white,
                borderRadius: 20,
                width: 250,
              ),
            )
          ],
        ),
      );
    }
    return const CircularProgressIndicator();
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
