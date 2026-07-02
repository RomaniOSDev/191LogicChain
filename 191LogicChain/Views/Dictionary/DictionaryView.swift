import SwiftUI

struct DictionaryView: View {
    @StateObject private var viewModel: DictionaryViewModel

    init(viewModel: DictionaryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(title: "Dictionary", subtitle: "\(viewModel.filteredWords.count) words", onBack: viewModel.goBack) {
            VStack(spacing: Theme.Spacing.sm) {
                AppTextField(placeholder: "Search words or synonyms", text: $viewModel.searchText, icon: "magnifyingglass")
                    .padding(.horizontal, Theme.Spacing.md)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChipView(title: "All", isSelected: viewModel.selectedCategory == nil) {
                            viewModel.selectedCategory = nil
                        }
                        ForEach(Category.allCases, id: \.self) { cat in
                            FilterChipView(title: "\(cat.icon) \(cat.displayName)", isSelected: viewModel.selectedCategory == cat) {
                                viewModel.selectedCategory = cat
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.filteredWords) { word in
                            let isExpanded = viewModel.expandedWordId == word.id
                            DictionaryWordCell(
                                word: word,
                                isExpanded: isExpanded,
                                chainSuggestions: isExpanded ? viewModel.chainSuggestions(for: word) : [],
                                onTap: { viewModel.toggleWord(word) }
                            )
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.lg)
                }
            }
        }
    }
}
