import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE9F0FF),
        centerTitle: true,
        title: const Text(
          "Cometies",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50, width: 20),
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xffE9F0FF),
                        ),
                      ),
                      child: const FittedBox(
                        child: Text(
                          "All",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50, width: 20),
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xffE9F0FF),
                        ),
                      ),
                      child: const FittedBox(
                        child: Text(
                          "MONTHLY",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50, width: 20),
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xffE9F0FF),
                        ),
                      ),
                      child: const FittedBox(
                        child: Text(
                          "LOCATION",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 508,
              child: Card(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                    height: 1,
                  ),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: const Color(0xffE9F0FF),
                      contentPadding: const EdgeInsets.only(right: 15),
                      leading: const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/pfavatar.png'),
                      ),
                      title: Text(
                        'User Name',
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration',
                            style: GoogleFonts.roboto(
                                // fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Text(
                            'Amount',
                            style: GoogleFonts.roboto(
                                // fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/svg/info.svg'),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
