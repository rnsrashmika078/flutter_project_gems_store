import 'package:flutter/material.dart';

class GemCard extends StatelessWidget {
  final String name;
  final String type;
  final String imageUrl;
  final String owner;
  final double price;
  final String location;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GemCard({
    super.key,
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.owner,
    required this.price,
    required this.location,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔷 Fixed image at top
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: SizedBox(
              height: 180,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 📝 Remaining content takes remaining space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + type
                  Text(
                    "$name ($type)",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 5),

                  // Owner
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          owner,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.red),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Price
                  Text(
                    "Rs. ${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const Spacer(),

                  // Edit/Delete buttons at bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: onEdit,
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}