//
//  ContentView.swift
//  191LogicChain
//

import Combine
import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    @State private var accessibility = AccessibilitySettings.default
    @State private var hasCompletedOnboarding = OnboardingStore().hasCompleted

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                mainNavigation
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
        .applyAccessibility(accessibility)
        .onAppear {
            accessibility = coordinator.accessibilityStore.load()
        }
        .onReceive(NotificationCenter.default.publisher(for: .accessibilityChanged)) { _ in
            accessibility = coordinator.accessibilityStore.load()
        }
    }

    private var mainNavigation: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.start()
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.destination(for: route)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
