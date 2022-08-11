import 'package:fina/database/database.dart';
import 'package:flutter/material.dart';

class TimeLineItem extends StatelessWidget {
  final Movimentacoes mov;
  final bool isLast;
  final Color colorItem;

  const TimeLineItem({Key key, this.mov, this.isLast, this.colorItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: width * 0.027,
                    height: height * 0.015,
                    decoration: BoxDecoration(
                        color: colorItem, //Colors.red[900],
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: width * 0.02,
                    height: height * 0.012,
                    decoration: BoxDecoration(
                        color: colorItem, //Colors.red[900],
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: width * 0.02, bottom: width * 0.02),
                    child: Container(
                      width: width * 0.004,
                      height: isLast != true
                          ? height * 0.063
                          : height * 0.063, // tamanho da linha na pg de resumo
                      decoration: BoxDecoration(
                        color: colorItem,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.05, top: width * 0.02),
                    child: Text(
                      mov.data,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: Text(
                      mov.descricao,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.05,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.05, top: width * 0.02),
                    child: Text(
                      mov.tipo == "d" ? mov.descricaoCat : mov.descricaoCatRc,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.032,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.05),
            child: Text(
              mov.tipo == "r" ? "R\$ ${mov.valor}" : "R\$ ${mov.valor}",
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
