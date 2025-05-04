import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(HousePricePredictorApp());

class HousePricePredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'House Price Predictor', home: HousePriceForm());
  }
}

class HousePriceForm extends StatefulWidget {
  @override
  _HousePriceFormState createState() => _HousePriceFormState();
}

class _HousePriceFormState extends State<HousePriceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController sqftController = TextEditingController();
  final TextEditingController bedroomsController = TextEditingController();
  final TextEditingController bathroomsController = TextEditingController();

  String buildingType = 'Residential';
  bool hasParking = false;

  String? predictionResult;

  Future<void> predictPrice() async {
    final String apiUrl = "http://YOUR_BACKEND_URL/predict";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "location": locationController.text,
        "square_feet": double.tryParse(sqftController.text) ?? 0,
        "bedrooms": int.tryParse(bedroomsController.text) ?? 0,
        "bathrooms": int.tryParse(bathroomsController.text) ?? 0,
        "building_type": buildingType,
        "parking": hasParking ? 1 : 0,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        predictionResult =
            "Predicted Price: ₹${result['price'].toStringAsFixed(2)}";
      });
    } else {
      setState(() {
        predictionResult = "Error predicting price.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("House Price Predictor")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: "Area (Location)"),
              ),
              TextFormField(
                controller: sqftController,
                decoration: InputDecoration(labelText: "Square Feet"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: bedroomsController,
                decoration: InputDecoration(labelText: "Number of Bedrooms"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: bathroomsController,
                decoration: InputDecoration(labelText: "Number of Bathrooms"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: buildingType,
                items:
                    ['Residential', 'Commercial']
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    buildingType = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Building Type"),
              ),
              SwitchListTile(
                title: Text("Parking Available"),
                value: hasParking,
                onChanged: (value) {
                  setState(() {
                    hasParking = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: predictPrice,
                child: Text("Predict Price"),
              ),
              SizedBox(height: 20),
              Text(
                predictionResult ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
