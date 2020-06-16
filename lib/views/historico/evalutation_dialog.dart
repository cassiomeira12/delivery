import 'package:delivery/models/order/evaluation.dart';
import 'package:delivery/widgets/area_input_field.dart';
import 'package:delivery/widgets/primary_button.dart';
import 'package:delivery/widgets/stars_widget.dart';
import 'package:delivery/widgets/text_input_field.dart';
import 'package:flutter/material.dart';

import '../page_router.dart';

class EvaluationDialog extends StatefulWidget {
  @override
  _EvaluationDialogState createState() => _EvaluationDialogState();
}

class _EvaluationDialogState extends State<EvaluationDialog> {
  final _formKey = GlobalKey<FormState>();
  int selectedStart = 1;
  String coment;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Gostou?\nDeixe aqui sua avaliação!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              StarsWidget(
                size: 40,
                initialStar: 1,
                onChanged: (value) {
                  selectedStart = value;
                },
              ),
              SizedBox(height: 20,),
              AreaInputField(
                labelText: "Comentário",
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) => coment = value,
              ),
              SizedBox(height: 10,),
              PrimaryButton(
                text: "Salvar",
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    var evalutation = Evaluation()
                      ..stars = selectedStart
                      ..comment = coment;
                    PageRouter.pop(context, evalutation);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
