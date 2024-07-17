import 'package:anchorage/sql_data/model/airline/airline_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/dimensions.dart';
import '../../core/style.dart';
import '../../search/dialog/bottomsheetDialog.dart';
import '../../sql_data/repository/airline_repository.dart';


class AirlineSearchWithLoad extends StatefulWidget {
  String agentName;
  String airline_f_location;
  String airline_d_location;
  String airline_kg_ton;
  double airline_capacity;
  String airline_from_date;

  AirlineSearchWithLoad({super.key, required this.agentName, required this.airline_f_location, required this.airline_d_location, required this.airline_kg_ton, required this.airline_capacity, required this.airline_from_date});

  @override
  State<AirlineSearchWithLoad> createState() => _AirlineSearchWithLoadState();
}

class _AirlineSearchWithLoadState extends State<AirlineSearchWithLoad> {

  AirlineRepository airlineRepository = AirlineRepository();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool gridView = false;
  String _selectedPriceRange = '';
  String _selectedSorting = '';
  String selectedCategory = "All";

  void onSearchTextChanged(String text) {
    setState(() {
      searchQuery = text.toLowerCase();
    });
  }
  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
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
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15),
          child: Column(
            children: [

              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    Icon(Icons.search, color: Colors.black45),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          onChanged: onSearchTextChanged,
                          cursorColor: Colors.black,
                          style: GoogleFonts.poppins(textStyle :TextStyle(color: Colors.black87)),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: GoogleFonts.poppins(textStyle :TextStyle(color: Colors.black45)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune, color: Colors.black45),
                      onPressed: _showPriceRangeDialog,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCategoryButton("All"),
                    SizedBox(width: 10),
                    buildCategoryButton("Recommended"),
                    SizedBox(width: 10),
                    buildCategoryButton("Popular"),
                    SizedBox(width: 10),
                    buildCategoryButton("Near By"),
                    // Add more buttons as needed
                  ],
                ),
              ),
              SizedBox(height: Dimensions.space15,),
              Divider(color: Colors.blue.shade50,height: 0.5,),
              Expanded(
                child: StreamBuilder<List<AirLineListModel>>(
                  stream: airlineRepository.searchAirlineListDataStream(widget.airline_f_location, widget.airline_d_location, widget.airline_kg_ton, widget.airline_capacity, widget.airline_from_date),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: Colors.tealAccent,));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<AirLineListModel> dataList = snapshot.data ?? [];
                      //dataList.sort((a, b) => b.bTimestamp.compareTo(a.bTimestamp));
                      /*if (selectedCategory == "Recommended") {
                        dataList = dataList.where((item) => item.bRecommended).toList();
                        dataList.sort((a, b) => b.bTimestamp.compareTo(a.bTimestamp));
                      } else if (selectedCategory == "Popular") {
                        dataList = dataList.where((item) => item.bRating > 4).toList();
                        dataList.sort((a, b) => b.bRating.compareTo(a.bRating));
                      }else{
                        dataList.sort((a, b) => b.bTimestamp.compareTo(a.bTimestamp));
                      }*/

                      dataList = filterDataList(dataList);


                      return Column(
                        children: [
                          SizedBox(height: Dimensions.space5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Recommended ( ${dataList.length} )", style: GoogleFonts.poppins(
                    textStyle:boldExtraLarge.copyWith(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400)),),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      gridView = !gridView;
                                    });
                                  },
                                  icon: Icon(
                                    gridView == false
                                        ? Icons.grid_view
                                        : Icons.format_list_bulleted,
                                    color: Colors.black54,
                                  ))
                            ],
                          ),
                          SizedBox(height: Dimensions.space10,),
                          (gridView == false)
                              ? buildBookingListView(dataList)
                              : buildBookingGridView(dataList)
                        ],
                      );


                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget buildCategoryButton(String category) {
    bool isSelected = selectedCategory == category;
    return OutlinedButton(
      onPressed: () => onCategorySelected(category),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.grey.shade300 : Colors.transparent,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        category,
        style: GoogleFonts.poppins(
    textStyle:TextStyle(
          color: isSelected ? Colors.black : Colors.black45,
        )),
      ),
    );
  }

  List<AirLineListModel> filterDataList(List<AirLineListModel> dataList) {
    List<AirLineListModel> filteredList = dataList;
    filteredList.sort((a, b) => b.airlineFromDate.compareTo(a.airlineFromDate));

    if (selectedCategory == "Recommended") {
      filteredList = filteredList.where((item) => item.airlineRecommended).toList();
    } else if (selectedCategory == "Popular") {
      filteredList = filteredList.where((item) => item.airlineRating > 4).toList();
      filteredList.sort((a, b) => b.airlineRating.compareTo(a.airlineRating));
    }

    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) =>
      item.airlineName.toLowerCase().contains(searchQuery)
      ).toList();
    }

    // Filtering based on selected price range
    if (_selectedPriceRange.isNotEmpty) {
      final priceRangeParts = _selectedPriceRange.split(' - ');
      final minPrice = double.parse(priceRangeParts[0]);
      final maxPrice = double.parse(priceRangeParts[1]);
      dataList = dataList.where((hotel) {
        final hotelPrice = double.parse(hotel.airlineCapacityPrice);
        return hotelPrice >= minPrice && hotelPrice <= maxPrice;
      }).toList();
    }

    // Sorting based on selected sorting option
    if (_selectedSorting == 'A to Z') {
      dataList.sort((a, b) => a.airlineName.compareTo(b.airlineName));
    } else if (_selectedSorting == 'Z to A') {
      dataList.sort((a, b) => b.airlineName.compareTo(a.airlineName));
    }

    /* filteredList.sort((a, b) => b.bTimestamp.compareTo(a.bTimestamp));*/
    return filteredList;
  }

  Widget buildBookingListView(List<AirLineListModel> dataList) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
        itemCount: dataList.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          AirLineListModel airLineListModel = dataList[index];

          return GestureDetector(
            onTap: () {
              //Navigator.push(context, CupertinoPageRoute(builder: (context) => BookingDetailPage(datalist: dataList, curruntIndex: index),));
            },
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${airLineListModel.airlineFromDate} to ${airLineListModel.airlineToDate}", style: GoogleFonts.poppins(
                          textStyle:TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w300)),),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.space16),
                                    child: Image.network(
                                      height: 70,
                                      width: 80,
                                      airLineListModel.airlineImage,
                                      fit: BoxFit.cover,
                                    ),),
                        
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          airLineListModel.airlineName,
                                          style: GoogleFonts.poppins(
                                            textStyle:boldOverLarge.copyWith(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
                                        ),
                                        SizedBox(height: 15,),
                        
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("${airLineListModel.airlineFLocation}", style: GoogleFonts.poppins(
                                              textStyle:mediumMediumLarge.copyWith(
                                                color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w300)),),
                                            SizedBox(width: 10,),
                                            Container(height: 1, width: 30,color: Colors.black45,),
                                            SizedBox(width: 10,),
                                            Text("${airLineListModel.airlineDLocation}", style: GoogleFonts.poppins(
                                              textStyle:mediumMediumLarge.copyWith(
                                                color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w300)),),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                        
                        
                        
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Text(airLineListModel.airlineDaySelection.map((day) => day.substring(0, 2)).join(', '), style: GoogleFonts.poppins(
                              textStyle:TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w300)),),
                        
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${airLineListModel.airlineCapacityPrice}",
                            style: GoogleFonts.poppins(
          textStyle:boldOverLarge.copyWith(
                                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400))  ,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text("/ ${airLineListModel.airlineKgTon}",
                              style: GoogleFonts.poppins(
          textStyle:regularDefault.copyWith(
                                  color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w300))),
                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text("Book", style: GoogleFonts.poppins(
          textStyle:TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12)),),
                          )

                          /*Icon(
                                (bookingModel.airlineRecommended == true) ? Icons.bookmark_outlined : Icons.bookmark_border_rounded,
                                color: Colors.black,
                                size: 24,
                              )*/
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                Divider(color: Colors.black12, height: 0.3,),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildBookingGridView(List<AirLineListModel> dataList) {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: dataList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: Dimensions.space280,
            mainAxisSpacing: Dimensions.space24,
            crossAxisSpacing: Dimensions.space24),
        itemBuilder: (context, index) {
          AirLineListModel airLineListModel = dataList[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.space18),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.space16),
                    child: Image.network(
                      airLineListModel.airlineImage,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  height: Dimensions.space18,
                ),
                Text(
                  airLineListModel.airlineName,
                  style: GoogleFonts.poppins(
          textStyle:boldOverLarge.copyWith(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
                ),

                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${airLineListModel.airlineFLocation}", style: GoogleFonts.poppins(
          textStyle:mediumMediumLarge.copyWith(
                        color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w300)),),
                    SizedBox(width: 10,),
                    Container(height: 1, width: 30,color: Colors.black45,),
                    SizedBox(width: 10,),
                    Text("${airLineListModel.airlineDLocation}", style: GoogleFonts.poppins(
          textStyle:mediumMediumLarge.copyWith(
                        color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w300)),),
                  ],
                ),


                SizedBox(height: 10,),



                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "\$${airLineListModel.airlineCapacityPrice}",
                          style: GoogleFonts.poppins(
          textStyle:boldOverLarge.copyWith(
                              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("/ ${airLineListModel.airlineKgTon}",
                            style: GoogleFonts.poppins(
          textStyle:regularDefault.copyWith(
                                color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w300))),
                      ],
                    ),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.navigate_next_rounded, color: Colors.white,),
                    )
                    /*Row(
                      children: [
                        Text(
                          "\$${bookingModel.airlineCapacityPrice}",
                          style: boldOverLarge.copyWith(
                              color: Colors.tealAccent.withOpacity(0.8)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0, top: 10),
                          child: Text("/night",
                              style: regularDefault.copyWith(
                                  color: Colors.white24, fontSize: 12)),
                        ),
                      ],
                    ),


                    Icon(
                      Icons.bookmark_outlined,
                      color: Colors.tealAccent.withOpacity(0.8),
                      size: 24,
                    )*/
                  ],
                ),
                SizedBox(height: 10,),
                Text(airLineListModel.airlineDaySelection.map((day) => day.substring(0, 2)).join(', '), style: GoogleFonts.poppins(
          textStyle:TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w300)),),

              ],
            ),
          );
        },),
    );
  }


}
