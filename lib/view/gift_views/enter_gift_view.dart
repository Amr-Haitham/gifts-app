import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../constants/utils.dart';
import '../../controller/gifts/set_gift_controller.dart';
import '../../controller/pledges/get_custom_user_pledges_controller.dart';
import '../../controller/pledges/get_pledge_status_controller.dart';
import '../../model/classes/gift.dart';
import '../../model/classes/pledge.dart';

class GiftFormScreen extends StatefulWidget {
  final Gift? gift;
  final String eventId;
  final bool isMyGift;

  const GiftFormScreen({
    Key? key,
    required this.gift,
    required this.eventId,
    required this.isMyGift,
  }) : super(key: key);

  @override
  State<GiftFormScreen> createState() => _GiftFormScreenState();
}

class _GiftFormScreenState extends State<GiftFormScreen> {
  final _giftNameController = TextEditingController();
  final _giftDescriptionController = TextEditingController();
  final _giftCategoryController = TextEditingController();
  final _giftPriceController = TextEditingController();
  String? selectedImage;
  File? selectedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.gift != null) {
      BlocProvider.of<GetPledgeStatusForGiftCubit>(context)
          .getPledgeStatusForGift(
              giftId: widget.gift!.id, eventId: widget.eventId);

      _giftNameController.text = widget.gift!.name;
      _giftDescriptionController.text = widget.gift!.description;
      _giftCategoryController.text = widget.gift!.category;
      _giftPriceController.text = widget.gift!.price.toString();
      selectedImage = widget.gift!.imageUrl;
      if (widget.gift!.imageUrl != null) {
        base64ToFile(widget.gift!.imageUrl!, "giftImage").then((value) {
          setState(() {
            selectedImageFile = value;
          });
        });
      }
    }
  }

  Future<String?> processImage(
      {required File imageFile, required BuildContext context}) async {
    try {
      final int fileSize = await imageFile.length();
      if (fileSize > 100 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Image size exceeds 100KB. Please upload a smaller image.'),
          ),
        );
        return null;
      }
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process image: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.isMyGift
              ? widget.gift == null
                  ? "Add Gift"
                  : "Edit Gift"
              : "View Gift",
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                enabled: widget.isMyGift,
                controller: _giftNameController,
                decoration: InputDecoration(
                  labelText: "Item Name",
                  labelStyle: theme.textTheme.bodyMedium,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                enabled: widget.isMyGift,
                controller: _giftDescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: theme.textTheme.bodyMedium,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                enabled: widget.isMyGift,
                controller: _giftCategoryController,
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: theme.textTheme.bodyMedium,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                enabled: widget.isMyGift,
                controller: _giftPriceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  labelStyle: theme.textTheme.bodyMedium,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  textStyle: theme.textTheme.bodyMedium,
                ),
                onPressed: () async {
                  await Permission.photos.request();
                  var image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    selectedImage = await processImage(
                      imageFile: File(image.path),
                      context: context,
                    );
                    setState(() {
                      selectedImageFile = File(image.path);
                    });
                  }
                },
                child: const Text("Add Photo"),
              ),
              if (selectedImageFile != null)
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(selectedImageFile!),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              const SizedBox(height: 20),
              (widget.isMyGift)
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                      onPressed: () {
                        if (_giftNameController.text.isNotEmpty &&
                            _giftCategoryController.text.isNotEmpty &&
                            _giftPriceController.text.isNotEmpty &&
                            selectedImage != null) {
                          BlocProvider.of<SetGiftForEventCubit>(context)
                              .setGift(
                            gift: Gift(
                              id: widget.gift?.id ?? const Uuid().v4(),
                              name: _giftNameController.text,
                              description: _giftDescriptionController.text,
                              category: _giftCategoryController.text,
                              price: double.parse(_giftPriceController.text),
                              status:
                                  widget.gift?.status ?? GiftStatus.unpledged,
                              eventId: widget.eventId,
                              imageUrl: selectedImage!,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          showErrorSnackBar(context, "Please fill all fields.");
                        }
                      },
                      child:
                          Text(widget.gift == null ? "Add Gift" : "Save Gift"),
                    )
                  : PledgeButton(
                      giftId: widget.gift!.id, eventId: widget.eventId),
            ],
          ),
        ),
      ),
    );
  }
}

class PledgeButton extends StatelessWidget {
  final String giftId;
  final String eventId;

  const PledgeButton({Key? key, required this.giftId, required this.eventId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommitmentCubit, CommitmentState>(listener:
        (context, state) {
      if (state is CommitmentSuccess) {
        Navigator.pop(context);
        showErrorSnackBar(context, 'Successfully gift pledged.');
      }
    }, child:
        BlocBuilder<GetPledgeStatusForGiftCubit, GetPledgeStatusForGiftState>(
      builder: (context, state) {
        if (state is GetPledgeStatusForGiftSuccess) {
          final pledgeStatus = state.pledgeStatus;

          return SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (pledgeStatus != PledgeStatus.unpledged) {
                  showErrorSnackBar(context, 'This gift is already pledged.');
                } else {
                  BlocProvider.of<CommitmentCubit>(context).commitPledge(
                      pledge: Pledge(
                          id: const Uuid().v4(),
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          giftId: giftId,
                          eventId: eventId,
                          isFulfilled: false,
                          giftOwnerId: state.giftOwnerID));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                pledgeStatus == PledgeStatus.pledged ||
                        pledgeStatus == PledgeStatus.done
                    ? 'Gift Pledged'
                    : 'Pledge this gift',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    ));
  }
}
