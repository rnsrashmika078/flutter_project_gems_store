import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:superbase_auth/models/gem.dart';
import 'package:superbase_auth/services/supabase_services.dart';
import 'package:superbase_auth/widgets/gem_card_widget.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  List<Gem> gems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGems();
  }

  Future<void> loadGems() async {
    final result = await getGemListing();
    setState(() {
      gems = result;
      isLoading = false;
    });
  }

  Future<void> removeGem(String id) async {
    await deleteItem(id);
    setState(() {
      gems.removeWhere((gem) => gem.id == id);
    });
  }

  Future<void> editGem(Gem updatedGem) async {
    await updateItem(updatedGem);
    setState(() {
      final index = gems.indexWhere((g) => g.id == updatedGem.id);
      if (index != -1) gems[index] = updatedGem;
    });
  }

  void showGemDialog({Gem? existing}) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final typeController = TextEditingController(text: existing?.type ?? '');
    final priceController =
        TextEditingController(text: existing?.price.toString() ?? '');
    final locationController =
        TextEditingController(text: existing?.location ?? '');
    final ownerController = TextEditingController(text: existing?.owner ?? '');

    Uint8List? selectedImageBytes;
    final picker = ImagePicker();
    final isEditing = existing != null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> pickImage() async {
              final picked =
                  await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                final bytes = await picked.readAsBytes();
                setStateDialog(() {
                  selectedImageBytes = bytes;
                });
              }
            }

            return AlertDialog(
              title: Text(isEditing ? "Edit Gem" : "Add Gem"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey[300],
                        child: selectedImageBytes != null
                            ? Image.memory(
                                selectedImageBytes!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )
                            : (isEditing && existing.imagePath.isNotEmpty)
                                ? Image.network(
                                    existing.imagePath,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.add_a_photo),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Gem Name"),
                    ),
                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(labelText: "Type"),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Price"),
                    ),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: "Location"),
                    ),
                    TextField(
                      controller: ownerController,
                      decoration: const InputDecoration(labelText: "Owner"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    String imagePath = existing?.imagePath ?? "";

                    if (selectedImageBytes != null) {
                      imagePath =
                          await uploadImageToSupabase(selectedImageBytes!) ??
                              imagePath;
                    }

                    final gem = Gem(
                      id: existing?.id ?? '',
                      name: nameController.text,
                      type: typeController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      location: locationController.text,
                      imagePath: imagePath,
                      owner: ownerController.text,
                    );

                    if (isEditing) {
                      await editGem(gem);
                    } else {
                      await addItem(gem);
                      await loadGems(); // reload to get Supabase-generated id
                    }

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(isEditing ? "Update" : "Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All in one place for Gems in Srilanka",style: TextStyle( fontStyle: FontStyle.italic),)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : gems.isEmpty
              ? const Center(child: Text("No gems added yet"))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (MediaQuery.of(context).size.width / 200)
                        .floor()
                        .clamp(2, 6),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: gems.length,
                  itemBuilder: (context, index) {
                    final gemItem = gems[index];
                    return GemCard(
                      name: gemItem.name,
                      type: gemItem.type,
                      imageUrl: gemItem.imagePath.isNotEmpty
                          ? gemItem.imagePath
                          : "assets/images/first.png",
                      owner: gemItem.owner,
                      price: gemItem.price,
                      location: gemItem.location,
                      onEdit: () => showGemDialog(existing: gemItem),
                      onDelete: () => removeGem(gemItem.id),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showGemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}