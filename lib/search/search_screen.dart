import 'package:anchorage/search/dialog/bottomsheetDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'hotel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Hotel> hotels = [
    Hotel(id: 5, name: 'Yash', city: 'Rajkot', image: 'https://cache.marriott.com/marriottassets/marriott/LASJW/lasjw-suite-0084-hor-clsc.jpg?interpolation=progressive-bilinear&', rating: 4.5, recommended: true, price: 25, timestamp: DateTime.parse('2024-05-14 17:13:44')),
    Hotel(id: 6, name: 'Test 1', city: 'Ahmedabad', image: 'https://th.bing.com/th/id/R.945e552b58c25f526ad089bc493d4516?rik=42BmhcZYWlYxGA&riu=http%3a%2f%2fcache.marriott.com%2fmarriottassets%2fmarriott%2fLASJW%2flasjw-guestroom-0111-hor-clsc.jpg%3finterpolation%3dprogressive-bilinear%26&ehk=VcnNojNooaxympMvDdeRVdz3JfYVtglQmJmdSktonXM%3d&risl=&pid=ImgRaw&r=0', rating: 3.0, recommended: false, price: 2, timestamp: DateTime.parse('2024-05-14 17:19:09')),
    Hotel(id: 7, name: 'Test 2', city: 'Surat', image: 'https://th.bing.com/th/id/R.fd7b996f2e00e3715d4211863b2fdabf?rik=XmXHS9BNUXwGWQ&riu=http%3a%2f%2fwww.bestwesternplusmeridian.com%2fContent%2fimages%2fQueen-Room-o.jpg&ehk=dxP298vmMaLYbbBQz9Ls4IOHAz40HDl8EWe4oVTZd%2f8%3d&risl=&pid=ImgRaw&r=0', rating: 3.0, recommended: false, price: 2, timestamp: DateTime.parse('2024-05-14 17:19:43')),
    Hotel(id: 8, name: 'Test 3', city: 'Vadodara', image: 'https://images.rosewoodhotels.com/is/image/rwhg/hi-hgv-26330925-rhgmodelbedroom-1', rating: 3.0, recommended: false, price: 2, timestamp: DateTime.parse('2024-05-14 17:21:15')),
    Hotel(id: 9, name: 'Test 4', city: 'Delhi', image: 'https://th.bing.com/th/id/R.25b86c23a77f0e94d5e909cc1b3bceff?rik=Djcc7WwfZAnIjA&riu=http%3a%2f%2fcache.marriott.com%2fmarriottassets%2fmarriott%2fSTFCT%2fstfct-guestroom-0045-hor-clsc.jpg%3finterpolation%3dprogressive-bilinear%26&ehk=Qfi1Qy2RPsgQGGJQ%2bDLh1pnflcQlURsqEc584MAYrZI%3d&risl=&pid=ImgRaw&r=0', rating: 3.0, recommended: false, price: 2, timestamp: DateTime.parse('2024-05-14 17:27:39')),
    Hotel(id: 10, name: 'Test', city: 'Mumbai', image: 'https://www.homestratosphere.com/wp-content/uploads/2014/05/shutterstock_30411274.jpg', rating: 4.2, recommended: true, price: 52, timestamp: DateTime.parse('2024-05-14 17:42:19')),
    Hotel(id: 11, name: 'Kale Logistics Hotel', city: 'Dubai', image: 'https://cdn.dubai-marina.com/media/internal_articles_image/3._Premier_Suite.jpg', rating: 4.8, recommended: true, price: 1000, timestamp: DateTime.parse('2024-05-14 18:08:40')),
    Hotel(id: 1002, name: 'Check new Hotel', city: 'Jamnagar', image: 'https://th.bing.com/th/id/R.2c5e79d5588223818c796a3a9110b668?rik=CrX17TCH4klKJQ&riu=http%3a%2f%2fthejetsettersguide.com%2fwp-content%2fuploads%2f2018%2f08%2f35050052_10156266317493467_2858362982449020928_o.jpg&ehk=yqknBZOq4RYpIwO9J1OdQlqfO1szWiAtU5%2fbEIfMulk%3d&risl=&pid=ImgRaw&r=0', rating: 3.9, recommended: true, price: 12, timestamp: DateTime.parse('2024-05-15 10:37:44')),
  ];


  String _selectedPriceRange = '';
  String _selectedSorting = '';


  List<Hotel> get filteredHotels {
    List<Hotel> filteredList = hotels;

    // Filtering based on selected price range
    if (_selectedPriceRange.isNotEmpty) {
      final priceRangeParts = _selectedPriceRange.split(' - ');
      final minPrice = double.parse(priceRangeParts[0]);
      final maxPrice = double.parse(priceRangeParts[1]);

      filteredList = filteredList.where((hotel) {
        return hotel.price >= minPrice && hotel.price <= maxPrice;
      }).toList();
    }

    // Sorting based on selected sorting option
    if (_selectedSorting == 'A to Z') {
      filteredList.sort((a, b) => a.name.compareTo(b.name));
    } else if (_selectedSorting == 'Z to A') {
      filteredList.sort((a, b) => b.name.compareTo(a.name));
    }

    return filteredList;
  }


  void _showPriceRangeDialog() async {
    final Map<String, String?> selectedOptions = await UiHelper.showPriceRangeDialog(context);
    if (selectedOptions.isNotEmpty) {
      setState(() {
        _selectedPriceRange = selectedOptions['priceRange'] ?? '';
        _selectedSorting = selectedOptions['sorting'] ?? '';
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showPriceRangeDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Selected Price Range: $_selectedPriceRange === $_selectedSorting',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = filteredHotels[index];
                return ListTile(
                  leading: Image.network(hotel.image, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(hotel.name),
                  subtitle: Text('${hotel.city} - \$${hotel.price}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
