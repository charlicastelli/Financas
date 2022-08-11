import 'package:fina/database/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDialog extends StatefulWidget {
  final Movimentacoes mov;
  const CustomDialog({Key key, this.mov}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var formatter = new DateFormat('dd-MM-yyyy');
  bool edit;

  int _groupValueRadio = 2;
  Color _colorContainer = Colors.green[400];
  Color _colorTextButtom = Colors.green;
  TextEditingController _controllerValorDesp = TextEditingController();
  TextEditingController _controllerDesp = TextEditingController();

  MovimentacoesHelper _movHelper = MovimentacoesHelper();

  String dropdownValue = "Categoria";
  List<String> options = [
    "Categoria",
    "🏋‍♀ Cuidados pessoais",
    "🍔 Lanches",
    "🍽 Alimentação",
    "🏠 Moradia",
    "🚗 Transporte",
    "🏖 Lazer",
    "🛠 Ferramentas e acessórios",
    "💉 Saúde",
    "👕 Vestuário",
    "🖊 Assinaturas",
    "✳ Outros",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.mov != null) {
      print(widget.mov.toString());

      edit = true;
      _controllerValorDesp.text =
          widget.mov.valor.toString().replaceAll("-", "");
      _controllerDesp.text = widget.mov.descricao;
      dropdownValue = widget.mov.descricaoCat;
    } else {
      edit = false;
    }
    print(" edit -> $edit");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.050)),
        title: Text(
          "Nova despesa",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                        controller: _controllerValorDesp,
                        maxLength: 10,
                        style: TextStyle(fontSize: width * 0.05),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        maxLines: 1,
                        //textAlign: TextAlign.end,
                        decoration: new InputDecoration(
                          labelText: "R\$0,00",
                          labelStyle: TextStyle(color: Colors.redAccent),
                          contentPadding: EdgeInsets.only(
                              left: width * 0.04,
                              top: width * 0.041,
                              bottom: width * 0.041,
                              right: width * 0.04),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  controller: _controllerDesp,
                  maxLength: 15,
                  style: TextStyle(fontSize: width * 0.05),
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: new InputDecoration(
                    labelText: "Descrição",
                    labelStyle: TextStyle(color: Colors.redAccent),
                    //hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: EdgeInsets.only(
                        left: width * 0.04,
                        top: width * 0.041,
                        bottom: width * 0.041,
                        right: width * 0.04),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              DropdownButton<String>(
                value: dropdownValue,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.redAccent,
                ),
                onChanged: (String data) {
                  setState(() {
                    dropdownValue = data;
                  });
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.only(top: width * 0.09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: width * 0.02,
                          bottom: width * 0.02,
                          left: width * 0.03,
                          right: width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.05),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controllerValorDesp.text.isNotEmpty &&
                            _controllerDesp.text.isNotEmpty &&
                            dropdownValue.isNotEmpty) {
                          Movimentacoes mov = Movimentacoes();
                          String valor;
                          if (_controllerValorDesp.text.contains(",")) {
                            valor = _controllerValorDesp.text
                                .replaceAll(RegExp(","), ".");
                          } else {
                            valor = _controllerValorDesp.text;
                          }

                          mov.data = formatter.format(DateTime.now());
                          mov.descricao = _controllerDesp.text;
                          mov.descricaoCat = dropdownValue;

                          if (_groupValueRadio == 1) {
                            mov.valor = double.parse(valor);
                            mov.tipo = "r";
                            if (widget.mov != null) {
                              mov.id = widget.mov.id;
                            }
                            edit == false
                                ? _movHelper.saveMovimentacao(mov)
                                : _movHelper.updateMovimentacao(mov);
                          }
                          if (_groupValueRadio == 2) {
                            mov.valor = double.parse("-" + valor);
                            mov.tipo = "d";
                            if (widget.mov != null) {
                              mov.id = widget.mov.id;
                            }
                            edit == false
                                ? _movHelper.saveMovimentacao(mov)
                                : _movHelper.updateMovimentacao(mov);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: width * 0.02,
                            bottom: width * 0.02,
                            left: width * 0.03,
                            right: width * 0.03),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.redAccent,
                        ),
                        child: Center(
                          child: Text(
                            edit == false ? "Confirmar" : "Editar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
