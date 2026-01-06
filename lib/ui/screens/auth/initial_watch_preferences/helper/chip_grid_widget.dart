import '../../../../../framework/provider/network/network.dart';
import '../../../../../framework/repository/preferences/model/get_preferences_response_model.dart';

class GenreWrapScroller extends StatelessWidget {
  final List<PreferenceResult> genres;
  final List<PreferenceResult> selectedGenres;
  final void Function(PreferenceResult genre) onGenreTap;

  const GenreWrapScroller({
    super.key,
    required this.genres,
    required this.selectedGenres,
    required this.onGenreTap,
  });

  // Split into 3 vertical rows (like columns in horizontal scroll)
  List<List<PreferenceResult>> splitIntoRows(
      List<PreferenceResult> items, int rowCount) {
    List<List<PreferenceResult>> rows = List.generate(rowCount, (_) => []);
    for (int i = 0; i < items.length; i++) {
      rows[i % rowCount].add(items[i]);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = splitIntoRows(genres, 10);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        // height: context.height *.2,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.map((column) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: column.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GenreChip(
                      genre: genre,
                      isSelected: isSelected,
                      onTap: () => onGenreTap(genre),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class GenreChip extends StatelessWidget {
  final PreferenceResult genre;
  final bool isSelected;
  final VoidCallback onTap;

  const GenreChip({
    super.key,
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.white24,
            width: 1.5,
          ),
        ),
        child: Text(
          genre.name ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
