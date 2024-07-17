import 'package:flutter/material.dart';

class UiHelper {
  static String selectedPriceRange = '';
  static String selectedSorting = '';

  static List<String> priceRanges = [
    '0 - 5',
    '5 - 10',
    '10 - 15',
    '15 - 50',
  ];

  static List<String> sortingOptions = [
    'A to Z',
    'Z to A',
  ];

  static void selectPriceRange(BuildContext context, String priceRange) {
    selectedPriceRange = priceRange;
  }

  static void selectSorting(BuildContext context, String sorting) {
    selectedSorting = sorting;
  }

  static Future<Map<String, String?>> showPriceRangeDialog(BuildContext context) async {
    String? selectedPriceRange;
    String? selectedSorting;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Price Range',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: priceRanges.map((priceRange) {
                      return ChoiceChip(
                        label: Text(priceRange),
                        selected: UiHelper.selectedPriceRange == priceRange,
                        onSelected: (bool selected) {
                          setState(() {
                            UiHelper.selectedPriceRange = selected ? priceRange : '';
                          });
                          selectPriceRange(context, selected ? priceRange : '');
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sort',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: sortingOptions.map((sorting) {
                      return ChoiceChip(
                        label: Text(sorting),
                        selected: UiHelper.selectedSorting == sorting,
                        onSelected: (bool selected) {
                          setState(() {
                            UiHelper.selectedSorting = selected ? sorting : '';
                          });
                          selectSorting(context, selected ? sorting : '');
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      selectedPriceRange = UiHelper.selectedPriceRange;
                      selectedSorting = UiHelper.selectedSorting;
                      Navigator.pop(context, {
                        'priceRange': selectedPriceRange,
                        'sorting': selectedSorting,
                      });
                    },
                    child: Text("Filter"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    return {'priceRange': selectedPriceRange, 'sorting': selectedSorting};
  }
}
