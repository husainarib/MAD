import 'package:flutter/material.dart';
import 'detailScreen.dart';

//home screen class
class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> recipes = [
    {
      'name': 'Chicken Tikka Masala',
      'detail':
          'ingredients: chicken, yogurt, garlic, ginger, garam masala \n\nInstructions: Marinate chicken with yogurt, garlic, ginger, and spices. Cook marinated chicken. Sauté onions, garlic, and ginger. Add tomatoes and spices to make sauce. Combine chicken with sauce and simmer.'
    },
    {
      'name': 'Butter Chicken',
      'detail':
          'Ingredients: chicken, butter, garlic, ginger, tomato puree, cream\n\nInstructions:Marinate chicken with garlic, ginger, and spices. Cook marinated chicken in butter. Sauté garlic and ginger. Add tomato puree and spices to make sauce. Add cream and simmer with chicken.'
    },
    {
      'name': 'Beef Curry',
      'detail':
          'Ingredients: beef, onions, garlic, ginger, curry powder, tomatoes\n\nInstructions: Sauté onions, garlic, and ginger. Add beef and brown. Stir in curry powder and tomatoes. Simmer until beef is tender.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Favorite Recipes'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Recipe List',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                width: 300,
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 30.0),
                        title: Text(recipes[index]['name']!,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center),
                        tileColor: const Color.fromARGB(255, 193, 248, 160),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                name: recipes[index]['name']!,
                                detail: recipes[index]['detail']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
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
