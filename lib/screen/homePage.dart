import 'dart:ui';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:fina/database/database.dart';
import 'package:fina/newCalculator/newCalculator.dart';
import 'package:fina/widgets/card.dart';
import 'package:fina/widgets/customAppetizer.dart';
import 'package:fina/widgets/customExits.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'appetizer.dart';
import 'exits.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  String saldoAtual = "0,00";
  String cifrao = "R\$";
  var total;
  var width;
  var height;
  bool recDesp = false;
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  MovimentacoesHelper movHelper = MovimentacoesHelper();
  TextEditingController _valorController = TextEditingController();
  CalendarController calendarController;
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = List();
  List<Movimentacoes> ultimaTarefaRemovida = List();

  var dataAtual = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatterCalendar = new DateFormat('MM-yyyy');
  String dataFormatada;

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _addValor() {
    String valor = _valorController.text;
    setState(() {
      saldoAtual = valor;
    });
  }

  _saldoTamanho(String conteudo) {
    if (conteudo.length > 8) {
      return width * 0.08;
    } else {
      return width * 0.1;
    }
  }

  _salvar() {
    dataFormatada = formatter.format(dataAtual);
    Movimentacoes mov = Movimentacoes();
    mov.valor = 20.50;
    mov.tipo = "r";
    mov.data = "10-03-2020"; //dataFormatada;
    mov.descricao = "CashBack";
    MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
    movimentacoesHelper.saveMovimentacao(mov);
    mov.toString();
  }

  _allMov() {
    movimentacoesHelper.getAllMovimentacoes().then((list) {
      setState(() {
        listmovimentacoes = list;
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  _allMovMes(String data) {
    movimentacoesHelper.getAllMovimentacoesPorMes(data).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = list;
        });
        total =
            listmovimentacoes.map((item) => item.valor).reduce((a, b) => a + b);
        saldoAtual = format(total).toString();
      } else {
        setState(() {
          listmovimentacoes.clear();
          total = "0.00";
          saldoAtual = total.toString();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calendarController = CalendarController();
    if (DateTime.now().month != false) {}
    dataFormatada = formatterCalendar.format(dataAtual);
    print(dataFormatada);
    _allMovMes(dataFormatada);
  }

  _dialogAddRec() {
    showDialog(
        context: context,
        builder: (context) {
          return CardReceitas();
        });
  }

  _dialogAddRecDesp() {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    _allMovMes(dataFormatada);
    return Scaffold(
        key: _scafoldKey,
        body: SingleChildScrollView(
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.385,
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32))),
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TableCalendar(
                      calendarController: calendarController,
                      locale: "pt_BR",
                      headerStyle: HeaderStyle(
                        formatButtonShowsNext: false,
                        formatButtonVisible: false,
                        centerHeaderTitle: true,
                      ),
                      calendarStyle: CalendarStyle(outsideDaysVisible: false),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.transparent),
                        weekendStyle: TextStyle(color: Colors.transparent),
                      ),
                      rowHeight: 0,
                      initialCalendarFormat: CalendarFormat.month,
                      onVisibleDaysChanged:
                          (dateFirst, dateLast, CalendarFormat cf) {
                        print(dateFirst);

                        dataFormatada = formatterCalendar.format(dateFirst);
                        _allMovMes(dataFormatada);

                        print("DATA FORMATADA CALENDAR $dataFormatada");
                      },
                    ),
                    Text(
                      'Saldo total',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cifrao,
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          saldoAtual,
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  height: 40.0,
                                  width: 100.0, //correto 40.0
                                  child: Icon(
                                    Icons.trending_up,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ReceitasResumo()));
                                },
                              ),
                              // GestureDetector(
                              //   child: Column(
                              //     children: <Widget>[
                              //       Text('Receitas'),
                              //       Text(
                              //         'R\$ 0,00',
                              //         style: TextStyle(
                              //           fontSize: 18.0,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.green,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              //   onTap: () {
                              //     Navigator.of(context).push(MaterialPageRoute(
                              //         builder: (context) => ReceitasResumo()));
                              //   },
                              // )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  height: 40.0,
                                  width: 100.0, //correto 40.0
                                  child: Icon(
                                    Icons.trending_down,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DespesasResumo()));
                                },
                              ),
                              // GestureDetector(
                              //   child: Column(
                              //     children: <Widget>[
                              //       Text('Despesas'),
                              //       Text(
                              //         //saldoDes,
                              //         'R\$ 0,00',
                              //         style: TextStyle(
                              //           fontSize: 18.0,
                              //           fontWeight: FontWeight.bold,
                              //           color: Colors.red,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              //   onTap: () {
                              //     Navigator.of(context).push(MaterialPageRoute(
                              //         builder: (context) => DespesasResumo()));
                              //   },
                              // )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.04, right: width * 0.04, top: 0),
                child: SizedBox(
                  width: width,
                  height: height * 0.5, //tamanho da tela da lista
                  child: ListView.builder(
                    itemCount: listmovimentacoes.length,
                    itemBuilder: (context, index) {
                      Movimentacoes mov = listmovimentacoes[index];
                      Movimentacoes ultMov = listmovimentacoes[index];
                      return Dismissible(
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            listmovimentacoes.removeAt(index);
                          });
                          movHelper.deleteMovimentacao(mov);
                          final snackBar = SnackBar(
                            content: Container(
                              padding: EdgeInsets.only(bottom: width * 0.025),
                              alignment: Alignment.bottomLeft,
                              height: height * 0.05,
                              child: Text(
                                "Item excluido",
                                style: TextStyle(
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: width * 0.04),
                              ),
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.white24,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            action: SnackBarAction(
                              label: "Desfazer",
                              textColor: Colors.amber,
                              onPressed: () {
                                setState(() {
                                  listmovimentacoes.insert(index, ultMov);
                                });

                                movHelper.saveMovimentacao(ultMov);
                              },
                            ),
                          );
                          _scafoldKey.currentState.showSnackBar(snackBar);
                        },
                        key: ValueKey(mov.id),
                        background: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment(-0.9, 0.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: CardMovimentacoesItem(
                          mov: mov,
                          lastItem:
                              listmovimentacoes[index] == listmovimentacoes.last
                                  ? true
                                  : false,
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FabCircularMenu(
            key: fabKey,
            ringColor: Colors.grey.withAlpha(150), //65
            ringDiameter: 440.0, //500
            ringWidth: 150.0,
            fabSize: 64.0,
            fabElevation: 8.0,
            fabIconBorder: CircleBorder(),

            fabColor: Colors.blueAccent,
            fabOpenIcon: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30,
            ),
            fabCloseIcon: Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            //fabMargin: const EdgeInsets.all(16.0),
            animationDuration: const Duration(milliseconds: 800),
            animationCurve: Curves.easeInOutCirc,
            onDisplayChange: (isOpen) {
              // _showSnackBar(
              //     context, "The menu is ${isOpen ? "open" : "closed"}");
            },
            children: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Calculator()));
                  fabKey.currentState.close(); // reset no fabCircular
                },
                shape: CircleBorder(),
                fillColor: Colors.amberAccent,
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.table_view,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  _dialogAddRec();
                  fabKey.currentState.close(); // reset no fabCircular
                },
                shape: CircleBorder(),
                fillColor: Colors.green,
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  _dialogAddRecDesp();
                  fabKey.currentState.close(); // reset no fabCircular
                },
                shape: CircleBorder(),
                fillColor: Colors.red,
                padding: const EdgeInsets.all(10.0), //24.0
                child: Icon(
                  Icons.trending_down,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              // RawMaterialButton(
              //   onPressed: () {
              //     fabKey.currentState.close(); // reset no fabCircular
              //   },
              //   shape: CircleBorder(),
              //   padding: const EdgeInsets.all(24.0),
              //   child: Icon(
              //     Icons.settings,
              //     color: Colors.deepPurple,
              //     size: 40,
              //   ),
              // )
            ],
          ),
        ));
  }
}
