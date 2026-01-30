import 'package:flutter/material.dart';
import 'package:itemtracker/custom_methods/reusable_methods.dart';
import 'package:itemtracker/models/item_model.dart';
import 'package:itemtracker/providers/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ItemInput extends StatefulWidget {
  const ItemInput({super.key, this.im});

  final ItemModel? im;

  @override
  State<ItemInput> createState() => _ItemInputState();
}

class _ItemInputState extends State<ItemInput> {
  ReusableMethods rm = ReusableMethods();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  TextEditingController descript = TextEditingController();

  String imgpath = '';

  String id = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    if (widget.im != null) {
      id = widget.im!.id!;
      name.text = widget.im!.name!;
      descript.text = widget.im!.description!;
      imgpath = widget.im!.imgurl!;
      print('update item button pressed');
    } else {
      print('add item button pressed');
    }
  }

  void submitAction(BuildContext context) {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      if (widget.im == null) {
        if (imgpath == '') {
          rm.dipalyAlertdialog(context, 'warning', 'please capture image');
          return;
        }
        Provider.of<ItemProvider>(context, listen: false).addItem(ItemModel(
            id: id,
            name: name.text,
            description: descript.text,
            imgurl: imgpath,
            createdAt: DateTime.now()));
        rm.displaySnackbar(context, 'Item added successfully');
      } else {
        Provider.of<ItemProvider>(context, listen: false).updateitem(ItemModel(
          id: id,
          name: name.text,
          description: descript.text,
          imgurl: imgpath,
        ));
        rm.displaySnackbar(context, 'Item Updated Successfully');
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                  controller: name,
                  decoration: const InputDecoration(hintText: 'Village Name'),
                  onSaved: (newValue) {
                    name.text = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 100,
                child: TextFormField(
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    controller: descript,
                    decoration: const InputDecoration(
                        label: Text('Description'),
                        border: OutlineInputBorder()),
                    onSaved: (newValue) {
                      descript.text = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid description';
                      }
                      return null;
                    }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      final path = await ReusableMethods().pickAndSaveImage();
                      if (path == null) return;
                      setState(() {
                        imgpath = path;
                      });
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 60,
                    )),
                ElevatedButton(
                    onPressed: () {
                      submitAction(context);
                      //Provider.of<ItemProvider>(context).deleteallitems();
                    },
                    child: widget.im != null
                        ? const Text('Update')
                        : const Text('submit')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('cancel')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
