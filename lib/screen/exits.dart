import 'package:fina/database/database.dart';
import 'package:fina/widgets/timeLine.dart';
import 'package:flutter/material.dart';

class DespesasResumo extends StatefulWidget {
  @override
  _DespesasResumoState createState() => _DespesasResumoState();
}

class _DespesasResumoState extends State<DespesasResumo> {
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = List();
  var des;
  String saldoDes = "R\$0,00";

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      setState(() {
        listmovimentacoes = list;
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  somaDes() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = list;
        });
        des =
            listmovimentacoes.map((item) => item.valor).reduce((a, b) => a + b);
        saldoDes = format(des).toString();
      } else {
        setState(() {
          listmovimentacoes.clear();
          des = "0.00";
          saldoDes = des.toString();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _allMovPorTipo();
    somaDes();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(
          "Despesas",
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Container(
                width: double.infinity,
                height: height * 0.1,
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(42),
                      topRight: Radius.circular(42),
                      bottomLeft: Radius.circular(42),
                      bottomRight: Radius.circular(42),
                    )),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      height: 50.0,
                      width: 50.0,
                      child: Icon(
                        Icons.trending_down,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      listmovimentacoes.isNotEmpty
                          ?
                          // 'R\$ 0,00',
                          'R\$ ${saldoDes}'
                          : 'R\$ 0,00',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.08),
              child: SizedBox(
                width: width,
                height: height * 0.74,
                child: ListView.builder(
                  itemCount: listmovimentacoes.length,
                  itemBuilder: (context, index) {
                    List movReverse = listmovimentacoes.reversed.toList();
                    Movimentacoes mov = movReverse[index];

                    if (movReverse[index] == movReverse.last) {
                      return TimeLineItem(
                        mov: mov,
                        colorItem: Colors.redAccent,
                        isLast: true,
                      );
                    } else {
                      return TimeLineItem(
                        mov: mov,
                        colorItem: Colors.redAccent,
                        isLast: false,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
