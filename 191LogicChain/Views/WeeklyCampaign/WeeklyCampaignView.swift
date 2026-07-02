import SwiftUI

struct WeeklyCampaignView: View {
    @StateObject private var viewModel: WeeklyCampaignViewModel

    init(viewModel: WeeklyCampaignViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScreenScaffold(
            title: "Weekly Campaign",
            subtitle: viewModel.campaign.themeTitle,
            onBack: viewModel.goBack
        ) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.md) {
                    AppCard(accent: Color(hex: "ffa500")) {
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Progress")
                                    .font(.caption)
                                    .foregroundColor(Theme.secondaryText)
                                Text("\(viewModel.campaign.completedCount) / 7")
                                    .font(.title.bold())
                                    .foregroundColor(Theme.primaryText)
                            }
                            Spacer()
                            ProgressView(value: Double(viewModel.campaign.completedCount), total: 7)
                                .tint(Color(hex: "ffa500"))
                                .frame(width: 100)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)

                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.campaign.days) { day in
                            WeeklyDayCell(day: day) { viewModel.playDay(day) }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }
                .padding(.vertical, Theme.Spacing.sm)
            }
        }
        .onAppear { viewModel.refresh() }
    }
}
