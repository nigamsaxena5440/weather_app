import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/search/search_provider.dart';
import 'package:weather_app/screens/weather/weather_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Search Weather',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28),),
        backgroundColor: Color(0xFF22B1CD),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF22B1CD), Color(0xFF86B1C3)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Consumer<SearchProvider>(
          builder: (context,provider,child){
            return ListView(
              padding: EdgeInsets.all(15),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: search,
                        decoration:InputDecoration(
                            prefixIconColor:Colors.black ,
                            hintText: 'Search',
                            hintStyle:TextStyle(color: Colors.black),
                            // border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search)
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if (search.text.isNotEmpty){
                          provider.searchRegion(search.text);
                        }
                      },
                      child: Container(

                        padding: EdgeInsets.symmetric(horizontal: 45,vertical: 15),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color:Color(0xFF86B1C3),width: 2 ),
                          color: Colors.black,
                          gradient: LinearGradient(
                            colors: [Color(0xFF22B1CD), Color(0xFF86B1C3)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Icon(Icons.search,color: Colors.black,),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                provider.loading? Center(child: CircularProgressIndicator()):SizedBox(),
                for(var item in provider.items)
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> WeatherScreen(item: item)));
                    },
                    title: Text(item.name?? '',style: TextStyle(color: Colors.black),),
                    subtitle: Text('${item.region} (${item.country})',style: TextStyle(color: Colors.black),),
                  )
              ],
            );
          }
      ),
      ),
    );
  }
}
