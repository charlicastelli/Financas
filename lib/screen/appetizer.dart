import 'package:fina/database/database.dart';
import 'package:fina/screen/homePage.dart';
import 'package:fina/widgets/timeLine.dart';
import 'package:flutter/material.dart';

class ReceitasResumo extends StatefulWidget {
  @override
  _ReceitasResumoState createState() => _ReceitasResumoState();
}

class _ReceitasResumoState extends State<ReceitasResumo> {
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = List();
  var rec;
  String saldoRec = "R\$0,00";

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("r").then((list) {
      setState(() {
        listmovimentacoes = list;
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  somaRec() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("r").then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = list;
        });
        rec =
            listmovimentacoes.map((item) => item.valor).reduce((a, b) => a + b);
        saldoRec = format(rec).toString();
      } else {
        setState(() {
          listmovimentacoes.clear();
          rec = "0.00";
          saldoRec = rec.toString();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allMovPorTipo();
    somaRec();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(
          "Receitas",
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
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      height: 50.0,
                      width: 50.0,
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      listmovimentacoes.isNotEmpty
                          ? 'R\$ ${saldoRec}'
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
                        colorItem: Colors.green,
                        isLast: true,
                      );
                    } else {
                      return TimeLineItem(
                        mov: mov,
                        colorItem: Colors.green,
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
