import 'package:flutter/material.dart';
import 'package:grad_login/providers/addressProvider.dart';
import 'package:provider/provider.dart';

import 'add_address_screen.dart';
import 'address_detail_screen.dart';
import 'edit_address_screen.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/address-screen';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

bool _isLoading = true;

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Address>(context, listen: false).fetchAddress().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addresses = Provider.of<Address>(context).items;
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Addresses',
            style: Theme.of(context)
                .appBarTheme
                .titleTextStyle!
                .copyWith(fontSize: mediaQuery.width * 0.045),
          ),
        ),
        body: addresses.isEmpty
            ? const Center(
                child: Text(
                  'You have not added addresses yet!',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              )
            : _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                print('Deleting');
                                try {
                                  Provider.of<Address>(context, listen: false)
                                      .deleteAddress(addresses[index].id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Address Deleted Successfully!'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Deleting Failed',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AddressDetailScreen.routeName,
                                          arguments: AddressItem(
                                            id: addresses[index].id,
                                            street: addresses[index].street,
                                            city: addresses[index].city,
                                            description:
                                                addresses[index].description,
                                            phone: addresses[index].phone,
                                            type: addresses[index].type,
                                            title: addresses[index].title,
                                          ));
                                },
                                child: Ink(
                                  height: 100,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 2,
                                          color: Colors.blueGrey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ListTile(
                                      leading: Icon(
                                        addresses[index].type == 'Home'
                                            ? Icons.home_outlined
                                            : Icons.business,
                                        size: 50,
                                      ),
                                      title: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        addresses[index].description,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      subtitle: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        '${addresses[index].street}, ${addresses[index].city}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    EditAddressScreen.routeName,
                                                    arguments: AddressItem(
                                                      id: addresses[index].id,
                                                      street: addresses[index]
                                                          .street,
                                                      city:
                                                          addresses[index].city,
                                                      description:
                                                          addresses[index]
                                                              .description,
                                                      phone: addresses[index]
                                                          .phone,
                                                      type:
                                                          addresses[index].type,
                                                      title: addresses[index]
                                                          .title,
                                                    ));
                                              },
                                              icon: const Icon(Icons.edit)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      },
                      itemCount: addresses.length,
                    ),
                  ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              fixedSize: Size(
                mediaQuery.width * 0.85,
                mediaQuery.height * 0.06,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddAddressScreen.routeName);
            },
            child: Text(
              'Add new address',
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle!
                  .copyWith(fontSize: mediaQuery.width * 0.045),
            ),
          ),
        ),
      ),
    );
  }
}
