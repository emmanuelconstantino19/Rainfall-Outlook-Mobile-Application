import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

Future<String> loadProvince() async {
  return await rootBundle
      .loadString('assets/forecast-Jan-May-provincial.csv');
}

Future<String> loadMunicipal() async {
  return await rootBundle
      .loadString('assets/forecast-Jan-May-municipal.csv');
}

/** MODAL **/
void showModal(BuildContext context) {
  Dialog simpleDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    child:
    ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Align(
          alignment: Alignment(1, 0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(
                Icons.close,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
        //Modal Title
        Container(
          padding: EdgeInsets.only(bottom:15.0),
          child: Text(
            'Rainfall Outlook',
            style: TextStyle(fontSize: 22, fontWeight:FontWeight.w600),
          ),
        ),
        Container(
          child: const Center(child: Text('The 5-month rainfall outlook was produced from the ensemble mean model – a combination of seven different models developed and obtained from National Oceanic and Atmospheric Administration - Climate Prediction Center (NOAA-CPC). The forecasted ensemble mean model shows the deviation of rainfall in mm/day with respect to the initial weather condition of an area during the present month. It is then processed in QGIS to produce monthly rainfall forecast per municipality.',style: TextStyle(fontSize: 16))),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical:15.0),
          child: const Center(child: Text('This information is helpful in creating intelligent decision to schedule different farming operations such as land preparation, transplanting, irrigation management, and harvesting.',style: TextStyle(fontSize: 16))),
        ),
      ],
    )


//    Container(
//      width: MediaQuery.of(context).size.width*0.80,
//      height: MediaQuery.of(context).size.height*0.60,
//      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
//      child: Column(
//        children: <Widget>[
//          //Close button
//          Align(
//            alignment: Alignment(1, 0),
//            child: InkWell(
//              onTap: () {
//                Navigator.pop(context);
//              },
//              child: Container(
//                child: Icon(
//                  Icons.close,
//                  color: Colors.grey[300],
//                ),
//              ),
//            ),
//          ),
//
//          //Modal Title
//          Container(
//            padding: EdgeInsets.all(1.0),
//            child: Text(
//              'Rainfall Outlook Information',
//              style: TextStyle(fontSize: 22, fontWeight:FontWeight.w600),
//            ),
//          ),
//
//          //Modal Information texts
//          Container(
//            padding: EdgeInsets.fromLTRB(20, 20, 15, 20),
//            child: Text(
//              '     Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Laoreet suspendisse interdum consectetur libero id faucibus nisl. Blandit cursus risus at ultrices mi tempus. Et ultrices neque ornare aenean euismod. Fringilla est ullamcorper eget nulla. Aliquet enim tortor at auctor urna nunc id. Dictum sit amet justo donec enim diam. Nunc sed augue lacus viverra vitae congue. Ullamcorper sit amet risus nullam. Ultrices in iaculis nunc sed. Nunc faucibus a pellentesque sit.',
//              style: TextStyle(fontSize: 16),
//            ),
//          ),
//        ],
//      ),
//    ),
  );
  showDialog(
      context: context, builder: (BuildContext context) => simpleDialog);
}

class MonthsYearList {
  List<dynamic> months = <dynamic>[];
  List<int> years = <int>[];
  int currentYear;

  MonthsYearList();

  void addMonth(var month){
    if(months.isEmpty){
      currentYear = (new DateTime.now()).year;
      years.add(currentYear);
    }else if(months.last.toString()=="Dec"){
      years.add(currentYear+1);
    }else{
      years.add(currentYear);
    }
    months.add(month.trim());
  }
  String getFullString(String month){
    List<String> fullMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return fullMonths.firstWhere((string)=>string.toLowerCase().contains(month.toLowerCase()));
  }
  String getRange(){
    return "("+getFullString(months.first)+" "+years.first.toString()+" - "+getFullString(months.last)+" "+years.last.toString()+")";
  }
}

class MunicipalData {
  var provinceName, name, monthValues;
  List<Color> colors;
  MunicipalData(this.provinceName, this.name, this.monthValues);

  void setColors() {
    colors = monthValues.map<Color>((val) {
      if (val < 50)
        return Color(0xffe1e1e1);
      else if (val >= 50 && val < 100)
        return Color(0xffbee8ff);
      else if (val >= 100 && val < 200)
        return Color(0xff00c5ff);
      else if (val >= 200 && val < 300)
        return Color(0xff0070ff);
      else if (val >= 300 && val < 400)
        return Color(0xff004da8);
      else if (val >= 400 && val < 500)
        return Color(0xff002673);
      else if (val > 500)
        return Color(0xff000000);
      else
        return Color(0xffffffff);
    }).toList();
  }
}

class ProvinceData {
  var name, monthValues;
  List<Color> colors;
  List<MunicipalData> municipalities = <MunicipalData>[];
  ProvinceData(this.name, this.monthValues);

  void setColors(){
    colors = monthValues.map<Color>((val) {
      if (val < 50)
        return Color(0xffe1e1e1);
      else if (val >= 50 && val < 100)
        return Color(0xffbee8ff);
      else if (val >= 100 && val < 200)
        return Color(0xff00c5ff);
      else if (val >= 200 && val < 300)
        return Color(0xff0070ff);
      else if (val >= 300 && val < 400)
        return Color(0xff004da8);
      else if (val >= 400 && val < 500)
        return Color(0xff002673);
      else if (val >= 500)
        return Color(0xff000000);
      else
        return Color(0xffffffff);
    }).toList();
  }

  void addMunicipality(MunicipalData data){
    this.municipalities.add(data);
  }

  MunicipalData getMunicipalDataByName(String name){
    return municipalities.firstWhere((MunicipalData data){
      if(data.name==name){
        return true;
      }else{
        return false;
      }
    });
  }

}

//List of all Data Read from sources
class RainfallDataSource {
  List<ProvinceData> rainfallData;

  void addMunicipalityToProvince(String provinceName,MunicipalData municipality){
    rainfallData.firstWhere((E) {
      if (E.name == provinceName) {
        return true;
      }
      else {
        return false;
      }
    }).addMunicipality(municipality);
  }

  ProvinceData getProvinceDataByName(String provinceName) {
    return (rainfallData.firstWhere((E) {
      if (E.name == provinceName)
        return true;
      else
        return false;
    }));
  }

  List<DropdownMenuItem<String>> getProvinceMenuNames() {
    return rainfallData.map<DropdownMenuItem<String>>((ProvinceData prov) {
      return DropdownMenuItem<String>(
        value: prov.name,
        child: SizedBox(
          width: 500.0, // for example
          child: Text(prov.name, textAlign: TextAlign.center,style:TextStyle(fontSize:13)),
        ),
      );
    }).toList();
  }
}

//Data selected and shown on the app
class RowDataSource {
  ProvinceData provinceData;
  ProvinceData tableData;
  bool ascendingSort = true;
  int sortedField = 0;

  void _sort(int field) {
    if(this.sortedField == field){
      this.ascendingSort = !this.ascendingSort;

    }else{
      this.ascendingSort = true;
    }
    this.sortedField = field;

    tableData.municipalities.sort((MunicipalData a, MunicipalData b) {
      Comparable aValue;
      Comparable bValue;
      if (!this.ascendingSort) {
        final MunicipalData c = a;
        a = b;
        b = c;
      }
      if(field==0){ //if field to sort is municipality name
        aValue = a.name;
        bValue = b.name;
      }else{ //if field to sort is specific month value
        aValue = a.monthValues.toList()[field-1];
        bValue = b.monthValues.toList()[field-1];
      }
      return Comparable.compare(aValue, bValue);
    });
  }

  Container getSortingIcons(int index){
    return Container(
        width: 2,
        child: Column(
            children: <Widget>[
              Container(
                child: Icon(Icons.arrow_drop_up,size:10,color:(){
                  if(sortedField==index){
                    if(ascendingSort){
                      return Colors.blue;
                    }else{
                      return Colors.blue[100];
                    }
                  }else{
                    return Colors.black26;
                  }
                }()),
              ),
              Container(
                child: Icon(Icons.arrow_drop_down,size:10,color:(){
                  if(sortedField==index){
                    if(!ascendingSort){
                      return Colors.blue[800];
                    }else{
                      return Colors.blue[200];
                    }
                  }else{
                    return Colors.black26;
                  }
                }()),
              ),
            ]
        )
    );
  }

  List<DropdownMenuItem<String>> getMunicipalMenuNames() {
    if(provinceData==null || provinceData.municipalities == null){
      return null;
    }else{
      List<DropdownMenuItem<String>> municipalitiesList = <DropdownMenuItem<String>>[];
      municipalitiesList.add(DropdownMenuItem<String>(
        value: "All",
        child: SizedBox(
          width: 500.0, // for example
          child: Text("All", textAlign: TextAlign.center,style:TextStyle(fontSize:13)),
        ),
      ));

      List<DropdownMenuItem<String>> municipalDataList = (provinceData.municipalities.map<DropdownMenuItem<String>>((MunicipalData muni) {
        return DropdownMenuItem<String>(
          value: muni.name,
          child: SizedBox(
            width: 500.0, // for example
            child: Text(muni.name, textAlign: TextAlign.center,style:TextStyle(fontSize:13)),
          ),
        );
      })).toList();
      for(var mddl in municipalDataList){
        municipalitiesList.add(mddl);
      }
      return(municipalitiesList);
    }
  }

  List<DataRow> getDataRows(){
    List<DataRow> dataRows = <DataRow>[];
    for (var i = 0;i < tableData.municipalities.length;i++) {
      dataRows.add(new DataRow(cells: () {
        List<DataCell> cellList = new List<DataCell>();
        cellList.add(new DataCell(Center(
          child: Container(
            child: Text(tableData.municipalities[i].name,
                textAlign:TextAlign.left
            ),
            width: 100.0,
          ),
        )));
        for (var j = 0;j < tableData.monthValues.length;j++) {
          cellList.add(new DataCell(
              Text(tableData.municipalities[i].monthValues.toList()[j].toString(),
                  textAlign: TextAlign.center)));
        }
        return cellList;
      }()));
    }
    return dataRows;
  }

  List<Color> getFontColors(String dropdownValue){
    if(dropdownValue == "All"){
      return provinceData.monthValues.map<Color>((var c){
        if(c < 200){
          return Colors.black;
        }else{
          return Colors.white;
        }
      }).toList();
    }else{
      return provinceData.getMunicipalDataByName(dropdownValue).monthValues.map<Color>((var c){
        if(c < 200){
          return Colors.black;
        }else{
          return Colors.white;
        }
      }).toList();
    }
  }

  List<Color> getBoxColors(String dropdownValue){
    if(dropdownValue == "All"){
      return provinceData.colors.toList();
    }else{
      return provinceData.getMunicipalDataByName(dropdownValue).colors.toList();
    }
  }

  List<dynamic> getBoxValues(String dropdownValue){
    if(dropdownValue == "All"){
      return provinceData.monthValues.toList();
    }else{
      return provinceData.getMunicipalDataByName(dropdownValue).monthValues.toList();
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rainfall Outlook Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(title: 'Rainfall Outlook Demo')
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  MonthsYearList monthsYearList = MonthsYearList();
  RainfallDataSource sourceData = RainfallDataSource();
  RowDataSource rowSource = RowDataSource();

  String provDropdownValue;
  String muniDropdownValue;

  String getMunicipal(String municipal){
    if(municipal=="All")
      return provDropdownValue;
    return municipal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/sarai_logo.png',
              fit: BoxFit.contain,
              height: 50,
            ),
            Image.asset(
              'assets/dost-pcaarrd-uplb.png',
              fit: BoxFit.contain,
              height: 60,
            ),
          ],
        ),
        backgroundColor: Colors.green[900],
      ),
      body: Container(
        //Builder for File reading Provincial Data
          child: FutureBuilder<String>(
              future: loadProvince(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.hasData) {
                      if (monthsYearList.months.isEmpty) {
                        var months = snapshot.data
                            .split('\n')
                            .map((data) => data.split(','))
                            .toList()[0]
                            .sublist(1);
                        for(var month in months){
                          monthsYearList.addMonth(month);
                        }
                      }
                      if (sourceData.rainfallData == null) {
                        var provData = snapshot.data
                            .split('\n')
                            .map((data) => data.split(','))
                            .toList()
                            .sublist(1)
                            .map((data) {
                          var values = data.sublist(1).map((x) => double.parse(x).round());
                          ProvinceData provData = new ProvinceData(data[0],values);
                          provData.setColors();
                          return provData;
                        }).toList();
                        sourceData.rainfallData = provData;
                      }

                      //Builder for File reading Municipal Data
                      return FutureBuilder<String>(
                          future: loadMunicipal(),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.active:
                              case ConnectionState.waiting:
                              case ConnectionState.done:
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                                else if (snapshot.hasData) {
                                  if(!sourceData.rainfallData.any((ProvinceData data){
                                    if(data.municipalities.isEmpty || data.municipalities==null){
                                      return false;
                                    }else{
                                      return true;
                                    }
                                  })){
                                    var municipalities = snapshot.data
                                        .split('\n')
                                        .map((data) => data.split(','))
                                        .toList()
                                        .sublist(1)
                                        .map((data) {
                                      var values = data
                                          .sublist(2)
                                          .map((x) => double.parse(x).round());
                                      MunicipalData muniData = new MunicipalData(data[0],data[1], values);
                                      muniData.setColors();
                                      return muniData;
                                    });
                                    for(var muniData in municipalities){
                                      sourceData.addMunicipalityToProvince(muniData.provinceName,muniData);
                                    }
                                  }

                                  //set Initial Values of Dropdowns
                                  if(provDropdownValue==null){
                                    this.provDropdownValue = sourceData.rainfallData.first.name;
                                    this.muniDropdownValue = "All";
                                    this.rowSource.provinceData = sourceData.getProvinceDataByName(sourceData.rainfallData.first.name);
                                    this.rowSource.tableData = this.rowSource.provinceData;
                                  }
                                  // Main Body Code
                                  return ListView(
                                    children: <Widget>[
                                      //Top Information Container
                                      Container(
                                          height: 36,
                                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                                          child: Center(
                                            child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: const Text('Rainfall Outlook',style: TextStyle(fontSize: 28, fontWeight:FontWeight.w400)),
                                                    alignment: Alignment.topCenter,
                                                  ),
                                                  Container(
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          showModal(context);
                                                        },
                                                        child: Icon(Icons.info_outline, color:Colors.black38),
                                                        shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                                                      ),
                                                      alignment: Alignment.topRight
                                                  ),


                                                ]
                                            ),
                                          )
                                      ),
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                          height:17,
                                          child: Center(child: Text(monthsYearList.getRange(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300)))
                                      ),
                                      Container(
                                          padding:const EdgeInsets.fromLTRB(8, 16, 8, 3),
                                          child: const Center(child: Text('Know the 5-month rainfall forecast of municipalities with arable and cultivated land based on land cover classification of DA-BAR.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12, color:Colors.black54)))
                                      ),
                                      Container(
                                          padding:const EdgeInsets.fromLTRB(8, 0, 8, 25),
                                          child: const Center(child: Text('Source: SEAMS; NOAA-Climate Prediction Center',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w300)))
                                      ),

                                      //DropdownContainers
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              const Center(child: Text('PROVINCE',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))),
                                              const Center(child: Text('MUNICIPALITY',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500)))
                                            ]
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 10.0),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[

                                                //Province Dropdown Widget
                                                SizedBox(
                                                  width: 160,
                                                  child:DropdownButton<String>(
                                                    isExpanded: true,
                                                    icon: Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.black,fontSize: 20),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.black,
                                                    ),
                                                    hint: Center(
                                                      child: Text("Select Province",style:TextStyle(fontSize:15)),
                                                    ),
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        this.provDropdownValue = newValue;
                                                        this.muniDropdownValue = "All";
                                                        this.rowSource.provinceData = sourceData.getProvinceDataByName(newValue);
                                                        this.rowSource.tableData = this.rowSource.provinceData;
                                                      });
                                                    },
                                                    value: provDropdownValue,
                                                    items: sourceData.getProvinceMenuNames(),
                                                  ),
                                                ),

                                                //Municipality Dropdown Widget
                                                SizedBox(
                                                  width: 160,
                                                  child:DropdownButton<String>(
                                                    isExpanded: true,
                                                    icon: Icon(Icons.arrow_downward),
                                                    iconSize: 24,
                                                    elevation: 16,
                                                    style: TextStyle(color: Colors.black,fontSize: 20),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.black,
                                                    ),
                                                    disabledHint: Center(
                                                      child: Text("",style:TextStyle(fontSize:15)),
                                                    ),
                                                    hint: Center(
                                                      child: Text("All",style:TextStyle(fontSize:13)),
                                                    ),
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        this.muniDropdownValue = newValue;
//                                          this.rowSource.rowData = rowSource.getMunipalDataByName(newValue);
                                                      });
                                                    },
                                                    value: muniDropdownValue,
                                                    items: rowSource.getMunicipalMenuNames(),
                                                  ),
                                                ),
                                              ]
                                          )
                                      ),

                                      Container(
                                          padding:const EdgeInsets.fromLTRB(8, 11, 8, 11),
                                          child: Center(child: Text('Rainfall Outlook for '+getMunicipal(muniDropdownValue),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 21)))
                                      ),

                                      //Colored Box Containers
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: () {
                                              List<Widget> list = new List<Widget>();
                                              for (var i = 0; i < monthsYearList.months.length; i++) {
                                                list.add(new Expanded(
                                                    child: Padding(
                                                        padding: EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
                                                        child: Container(
                                                            height: 80.0,
                                                            decoration: BoxDecoration(
                                                              boxShadow: <BoxShadow>[BoxShadow()],
                                                              //BOX COLOR
                                                              color: rowSource.getBoxColors(muniDropdownValue)[i],
                                                            ),
                                                            child: Padding(
                                                                padding: EdgeInsets.fromLTRB(2.0, 15.0, 2.0, 15.0),
                                                                child: Column(
                                                                  children: <Widget>[
                                                                    //MONTH + YEAR
                                                                    Text(monthsYearList.months[i] +' ' +monthsYearList.years[i].toString(),
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontSize: 10,
                                                                            color: rowSource.getFontColors(muniDropdownValue)[i])),
                                                                    Container(
                                                                        margin:const EdgeInsets.only(top: 10),
                                                                        child: Column(
                                                                          //MM VALUES
                                                                          children: <Widget>[
                                                                            Text(rowSource.getBoxValues(muniDropdownValue)[i].toString(),
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    color: rowSource.getFontColors(muniDropdownValue)[i])),
                                                                            Text('mm',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    fontSize: 10,
                                                                                    color: rowSource.getFontColors(muniDropdownValue)[i])),
                                                                          ],
                                                                        ))
                                                                  ],
                                                                ))))),
                                                );
                                              }
                                              return list;
                                            }(),
                                          )
                                      ),
                                      //Legend Containers
                                      Container(
                                          padding:const EdgeInsets.fromLTRB(8, 7, 8, 0),
                                          child: Center(
                                              child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Center(
                                                            child:Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.lens, color:Color(0xffe1e1e1), size:16),
                                                                  Text("< 50 mm", style:TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    Container(
                                                        child: Center(
                                                            child:Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.lens, color:Color(0xffbee8ff), size:16),
                                                                  Text("51-100 mm", style:TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    Container(
                                                        child: Center(
                                                            child:Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.lens, color:Color(0xff00c5ff), size:16),
                                                                  Text("101-200 mm", style:TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    Container(
                                                        child: Center(
                                                            child:Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.lens, color:Color(0xff0070ff), size:16),
                                                                  Text("201-300 mm", style:TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                  ]
                                              )
                                          )
                                      ),
                                      Container(
                                          padding:const EdgeInsets.fromLTRB(8, 3, 8, 11),
                                          child: Center(
                                              child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Center(
                                                            child:Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.lens, color:Color(0xff004da8), size:16),
                                                                  Text("301-400 mm", style:TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    Container(
                                                        child: Center(
                                                            child:Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.lens, color:Color(0xff002673), size:16),
                                                                  Text("401-500 mm", style:TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    Container(
                                                        child: Center(
                                                            child:Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.lens, color:Color(0xff000000), size:16),
                                                                  Text("> 501 mm", style:TextStyle(fontSize: 13, color:Colors.black87,fontWeight: FontWeight.w500))
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                  ]
                                              )
                                          )
                                      ),

                                      Divider(
                                        endIndent: 11,
                                        indent: 11,
                                      ),

                                      //Section title & subtitle
                                      Container(
                                          padding:const EdgeInsets.fromLTRB(8, 11, 8, 0),
                                          child: Center(child: Text('Rainfall Outlook for '+provDropdownValue+' Municipalities',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 21)))
                                      ),
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                          height:17,
                                          child: Center(child: Text(monthsYearList.getRange(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300)))
                                      ),

                                      //Table
                                      Container(
                                        padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                                        child: Center(
                                            child: DataTable(
                                              columnSpacing: 5.0,
                                              dataRowHeight: 40,
                                              headingRowHeight: 20,
                                              columns: () {
                                                List<DataColumn> columnList =
                                                new List<DataColumn>();
                                                //Municipality Header
                                                columnList.add(new DataColumn(
                                                    onSort: (index,bool){
                                                      setState(() {
                                                        rowSource._sort(0);
                                                      });
                                                    },
                                                    label: Container(
                                                        child: Row(
                                                            children: <Widget>[
                                                              Text('Municipality',
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      fontWeight:FontWeight.bold)),
                                                              rowSource.getSortingIcons(0)
                                                            ]
                                                        )
                                                    )
                                                ));

                                                //Month Headers
                                                for (var i = 0;
                                                i < monthsYearList.months.length;
                                                i++) {
                                                  columnList.add(new DataColumn(
                                                      onSort: (index,b){
                                                        setState(() {
                                                          rowSource._sort(i+1);
                                                        });
                                                      },
                                                      label: Container(
                                                          child: Row(
                                                              children: <Widget>[
                                                                Text(monthsYearList.months[i],
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight:FontWeight.bold)),
                                                                rowSource.getSortingIcons(i+1)
                                                              ]
                                                          )
                                                      )
                                                  ));
                                                }
                                                return columnList;
                                              }(),
                                              rows: rowSource.getDataRows(),
                                            )
                                        ),
                                      ),
                                      //Footer
                                      Container(
                                          color: Colors.black54,
                                          height: 140,
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                                              child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                        alignment: Alignment.centerLeft,
                                                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                                        child: Text("Connect With Us", style: TextStyle(
                                                            fontSize: 23,
                                                            color: Colors.white,
                                                            fontWeight:FontWeight.bold))
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
                                                        child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                  child: Row(
                                                                      children: <Widget>[
                                                                        Icon(Icons.phone, color:Colors.white, size:18),
                                                                        Text("  +63 (049) 536 2302,+63 (049) 536 2836",style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 12,
                                                                            fontWeight:FontWeight.w300
                                                                        )
                                                                        )
                                                                      ]
                                                                  )
                                                              ),
                                                              Container(
                                                                  padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                                                                  child: Row(
                                                                      children: <Widget>[
                                                                        Icon(Icons.markunread, color:Colors.white, size:18),
                                                                        Text("  project.sarai.uplb@gmail.com",style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 12,
                                                                            fontWeight:FontWeight.w300
                                                                        )
                                                                        )
                                                                      ]
                                                                  )
                                                              ),
                                                              Container(
                                                                  padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                                                                  child: Row(
                                                                      children: <Widget>[
                                                                        Icon(Icons.place, color:Colors.white, size:18),
                                                                        Text("  SESAM UPLB, College, Laguna Philippines 4031",style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 12,
                                                                            fontWeight:FontWeight.w300
                                                                        )
                                                                        )
                                                                      ]
                                                                  )
                                                              ),

                                                            ]
                                                        )
                                                    )

                                                  ]
                                              )
                                          )

                                      )
                                    ],
                                  );
                                } else
                                  return Text('');
                            }
                            return null;
                          }

                      );
                    }
                }
                return Text("");
              }
          )
      ),
    );
  }

}
