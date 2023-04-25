import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // We can detect the location of the cart by this  GlobalKey<CartIconKey>
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn with me"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _cartQuantityItems = 0;
              cartKey.currentState!.runClearCartAnimation();
            },
          ),
          const SizedBox(width: 16),
          AddToCartIcon(
            key: cartKey,
            icon: const Icon(Icons.shopping_cart),
            badgeOptions: const BadgeOptions(
              active: true,
              backgroundColor: Colors.red,
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: AddToCartAnimation(
        // To send the library the location of the Cart icon
        cartKey: cartKey,
        height: 30,
        width: 30,
        opacity: 0.85,
        dragAnimation: const DragToCartAnimationOptions(
          rotation: true,
        ),
        jumpAnimation: const JumpAnimationOptions(),
        createAddToCartAnimation: (runAddToCartAnimation) {
          // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
          this.runAddToCartAnimation = runAddToCartAnimation;
        },
        child: ListView(
          children: List.generate(
            10,
            (index) => AppListItem(
              onClick: listClick,
              index: index,
            ),
          ),
        ),
      ),
    );
  }

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!
        .runCartAnimation((++_cartQuantityItems).toString());
  }
}

class AppListItem extends StatelessWidget {
  final GlobalKey widgetKey = GlobalKey();
  final int index;
  final void Function(GlobalKey) onClick;

  AppListItem({super.key, required this.onClick, required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          onTap: () => onClick(widgetKey),
          leading: Container(
            key: widgetKey,
            width: 60,
            height: 60,
            color: Colors.transparent,
            child: Image.asset(
              "images/flash.png",
              width: 60,
              height: 60,
            ),
          ),
          title: Text(
            "Product $index",
          ),
        ),
      ),
    );
  }
}
