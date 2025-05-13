import 'package:get/get.dart';

class SelectionController<T> extends GetxController {

  final RxSet<String> _selectedIds = <String>{}.obs;

  // Public getter
  Set<String> get selectedIds => _selectedIds;

  // Toggle selection for an ID
  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  }

  // Check if selected
  bool isSelected(String id) => _selectedIds.contains(id);

  // Clear all selections
  void clearSelection() {
    _selectedIds.clear();
  }

  // Select all from a list of IDs
  void selectAll(List<String> ids) {
    _selectedIds.addAll(ids);
  }
}
