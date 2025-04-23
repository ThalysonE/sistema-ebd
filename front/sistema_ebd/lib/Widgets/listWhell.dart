import 'package:flutter/material.dart';

class ListaIdade extends StatefulWidget {
  final int idadeMin;
  final ValueNotifier<int> idadeAtual;
  ListaIdade({super.key, required this.idadeMin, required this.idadeAtual});

  @override
  State<ListaIdade> createState() => _ListaIdadeState();
}

class _ListaIdadeState extends State<ListaIdade> {

  late FixedExtentScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.idadeMin == 0? widget.idadeAtual.value:widget.idadeAtual.value-widget.idadeMin,);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListWheelScrollView(
          controller: _controller,
          squeeze: 1.2,
          overAndUnderCenterOpacity: .6,
          itemExtent: 50,
          perspective: 0.005,
          diameterRatio: 1.2,
          physics: FixedExtentScrollPhysics(),
          onSelectedItemChanged: (value){
            if(widget.idadeMin != 0){
              value += widget.idadeMin;
            }

            widget.idadeAtual.value = value;
            print(widget.idadeAtual.value);
          },
          children: [
            for (int x = widget.idadeMin; x < 100; x++)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: Center(
                    child: Text(
                      x.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(122, 189, 189, 190),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 360,
            height: 50,
          ),
        ),
      ],
    );
  }
}
