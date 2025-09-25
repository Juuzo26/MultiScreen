import 'package:flutter/material.dart';
// Render deploy trigger: trivial change

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final List<Worker> people = [
    Worker(
      'John Doe',
      'Software Engineer',
      'https://skilledtradesbc.ca/sites/default/files/styles/post_card_2_3_mobile_1x/public/2023-01/tradeworkers_02_web.jpg.webp?itok=Xjijnn_9',
    ),
    Worker(
      'Jane Smith',
      'Product Manager',
      'https://skilledtradesbc.ca/sites/default/files/styles/post_card_2_3_mobile_1x/public/2023-01/tradeworkers_02_web.jpg.webp?itok=Xjijnn_9',
    ),
    Worker(
      'Bob Johnson',
      'Marketing Specialist',
      'https://skilledtradesbc.ca/sites/default/files/styles/post_card_2_3_mobile_1x/public/2023-01/tradeworkers_02_web.jpg.webp?itok=Xjijnn_9',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(people[index].picture),
                      ),
                      Column(
                        children: [
                          Text(people[index].name),
                          Text(people[index].role),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          itemCount: people.length,
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {},
          child: Text('+'),
        ),
      ),
    );
  }
}

class Worker {
  final String name;
  final String role;
  final String picture;

  Worker(this.name, this.role, this.picture);
}
