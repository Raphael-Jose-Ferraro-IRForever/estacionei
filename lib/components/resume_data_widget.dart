import 'package:estacionei/models/parking_spot_model.dart';
import 'package:estacionei/utils/colors_util.dart';
import 'package:estacionei/utils/double_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResumeDataWidget extends StatelessWidget {
  final double valueHour;
  final ParkingSpotModel parkingSpot;

  const ResumeDataWidget(
      {Key? key, required this.parkingSpot, required this.valueHour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                width: 15,
                height: 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: parkingSpot.available
                        ? ColorsUtil.verde
                        : ColorsUtil.laranja,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            const SizedBox(width: 32),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(parkingSpot.plate!,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 8),
                    Text(DateFormat.Hm().format(parkingSpot.entryTime!),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(width: 42),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VAGA ${parkingSpot.name}',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 8),
                    Text(
                        DateFormat.Hm()
                            .format(parkingSpot.exitTime ?? DateTime.now()),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400))
                  ],
                ),
              ],
            ),
            const SizedBox(width: 42),
            Text('R\$${parkingSpot.price!.convertToReal()}',
                textAlign: TextAlign.end,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
          ]),
    );
  }
}
