import 'package:flutter/material.dart';

class Forcasts extends StatelessWidget {
  final List forcast;
  final List _weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  Forcasts(this.forcast);

  void onTap(int index) {
    print("=======================");
    print(forcast[index]);
    print("=======================");
  }

  @override
  Widget build(BuildContext context) {
    if(forcast == null) {
      return Container();
    }
    return 
      Expanded(

          child: ListView.builder(
            itemCount: forcast.length,
            itemBuilder: (BuildContext context, int index) {
              DateTime currDay = DateTime.fromMillisecondsSinceEpoch(forcast[index]["dt"] * 1000);
            
              // If item is the first day
              // if(index == 0) {
              //   return Card(
              //     child: Column(
              //       children: <Widget>[
                      
              //       ],
              //     )
              //   );
              // }
              return Card(
                child: ExpansionTile(
                  title: Text(_weekDays[currDay.weekday-1] + "    AVERAGE TEMP: " + forcast[index]["temp"]["day"].toString() +  "\n" + currDay.toString().split(" ")[0]),
                  children: <Widget>[
                    Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: forcast[index]["detail"]
                          .map<Widget>((elem) => Card(
                                child: Container(
                                    child:
                                      Text(elem["dt_txt"] + "  " + elem["weather"][0]["main"]),

                                      
                                    padding: const EdgeInsets.all(20.0)),
                              ))
                          .toList(),
                    ),
                  )   
                  ],             
                ),
              );
            },
          )
        );
    
  // <Widget>[
  //                   Text(forcast[index]["detail"].length.toString())
  //                 ],  

  }
}
