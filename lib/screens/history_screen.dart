import 'package:estacionei/components/circular_chart_widget.dart';
import 'package:estacionei/components/resume_data_widget.dart';
import 'package:estacionei/utils/double_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import '../components/app_bar_widget.dart';
import '../controllers/history_controller.dart';
import '../global.dart';
import '../utils/colors_util.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final _controller = HistoryController();

  @override
  Widget build(BuildContext context) {
    var sizeStatusBar = MediaQuery.of(context).padding.top + 8;
    var width = MediaQuery.of(context).size.width;

    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: EdgeInsets.only(top: sizeStatusBar),
                child: AppBarWidget(isHistory: true),
              )),
          body: _buildBody(width),
        );
      }
    );
  }

  _buildBody(width){
    if(_controller.history != null){
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _chartWidget(width),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMd().format(_controller.history!.date!),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400)),
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: const Text(
                                'Em breve você poderar visualizar ordenado e também as vagas ainda não finalizadas.',
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: ColorsUtil.verde
                        ),
                      );
                    },
                    child: const Text('Ordenar',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400)))
              ],
            ),
            _listOfResumeData()
          ],
        ),
      );
    }
    return _dataNotFound();
  }

  _chartWidget(width) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            height: 280,
            child: CircularChartWidget(history:_controller.history!)),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * .25),
                child: Text('R\$${_controller.history!.unPaid.convertToReal()}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ColorsUtil.laranja)),
              ),
              Text('R\$${_controller.history!.paid.convertToReal()}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: ColorsUtil.verde))
            ],
          ),
        )
      ],
    );
  }

  _listOfResumeData() {
    var spots = _controller.spots;
    if (spots.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: Text('Você ainda não tem nenhum registro',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
      );
    }
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 16),
          itemCount: spots.length,
          separatorBuilder: (_, index){
          return Divider(height: 24, thickness: 1, color: Colors.grey.withOpacity(0.25));
          },
          itemBuilder: (context, index) {
            return ResumeDataWidget(parkingSpot: spots[index], valueHour: globalHome.userData!.valueHour!);
          }),
    );
  }

  _dataNotFound(){
    return const Center(
      child: Text('Seu historico ainda esta vazio!', style: TextStyle(fontSize: 24)),
    );
  }
}
