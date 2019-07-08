import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset('images/nanu.jpg'),
                Container(
                  height: 100,
                  width: 50,
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: ListView(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                        onTap: () => Navigator.pop(context),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "Hello, my name is Nanu. I love to create and make things with my hands. Welcome to my world where i will show my creativeness and love for art."
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("How to contact me?", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("Email me at nanu.rivera.torres@gmail.com", style: TextStyle(fontSize: 12),),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }
}