import 'package:estacionei/components/text_field_widget.dart';
import 'package:estacionei/global.dart';
import 'package:estacionei/utils/colors_util.dart';
import 'package:estacionei/utils/route_name.dart';
import 'package:estacionei/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:validadores/Validador.dart';

import '../utils/dialog_util.dart';

class AppBarWidget extends StatelessWidget {
  final bool isHistory;

  AppBarWidget({this.isHistory = false, Key? key}) : super(key: key);

  final _controllerQtdgroup = TextEditingController(
      text: globalHome.userData!.quantGroups.toString());
  final _controllerQtdParking = TextEditingController(
      text: globalHome.userData!.quantParkingSpot.toString());
  final _controllerValue = TextEditingController(
      text: globalHome.userData!.valueHour.toString());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String text = isHistory ? 'Histórico' : 'Estacionei';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _leadingWidget(context),
        Padding(
          padding: isHistory ? const EdgeInsets.only(right: 18.0) : EdgeInsets
              .zero,
          child: Text(text, style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600)),
        ),
        _endWidget(context)
      ],
    );
  }

  _leadingWidget(BuildContext context) {
    if (isHistory) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Voltar',
              style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            )),
      );
    }
    return IconButton(
        onPressed: () => Navigator.pushNamed(context, RouteName.ROUTE_HISTORY),
        icon: const Icon(Icons.history, size: 24));
  }

  _endWidget(BuildContext context) {
    if (isHistory) {
      return IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: const Text(
                      'Em breve você poderar escolher o dia para rever',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: ColorsUtil.verde
              ),
            );
          },
          icon: const Icon(Icons.calendar_month_outlined, size: 24));
    }
    return IconButton(
        onPressed: () {
          DialogUtil.showAlertSimNao(
              context: context,
              content: _dialogContent(),
              title: 'Configuração',
              confirm: 'SALVAR',
              simListener: () {
                if (_formKey.currentState!.validate()) {
                  double value = _controllerValue.text.precoToDouble();
                  globalHome.userData!.setValues(
                      int.parse(_controllerQtdgroup.text),
                      int.parse(_controllerQtdParking.text), value);
                  globalHome.userData!.addSpots();
                  globalHome.updateData(data: globalHome.userData!.toBasicMap(), isBigData: true);
                  return;
              }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: const Text(
                          'Número máximo de grupos é 26',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: ColorsUtil.vermelho
                  ),
                );
              });
        },
        icon: Image.asset('assets/images/ic_config.png', width: 20));
  }

  _dialogContent() {
    return SizedBox(
      height: 130,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Quantidade grupos',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  'Quantidade vagas',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  'Preço por hora',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ],
            ),
            const SizedBox(
                width: 32
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  height: 38, width: 42, controller: _controllerQtdgroup,
                  validator: (value) {
                    return Validador().add(Validar.OBRIGATORIO).maxVal(26).valido(value);
                  },),
                TextFieldWidget(
                    height: 38, width: 42, controller: _controllerQtdParking),
                TextFieldWidget(
                    height: 38, width: 42, controller: _controllerValue)
              ],
            )
          ],
        ),
      ),
    );
  }
}
