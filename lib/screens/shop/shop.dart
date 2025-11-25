// import 'package:fanexp/constants/functions.dart';
// import 'package:fanexp/constants/size.dart';
// import 'package:fanexp/services/shop/product.service.dart';
// import 'package:flutter/material.dart';
// import 'package:fanexp/theme/gainde_theme.dart';
// import 'package:fanexp/widgets/glasscard.dart';
// import 'package:fanexp/widgets/buttons.dart';
// import 'package:fade_shimmer/fade_shimmer.dart';

// class Shop extends StatefulWidget {
//   const Shop({super.key});
//   @override
//   State<Shop> createState() => _ShopState();
// }

// class _ShopState extends State<Shop> {
//   static const int kFcfaPerPoint = 100;
//   int userPoints = 1480;
//   late Future? publishedProducts;
//   ProductService productService = ProductService();

//   String query = '';
//   String activeFilter = 'Tous';
//   final filters = const [
//     'Tous',
//     'Maillots',
//     'Accessoires',
//     'Enfant',
//     'Collectors',
//   ];

//   int _pointsForPrice(int fcfa) => (fcfa / kFcfaPerPoint).ceil();
//   bool _canBuyWithPoints(int priceFcfa) =>
//       userPoints >= _pointsForPrice(priceFcfa);

//   final items = <_Product>[
//     _Product(
//       title: 'Maillot 24/25 Domicile',
//       image: 'assets/img/maillot.webp',
//       price: 59000,
//       oldPrice: 69000,
//       rating: 4.7,
//       badge: 'Nouveau',
//       type: 'Maillots',
//     ),
//     _Product(
//       title: 'Écharpe Gaïndé',
//       image: 'assets/img/echarpe.jpg',
//       price: 12000,
//       rating: 4.6,
//       type: 'Accessoires',
//     ),
//     _Product(
//       title: 'Short Officiel',
//       image: 'assets/img/short.png',
//       price: 25000,
//       rating: 4.4,
//       type: 'Maillots',
//     ),
//     _Product(
//       title: 'Casquette Lions',
//       image: 'assets/img/cap.png',
//       price: 15000,
//       oldPrice: 18000,
//       rating: 4.2,
//       type: 'Accessoires',
//       badge: '-15%',
//     ),
//     _Product(
//       title: 'Mini-kit Enfant',
//       image: 'assets/img/minikit.png',
//       price: 39000,
//       rating: 4.8,
//       type: 'Enfant',
//     ),
//     _Product(
//       title: 'Poster Collector Signé',
//       image: 'assets/img/poster.png',
//       price: 22000,
//       rating: 4.9,
//       type: 'Collectors',
//     ),
//     _Product(
//       title: 'Sac de sport FFS',
//       image: 'assets/img/bag.png',
//       price: 28000,
//       rating: 4.5,
//       type: 'Accessoires',
//     ),
//     _Product(
//       title: 'Maillot Extérieur 24/25',
//       image: 'assets/img/maillot_ext.png',
//       price: 59000,
//       rating: 4.6,
//       type: 'Maillots',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     publishedProducts = productService.getProducts();
//     // _scrollController.addListener(() {
//     //   // scroll direction check
//     //   if (_scrollController.position.userScrollDirection ==
//     //       ScrollDirection.forward) {
//     //     // scrolling up, search bar appears
//     //     if (!_isSearchBarVisible) {
//     //       setState(() {
//     //         _isSearchBarVisible = true;
//     //       });
//     //     }
//     //   } else if (_scrollController.position.userScrollDirection ==
//     //       ScrollDirection.reverse) {
//     //     // scrolling down, hide the search bar
//     //     if (_isSearchBarVisible) {
//     //       setState(() {
//     //         _isSearchBarVisible = false;
//     //       });
//     //     }
//     //   }
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     final filtered = items.where((p) {
//       final okFilter = activeFilter == 'Tous' || p.type == activeFilter;
//       final okQuery =
//           query.trim().isEmpty ||
//           p.title.toLowerCase().contains(query.trim().toLowerCase());
//       return okFilter && okQuery;
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Boutique'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: gaindeGreenSoft,
//                   borderRadius: BorderRadius.circular(999),
//                   border: Border.all(color: gaindeGreen.withOpacity(.25)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.loyalty_rounded,
//                       size: 16,
//                       color: gaindeGreen,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       '${_fmtPoints(userPoints)} pts',
//                       style: const TextStyle(fontWeight: FontWeight.w800),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             tooltip: 'Panier',
//             icon: const Icon(Icons.shopping_cart_outlined),
//           ),
//         ],
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _SearchField(
//                       hint: 'Rechercher un produit…',
//                       onChanged: (v) => setState(() => query = v),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Tooltip(
//                     message: 'Trier',
//                     child: _SoftIconButton(
//                       icon: Icons.tune_rounded,
//                       onTap: () => _snack(context, 'Tri (à implémenter)'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 46,
//               child: ListView.separated(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (_, i) {
//                   final f = filters[i];
//                   final selected = f == activeFilter;
//                   return ChoiceChip(
//                     label: Text(f),
//                     selected: selected,
//                     onSelected: (_) => setState(() => activeFilter = f),
//                     selectedColor: gaindeGreenSoft,
//                     side: BorderSide(
//                       color: selected
//                           ? gaindeGreen.withOpacity(.4)
//                           : gaindeInk.withOpacity(.12),
//                     ),
//                     labelStyle: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       color: selected ? gaindeGreen : gaindeInk,
//                     ),
//                   );
//                 },
//                 separatorBuilder: (_, __) => const SizedBox(width: 8),
//                 itemCount: filters.length,
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//             sliver: SliverLayoutBuilder(
//               builder: (context, constraints) {
//                 final w = constraints.crossAxisExtent;
//                 const target = 180.0;
//                 int cols = (w / target).floor().clamp(2, 4);
//                 if (w > 950) cols = 5;

//                 return SliverGrid(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: cols,
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     childAspectRatio: .55,
//                   ),
//                   delegate: SliverChildBuilderDelegate((context, i) {
//                     final p = filtered[i];
//                     final pts = _pointsForPrice(p.price);
//                     final canBuy = _canBuyWithPoints(p.price);
//                     return _ProductCard(
//                       product: p,
//                       points: pts,
//                       canBuyWithPoints: canBuy,
//                       onBuyPoints: () {
//                         if (!canBuy) {
//                           _snack(
//                             context,
//                             'Points insuffisants (${_fmtPoints(userPoints)} pts)',
//                           );
//                           return;
//                         }
//                         setState(() => userPoints -= pts);
//                         _snack(context, 'Achat en points réussi (-$pts pts)');
//                       },
//                       onBuyCash: () => _snack(context, 'Ajouté au panier'),
//                     );
//                   }, childCount: filtered.length),
//                 );
//               },
//             ),
//           ),
//           // FutureBuilder(
//           //   future: publishedProducts,
//           //   builder: (context, snapshot) {
//           //     if (snapshot.hasData) {
//           //       dynamic products = snapshot.data;
//           //       if (products.isEmpty || products == null) {
//           //         return const Center(
//           //           child: Column(
//           //             children: [
//           //               Icon(Icons.list, size: 100, color: Colors.grey),
//           //               Text("Aucun produit disponible"),
//           //             ],
//           //           ),
//           //         );
//           //       }
//           //       if (products.isEmpty || products == null) {
//           //         return const Center(
//           //           child: Column(
//           //             children: [
//           //               Icon(Icons.list, size: 100, color: Colors.grey),
//           //               Text("Aucun post disponible"),
//           //             ],
//           //           ),
//           //         );
//           //       }
//           //       List<Widget> productsWidgets = [];
//           //       for (int index = 0; index < products.length; index++) {
//           //         productsWidgets.add(
//           //           Container(
//           //             // color: k_softGreen,
//           //             child: Stack(
//           //               children: [
//           //                 Column(
//           //                   children: [
//           //                     const SizedBox(height: 20),
//           //                     Container(
//           //                       padding: const EdgeInsets.only(
//           //                         left: 30,
//           //                         right: 30,
//           //                       ),
//           //                       child: Row(
//           //                         children: [
//           //                           const CircleAvatar(
//           //                             backgroundColor: Colors.white,
//           //                             child: Icon(
//           //                               Icons.person,
//           //                               color: Colors.black,
//           //                             ),
//           //                           ),
//           //                           Column(
//           //                             crossAxisAlignment:
//           //                                 CrossAxisAlignment.start,
//           //                             children: [
//           //                               Row(
//           //                                 children: [
//           //                                   Container(
//           //                                     padding: const EdgeInsets.only(
//           //                                       left: 10,
//           //                                     ),
//           //                                     child: Text(
//           //                                       products[index]['userId']['firstName'] +
//           //                                           ' ' +
//           //                                           products[index]['userId']['lastName']
//           //                                               .toString(),
//           //                                       style: const TextStyle(
//           //                                         fontFamily: 'Josefin Sans',
//           //                                         fontSize: 14,
//           //                                         fontWeight: FontWeight.normal,
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                 ],
//           //                               ),
//           //                               const SizedBox(height: 5),
//           //                               Row(
//           //                                 children: [
//           //                                   Container(
//           //                                     padding: const EdgeInsets.only(
//           //                                       left: 10,
//           //                                     ),
//           //                                     child: Text(
//           //                                       "${formatDate(products[index]['created_at'].toString())} à ${getFormatedDateTime(products[index]['created_at'].toString())}",
//           //                                       style: const TextStyle(
//           //                                         fontFamily: 'Josefin Sans',
//           //                                         fontSize: 12,
//           //                                         fontWeight: FontWeight.normal,
//           //                                         // color:
//           //                                         //     k_darkGreen
//           //                                       ),
//           //                                     ),
//           //                                   ),
//           //                                 ],
//           //                               ),
//           //                             ],
//           //                           ),
//           //                         ],
//           //                       ),
//           //                     ),
//           //                     const SizedBox(height: 10),
//           //                     // _buildDivider(k_lightGrey),
//           //                     const SizedBox(height: 10),
//           //                     Container(
//           //                       padding: const EdgeInsets.only(
//           //                         left: 30,
//           //                         right: 30,
//           //                       ),
//           //                       child: SizedBox(
//           //                         width: mediaWidth(context) * 0.85,
//           //                         child: Text(
//           //                           products[index]['description'],
//           //                           textAlign: TextAlign.start,
//           //                           softWrap: true,
//           //                           style: const TextStyle(
//           //                             fontFamily: 'Josefin Sans',
//           //                             fontSize: 12,
//           //                             fontWeight: FontWeight.normal,
//           //                           ),
//           //                         ),
//           //                       ),
//           //                     ),
//           //                     const SizedBox(height: 10),
//           //                     GestureDetector(
//           //                       // onTap: () {
//           //                       //   Navigator.push(
//           //                       //     context,
//           //                       //     MaterialPageRoute(
//           //                       //       builder: (context) =>
//           //                       //           FullScreenPost(
//           //                       //         post: Image.network(
//           //                       //           posts[index]['mediaPost']
//           //                       //               .toString(),
//           //                       //           fit: BoxFit.contain,
//           //                       //         ),
//           //                       //       ),
//           //                       //     ),
//           //                       //   );
//           //                       // },
//           //                       child: Container(
//           //                         height: mediaHeight(context) * 0.31,
//           //                         width: mediaWidth(context) * 0.85,
//           //                         child:
//           //                             (products[index]['postMediaType'] ==
//           //                                 "IMAGE")
//           //                             ? Image.network(
//           //                                 products[index]['mediaPost']
//           //                                     .toString(),
//           //                               )
//           //                             : (products[index]['postMediaType'] ==
//           //                                   "VIDEO")
//           //                             ? InkWell(
//           //                                 onTap: () {},
//           //                                 child: Stack(
//           //                                   children: [
//           //                                     // Container(
//           //                                     //   color: Colors
//           //                                     //       .white,
//           //                                     //   child:
//           //                                     //       VideoPlayerScreen(
//           //                                     //     videoUrl: posts[
//           //                                     //             index]
//           //                                     //         [
//           //                                     //         'mediaPost'],
//           //                                     //   ),
//           //                                     // )
//           //                                   ],
//           //                                 ),
//           //                               )
//           //                             : Container(),
//           //                       ),
//           //                     ),
//           //                     const SizedBox(height: 10),
//           //                   ],
//           //                 ),
//           //                 Container(
//           //                   margin: EdgeInsets.only(
//           //                     top: mediaHeight(context) * 0.5,
//           //                   ),
//           //                   color: Colors.white,
//           //                   height: mediaHeight(context) * 0.04,
//           //                 ),
//           //               ],
//           //             ),
//           //           ),
//           //         );
//           //       }

//           //       return Column(children: productsWidgets);
//           //     } else {
//           //       return NotificationListener<OverscrollIndicatorNotification>(
//           //         onNotification: (notification) {
//           //           notification.disallowIndicator();
//           //           return true;
//           //         },
//           //         child: Container(
//           //           width: mediaWidth(context) * 0.85,
//           //           height: mediaHeight(context) * 0.9,
//           //           decoration: const BoxDecoration(
//           //             // color: k_softGreen,
//           //             borderRadius: BorderRadius.only(
//           //               topRight: Radius.circular(5),
//           //               topLeft: Radius.circular(5),
//           //             ),
//           //           ),
//           //           child: Stack(
//           //             children: [
//           //               Column(
//           //                 children: [
//           //                   Container(
//           //                     height: mediaHeight(context) * 0.6,
//           //                     child: ListView.builder(
//           //                       itemCount: 5,
//           //                       itemBuilder: (context, index) {
//           //                         return Column(
//           //                           crossAxisAlignment:
//           //                               CrossAxisAlignment.start,
//           //                           children: [
//           //                             Container(
//           //                               margin: const EdgeInsets.only(top: 30),
//           //                               child: Row(
//           //                                 children: [
//           //                                   const CircleAvatar(
//           //                                     backgroundColor: Colors.white,
//           //                                     radius: 20,
//           //                                     child: FadeShimmer(
//           //                                       height: 20,
//           //                                       width: 30,
//           //                                       radius: 5,
//           //                                       highlightColor: Color.fromARGB(
//           //                                         255,
//           //                                         208,
//           //                                         240,
//           //                                         227,
//           //                                       ),
//           //                                       baseColor: Color.fromARGB(
//           //                                         255,
//           //                                         175,
//           //                                         172,
//           //                                         172,
//           //                                       ),
//           //                                       fadeTheme: FadeTheme.light,
//           //                                       millisecondsDelay: 1,
//           //                                     ),
//           //                                   ),
//           //                                   Column(
//           //                                     crossAxisAlignment:
//           //                                         CrossAxisAlignment.start,
//           //                                     children: [
//           //                                       Container(
//           //                                         width:
//           //                                             mediaHeight(context) *
//           //                                             0.15,
//           //                                         padding:
//           //                                             const EdgeInsets.only(
//           //                                               left: 10,
//           //                                             ),
//           //                                         child: const FadeShimmer(
//           //                                           height: 20,
//           //                                           width: 30,
//           //                                           radius: 5,
//           //                                           highlightColor:
//           //                                               Color.fromARGB(
//           //                                                 255,
//           //                                                 208,
//           //                                                 240,
//           //                                                 227,
//           //                                               ),
//           //                                           baseColor: Color.fromARGB(
//           //                                             255,
//           //                                             175,
//           //                                             172,
//           //                                             172,
//           //                                           ),
//           //                                           fadeTheme: FadeTheme.light,
//           //                                           millisecondsDelay: 1,
//           //                                         ),
//           //                                       ),
//           //                                       const SizedBox(height: 5),
//           //                                       Container(
//           //                                         height: 20,
//           //                                         width:
//           //                                             mediaWidth(context) *
//           //                                             0.15,
//           //                                         padding:
//           //                                             const EdgeInsets.only(
//           //                                               left: 10,
//           //                                             ),
//           //                                         child: const FadeShimmer(
//           //                                           height: 20,
//           //                                           width: 30,
//           //                                           radius: 5,
//           //                                           highlightColor:
//           //                                               Color.fromARGB(
//           //                                                 255,
//           //                                                 208,
//           //                                                 240,
//           //                                                 227,
//           //                                               ),
//           //                                           baseColor: Color.fromARGB(
//           //                                             255,
//           //                                             175,
//           //                                             172,
//           //                                             172,
//           //                                           ),
//           //                                           fadeTheme: FadeTheme.light,
//           //                                           millisecondsDelay: 1,
//           //                                         ),
//           //                                       ),
//           //                                     ],
//           //                                   ),
//           //                                 ],
//           //                               ),
//           //                             ),
//           //                             const SizedBox(height: 10),
//           //                             // _buildDivider(k_lightGrey),
//           //                             const SizedBox(height: 10),
//           //                             Container(
//           //                               // padding:
//           //                               //     const EdgeInsets.only(
//           //                               //   left: 30,
//           //                               //   right: 30,
//           //                               // ),
//           //                               width: mediaHeight(context) * 0.35,
//           //                               child: const FadeShimmer(
//           //                                 height: 20,
//           //                                 width: 30,
//           //                                 radius: 5,
//           //                                 highlightColor: Color.fromARGB(
//           //                                   255,
//           //                                   208,
//           //                                   240,
//           //                                   227,
//           //                                 ),
//           //                                 baseColor: Color.fromARGB(
//           //                                   255,
//           //                                   175,
//           //                                   172,
//           //                                   172,
//           //                                 ),
//           //                                 fadeTheme: FadeTheme.light,
//           //                                 millisecondsDelay: 1,
//           //                               ),
//           //                             ),
//           //                             const SizedBox(height: 10),
//           //                             const SizedBox(height: 10),
//           //                             Container(
//           //                               height: mediaHeight(context) * 0.31,
//           //                               width: mediaWidth(context) * 0.85,
//           //                               child: FadeShimmer(
//           //                                 height: mediaHeight(context) * 0.35,
//           //                                 width: 30,
//           //                                 radius: 5,
//           //                                 highlightColor: Color.fromARGB(
//           //                                   255,
//           //                                   208,
//           //                                   240,
//           //                                   227,
//           //                                 ),
//           //                                 baseColor: const Color.fromARGB(
//           //                                   255,
//           //                                   175,
//           //                                   172,
//           //                                   172,
//           //                                 ),
//           //                                 fadeTheme: FadeTheme.light,
//           //                                 millisecondsDelay: 1,
//           //                               ),
//           //                             ),
//           //                             const SizedBox(height: 10),
//           //                             Container(
//           //                               child: Row(
//           //                                 children: [
//           //                                   Container(
//           //                                     height: 30,
//           //                                     width: mediaWidth(context) * 0.4,
//           //                                     decoration: BoxDecoration(
//           //                                       color: Colors.white,
//           //                                       borderRadius:
//           //                                           BorderRadius.circular(5),
//           //                                     ),
//           //                                     child: FadeShimmer(
//           //                                       height:
//           //                                           mediaHeight(context) * 0.35,
//           //                                       width: 30,
//           //                                       radius: 5,
//           //                                       highlightColor: Color.fromARGB(
//           //                                         255,
//           //                                         208,
//           //                                         240,
//           //                                         227,
//           //                                       ),
//           //                                       baseColor: const Color.fromARGB(
//           //                                         255,
//           //                                         175,
//           //                                         172,
//           //                                         172,
//           //                                       ),
//           //                                       fadeTheme: FadeTheme.light,
//           //                                       millisecondsDelay: 1,
//           //                                     ),
//           //                                   ),
//           //                                   const SizedBox(width: 15),
//           //                                   Container(
//           //                                     height: 30,
//           //                                     width: mediaWidth(context) * 0.4,
//           //                                     decoration: BoxDecoration(
//           //                                       color: Colors.white,
//           //                                       borderRadius:
//           //                                           BorderRadius.circular(5),
//           //                                     ),
//           //                                     child: FadeShimmer(
//           //                                       height:
//           //                                           mediaHeight(context) * 0.35,
//           //                                       width: 30,
//           //                                       radius: 5,
//           //                                       highlightColor: Color.fromARGB(
//           //                                         255,
//           //                                         208,
//           //                                         240,
//           //                                         227,
//           //                                       ),
//           //                                       baseColor: const Color.fromARGB(
//           //                                         255,
//           //                                         175,
//           //                                         172,
//           //                                         172,
//           //                                       ),
//           //                                       fadeTheme: FadeTheme.light,
//           //                                       millisecondsDelay: 1,
//           //                                     ),
//           //                                   ),
//           //                                 ],
//           //                               ),
//           //                             ),
//           //                           ],
//           //                         );
//           //                       },
//           //                     ),
//           //                   ),
//           //                 ],
//           //               ),
//           //               Container(
//           //                 margin: EdgeInsets.only(
//           //                   top: mediaHeight(context) * 0.5,
//           //                 ),
//           //                 color: Colors.white,
//           //                 height: mediaHeight(context) * 0.04,
//           //               ),
//           //             ],
//           //           ),
//           //         ),
//           //       );
//           //     }
//           //   },
//           // ),
//         ],
//       ),
//       // bottomNavigationBar: _PromoStrip(
//       //   text: 'Livraison OFFERTE dès 50.000 FCFA • Retours sous 30 jours',
//       //   icon: Icons.local_shipping_outlined,
//       //   color: cs.primary,
//       // ),
//     );
//   }
// }

// class _ProductCard extends StatelessWidget {
//   final _Product product;
//   final int points;
//   final bool canBuyWithPoints;
//   final VoidCallback onBuyPoints;
//   final VoidCallback onBuyCash;

//   const _ProductCard({
//     required this.product,
//     required this.points,
//     required this.canBuyWithPoints,
//     required this.onBuyPoints,
//     required this.onBuyCash,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;

//     return GestureDetector(
//       onTap: () => _snack(context, 'Ouvrir ${product.title}'),
//       child: GlassCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 1,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Container(
//                       color: gaindeGoldSoft,
//                       child: (product.image != null)
//                           ? Image.asset(
//                               product.image!,
//                               fit: BoxFit.contain,
//                               errorBuilder: (_, __, ___) => const Center(
//                                 child: Icon(
//                                   Icons.shopping_bag_outlined,
//                                   size: 44,
//                                   color: gaindeGold,
//                                 ),
//                               ),
//                             )
//                           : const Center(
//                               child: Icon(
//                                 Icons.shopping_bag_outlined,
//                                 size: 44,
//                                 color: gaindeGold,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//                 if (product.badge != null)
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: gaindeRed,
//                         borderRadius: BorderRadius.circular(999),
//                       ),
//                       child: Text(
//                         product.badge!,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 8),

//             Text(
//               product.title,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontWeight: FontWeight.w800),
//             ),
//             const SizedBox(height: 4),

//             LayoutBuilder(
//               builder: (ctx, cons) {
//                 final narrow = cons.maxWidth < 170;

//                 final priceText = Text(
//                   _fcfa(product.price),
//                   maxLines: 1,
//                   overflow: TextOverflow.fade,
//                   softWrap: false,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w900,
//                     fontSize: 12,
//                   ),
//                 );

//                 final oldPriceText = product.hasDiscount
//                     ? Opacity(
//                         opacity: .7,
//                         child: Text(
//                           _fcfa(product.oldPrice!),
//                           maxLines: 1,
//                           overflow: TextOverflow.fade,
//                           softWrap: false,
//                           style: const TextStyle(
//                             decoration: TextDecoration.lineThrough,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       )
//                     : const SizedBox.shrink();

//                 final rating = Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.star_rounded,
//                       color: Colors.amber,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 2),
//                     Text(
//                       product.rating.toStringAsFixed(1),
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 );

//                 final ptsChip = Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: gaindeGreenSoft,
//                     border: Border.all(color: gaindeGreen.withOpacity(.25)),
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                   child: Text(
//                     '${_fmtPoints(points)} pts',
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w800,
//                       color: gaindeGreen,
//                     ),
//                   ),
//                 );

//                 if (narrow) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Flexible(child: priceText),
//                           if (product.hasDiscount) const SizedBox(width: 6),
//                           if (product.hasDiscount)
//                             Flexible(child: oldPriceText),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(children: [rating, const Spacer(), ptsChip]),
//                     ],
//                   );
//                 }

//                 return Row(
//                   children: [
//                     Expanded(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Flexible(child: priceText),
//                           if (product.hasDiscount) const SizedBox(width: 6),
//                           if (product.hasDiscount)
//                             Flexible(child: oldPriceText),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     rating,
//                     const SizedBox(width: 8),
//                     ptsChip,
//                   ],
//                 );
//               },
//             ),

//             const SizedBox(height: 10),

//             SizedBox(
//               height: 36,
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 280),
//                   child: GlowButton(
//                     label: 'Ajouter au panier',
//                     onTap: onBuyCash,
//                     glowColor: cs.primary,
//                     bgColor: gaindeGreen,
//                     textColor: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SearchField extends StatelessWidget {
//   final String hint;
//   final ValueChanged<String> onChanged;
//   const _SearchField({required this.hint, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onChanged: onChanged,
//       textInputAction: TextInputAction.search,
//       decoration: InputDecoration(
//         hintText: hint,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 14,
//           vertical: 12,
//         ),
//         prefixIcon: const Icon(Icons.search_rounded),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
// }

// class _SoftIconButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _SoftIconButton({required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return InkWell(
//       borderRadius: BorderRadius.circular(12),
//       onTap: onTap,
//       child: Container(
//         height: 44,
//         width: 44,
//         decoration: BoxDecoration(
//           color: cs.primary.withOpacity(.08),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: cs.primary.withOpacity(.20)),
//         ),
//         child: Icon(icon, color: cs.primary),
//       ),
//     );
//   }
// }

// class _PromoStrip extends StatelessWidget {
//   final String text;
//   final IconData icon;
//   final Color color;
//   const _PromoStrip({
//     required this.text,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: const BoxDecoration(color: Colors.white),
//         child: Row(
//           children: [
//             Icon(icon, color: color),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(fontWeight: FontWeight.w700),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             TextButton(onPressed: () {}, child: const Text('Détails')),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Product {
//   final String title;
//   final String? image;
//   final int price;
//   final int? oldPrice;
//   final double rating;
//   final String? badge;
//   final String type;

//   const _Product({
//     required this.title,
//     required this.price,
//     required this.rating,
//     required this.type,
//     this.image,
//     this.oldPrice,
//     this.badge,
//   });

//   bool get hasDiscount => oldPrice != null && oldPrice! > price;
// }

// String _fcfa(int v) {
//   final s = v.toString();
//   final buf = StringBuffer();
//   for (int i = 0; i < s.length; i++) {
//     final revIdx = s.length - i;
//     buf.write(s[i]);
//     if (revIdx > 1 && revIdx % 3 == 1) buf.write(' ');
//   }
//   return '${buf.toString()} FCFA';
// }

// String _fmtPoints(int pts) {
//   final s = pts.toString();
//   final b = StringBuffer();
//   for (int i = 0; i < s.length; i++) {
//     final rev = s.length - i;
//     b.write(s[i]);
//     if (rev > 1 && rev % 3 == 1) b.write(' ');
//   }
//   return b.toString();
// }

// void _snack(BuildContext context, String msg) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// }
import 'package:fanexp/constants/functions.dart';
import 'package:fanexp/constants/size.dart';
import 'package:fanexp/services/shop/product.service.dart';
import 'package:flutter/material.dart';
import 'package:fanexp/theme/gainde_theme.dart';
import 'package:fanexp/widgets/glasscard.dart';
import 'package:fanexp/widgets/buttons.dart';
import 'package:fade_shimmer/fade_shimmer.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  static const int kFcfaPerPoint = 100;
  int userPoints = 1480;

  /// Future pour le FutureBuilder
  late Future<void> publishedProducts;

  /// Liste de produits venant de l’API
  final List<_Product> apiProducts = [];

  ProductService productService = ProductService();

  String query = '';
  String activeFilter = 'Tous';
  final filters = const [
    'Tous',
    'Maillots',
    'Accessoires',
    'Enfant',
    'Collectors',
  ];

  int _pointsForPrice(int fcfa) => (fcfa / kFcfaPerPoint).ceil();
  bool _canBuyWithPoints(int priceFcfa) =>
      userPoints >= _pointsForPrice(priceFcfa);

  /// Données locales (fallback si API vide)
  final items = <_Product>[
    _Product(
      title: 'Maillot 24/25 Domicile',
      image: 'assets/img/maillot.webp',
      price: 59000,
      oldPrice: 69000,
      rating: 4.7,
      badge: 'Nouveau',
      type: 'Maillots',
    ),
    _Product(
      title: 'Écharpe Gaïndé',
      image: 'assets/img/echarpe.jpg',
      price: 12000,
      rating: 4.6,
      type: 'Accessoires',
    ),
    _Product(
      title: 'Short Officiel',
      image: 'assets/img/short.png',
      price: 25000,
      rating: 4.4,
      type: 'Maillots',
    ),
    _Product(
      title: 'Casquette Lions',
      image: 'assets/img/cap.png',
      price: 15000,
      oldPrice: 18000,
      rating: 4.2,
      type: 'Accessoires',
      badge: '-15%',
    ),
    _Product(
      title: 'Mini-kit Enfant',
      image: 'assets/img/minikit.png',
      price: 39000,
      rating: 4.8,
      type: 'Enfant',
    ),
    _Product(
      title: 'Poster Collector Signé',
      image: 'assets/img/poster.png',
      price: 22000,
      rating: 4.9,
      type: 'Collectors',
    ),
    _Product(
      title: 'Sac de sport FFS',
      image: 'assets/img/bag.png',
      price: 28000,
      rating: 4.5,
      type: 'Accessoires',
    ),
    _Product(
      title: 'Maillot Extérieur 24/25',
      image: 'assets/img/maillot_ext.png',
      price: 59000,
      rating: 4.6,
      type: 'Maillots',
    ),
  ];

  @override
  void initState() {
    super.initState();
    publishedProducts = _loadProducts();
  }

  /// Charge les produits depuis ton backend et les mappe vers _Product
  Future<void> _loadProducts() async {
    final data = await productService.getProducts();
    if (!mounted) return;

    try {
      List<dynamic> rawList;

      if (data is List) {
        rawList = data;
      } else if (data is Map && data['data'] is List) {
        // Si ton backend renvoie { "data": [ ... ] }
        rawList = data['data'] as List<dynamic>;
      } else {
        rawList = const [];
      }

      apiProducts
        ..clear()
        ..addAll(
          rawList.whereType<Map<String, dynamic>>().map<_Product>(
            _Product.fromJson,
          ),
        );
      setState(() {});
    } catch (e) {
      // En cas de structure inattendue, on garde la liste locale
      debugPrint('Erreur parsing produits: $e');
    }
  }

  /// Retourne la liste filtrée (API si dispo, sinon fallback local)
  List<_Product> _filteredProducts() {
    final source = apiProducts.isNotEmpty ? apiProducts : items;

    return source.where((p) {
      final okFilter = activeFilter == 'Tous' || p.type == activeFilter;
      final okQuery =
          query.trim().isEmpty ||
          p.title.toLowerCase().contains(query.trim().toLowerCase());
      return okFilter && okQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: gaindeGreenSoft,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: gaindeGreen.withOpacity(.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.loyalty_rounded,
                      size: 16,
                      color: gaindeGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_fmtPoints(userPoints)} pts',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Panier',
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: publishedProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _ShopSkeleton();
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: gaindeRed, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      'Impossible de charger la boutique',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vérifie ta connexion puis réessaie.',
                      style: TextStyle(color: gaindeInk.withOpacity(.7)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          publishedProducts = _loadProducts();
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gaindeGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final filtered = _filteredProducts();

          return CustomScrollView(
            slivers: [
              // Barre de recherche + bouton tri
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SearchField(
                          hint: 'Rechercher un produit…',
                          onChanged: (v) => setState(() => query = v),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Tooltip(
                        message: 'Trier',
                        child: _SoftIconButton(
                          icon: Icons.tune_rounded,
                          onTap: () => _snack(
                            context,
                            'Tri (à implémenter côté backend)',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Filtres horizontaux
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 46,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      final f = filters[i];
                      final selected = f == activeFilter;
                      return ChoiceChip(
                        label: Text(f),
                        selected: selected,
                        onSelected: (_) => setState(() => activeFilter = f),
                        selectedColor: gaindeGreenSoft,
                        side: BorderSide(
                          color: selected
                              ? gaindeGreen.withOpacity(.4)
                              : gaindeInk.withOpacity(.12),
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected ? gaindeGreen : gaindeInk,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: filters.length,
                  ),
                ),
              ),

              // Grille produits
              if (filtered.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.store_mall_directory_outlined,
                          size: 64,
                          color: gaindeInk,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Aucun produit trouvé',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Modifie les filtres ou la recherche pour voir d’autres articles.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: gaindeInk.withOpacity(.7)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.crossAxisExtent;
                      const target = 180.0;
                      int cols = (w / target).floor().clamp(2, 4);
                      if (w > 950) cols = 5;

                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: .55,
                        ),
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final p = filtered[i];
                          final pts = _pointsForPrice(p.price);
                          final canBuy = _canBuyWithPoints(p.price);
                          return _ProductCard(
                            product: p,
                            points: pts,
                            canBuyWithPoints: canBuy,
                            onBuyPoints: () {
                              if (!canBuy) {
                                _snack(
                                  context,
                                  'Points insuffisants (${_fmtPoints(userPoints)} pts)',
                                );
                                return;
                              }
                              setState(() => userPoints -= pts);
                              _snack(
                                context,
                                'Achat en points réussi (-$pts pts)',
                              );
                            },
                            onBuyCash: () =>
                                _snack(context, 'Ajouté au panier'),
                          );
                        }, childCount: filtered.length),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      // bottomNavigationBar: _PromoStrip(
      //   text: 'Livraison OFFERTE dès 50.000 FCFA • Retours sous 30 jours',
      //   icon: Icons.local_shipping_outlined,
      //   color: cs.primary,
      // ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final int points;
  final bool canBuyWithPoints;
  final VoidCallback onBuyPoints;
  final VoidCallback onBuyCash;

  const _ProductCard({
    required this.product,
    required this.points,
    required this.canBuyWithPoints,
    required this.onBuyPoints,
    required this.onBuyCash,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _snack(context, 'Ouvrir ${product.title}'),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: gaindeGoldSoft,
                      child: (product.image != null)
                          ? Image.network(
                              product.image!,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 44,
                                  color: gaindeGold,
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 44,
                                color: gaindeGold,
                              ),
                            ),
                    ),
                  ),
                ),
                if (product.badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: gaindeRed,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        product.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),

            LayoutBuilder(
              builder: (ctx, cons) {
                final narrow = cons.maxWidth < 170;

                final priceText = Text(
                  _fcfa(product.price),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                );

                final oldPriceText = product.hasDiscount
                    ? Opacity(
                        opacity: .7,
                        child: Text(
                          _fcfa(product.oldPrice!),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();

                final rating = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );

                final ptsChip = Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gaindeGreenSoft,
                    border: Border.all(color: gaindeGreen.withOpacity(.25)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_fmtPoints(points)} pts',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: gaindeGreen,
                    ),
                  ),
                );

                if (narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: priceText),
                          if (product.hasDiscount) const SizedBox(width: 6),
                          if (product.hasDiscount)
                            Flexible(child: oldPriceText),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(children: [rating, const Spacer(), ptsChip]),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: priceText),
                          if (product.hasDiscount) const SizedBox(width: 6),
                          if (product.hasDiscount)
                            Flexible(child: oldPriceText),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    rating,
                    const SizedBox(width: 8),
                    ptsChip,
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 36,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: GlowButton(
                    label: 'Ajouter au panier',
                    onTap: onBuyCash,
                    glowColor: cs.primary,
                    bgColor: gaindeGreen,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopSkeleton extends StatelessWidget {
  const _ShopSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Search + filtre
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _shimmerBox(height: 44, radius: 12)),
              const SizedBox(width: 12),
              _shimmerBox(height: 44, width: 44, radius: 12),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Filtres horizontaux
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, __) =>
                _shimmerBox(height: 34, width: 90, radius: 20),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemCount: 5,
          ),
        ),

        const SizedBox(height: 20),

        // Grille skeleton 2x3
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .60,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (_, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(height: 150, radius: 12),
                  const SizedBox(height: 10),
                  _shimmerBox(height: 14, width: 120),
                  const SizedBox(height: 6),
                  _shimmerBox(height: 14, width: 80),
                  const SizedBox(height: 6),
                  _shimmerBox(height: 34, radius: 12),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

Widget _shimmerBox({double? height, double? width, double radius = 8}) {
  return FadeShimmer(
    height: height ?? 16,
    width: width ?? double.infinity,
    radius: radius,
    highlightColor: const Color(0xFFE8F5E9),
    baseColor: const Color(0xFFC8C8C8),
    fadeTheme: FadeTheme.light,
  );
}

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gaindeInk.withOpacity(.12)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _SoftIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SoftIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.primary.withOpacity(.20)),
        ),
        child: Icon(icon, color: cs.primary),
      ),
    );
  }
}

class _PromoStrip extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  const _PromoStrip({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Détails')),
          ],
        ),
      ),
    );
  }
}

class _Product {
  final String title;
  final String? image;
  final int price;
  final int? oldPrice;
  final double rating;
  final String? badge;
  final String type;

  const _Product({
    required this.title,
    required this.price,
    required this.rating,
    required this.type,
    this.image,
    this.oldPrice,
    this.badge,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  /// Mapping générique depuis le JSON backend
  /// ⚠️ Adapte les clés à ton API : libelle / prix / imageUrl / categorie...
  factory _Product.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['prix'] ?? json['price'] ?? 0;
    final rawOld = json['prixAncien'] ?? json['oldPrice'];

    return _Product(
      title:
          (json['libelle'] ??
                  json['name'] ??
                  json['title'] ??
                  'Produit sans nom')
              .toString(),
      price: rawPrice is int
          ? rawPrice
          : (rawPrice is double ? rawPrice.toInt() : 0),
      rating: (json['rating'] ?? 4.5).toDouble(),
      type: (json['categorie'] ?? json['category'] ?? 'Tous').toString(),
      image: (json['image'] ?? json['imageUrl'])?.toString(),
      oldPrice: rawOld == null
          ? null
          : (rawOld is int
                ? rawOld
                : (rawOld is double ? rawOld.toInt() : null)),
      badge: json['badge']?.toString(),
    );
  }
}

String _fcfa(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final revIdx = s.length - i;
    buf.write(s[i]);
    if (revIdx > 1 && revIdx % 3 == 1) buf.write(' ');
  }
  return '${buf.toString()} FCFA';
}

String _fmtPoints(int pts) {
  final s = pts.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final rev = s.length - i;
    b.write(s[i]);
    if (rev > 1 && rev % 3 == 1) b.write(' ');
  }
  return b.toString();
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
