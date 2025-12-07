//
//  HomeWidget.swift
//  HomeWidget
//
//  Created by adil sakout on 7/12/2025.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
// This provider handles fetching word data from shared UserDefaults
// and creating timeline entries for the widget
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WordEntry {
        WordEntry(
            date: Date(),
            word: "Ephemeral",
            definition: "Lasting for a very short time",
            phonetic: "/ɪˈfɛm(ə)rəl/",
            example: "The beauty of the sunset was ephemeral, lasting only minutes.",
            isFavorite: false
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> ()) {
        let entry = getWordEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> ()) {
        let entry = getWordEntry()
        
        // Create a timeline that updates the widget every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    /// Fetches word data from shared UserDefaults (App Group)
    /// This data is saved by the Flutter app using the home_widget package
    private func getWordEntry() -> WordEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.app.clickwiseapps.wordstock.shared")
        
        // Read word data from shared preferences
        let word = sharedDefaults?.string(forKey: "word") ?? "Welcome"
        let definition = sharedDefaults?.string(forKey: "definition") ?? "Learn a new word every day"
        let phonetic = sharedDefaults?.string(forKey: "phonetic") ?? ""
        let example = sharedDefaults?.string(forKey: "example") ?? ""
        
        // Read favorite status as string and convert to boolean
        // This avoids NSNull casting issues with boolean values
        let isFavoriteString = sharedDefaults?.string(forKey: "isFavorite") ?? "false"
        let isFavorite = isFavoriteString == "true"
        
        return WordEntry(
            date: Date(),
            word: word,
            definition: definition,
            phonetic: phonetic,
            example: example,
            isFavorite: isFavorite
        )
    }
}

// MARK: - Word Entry
// Represents a single timeline entry with word data
struct WordEntry: TimelineEntry {
    let date: Date
    let word: String
    let definition: String
    let phonetic: String
    let example: String
    let isFavorite: Bool
}

// MARK: - Reusable Gradient Background
struct WidgetBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.11, green: 0.69, blue: 0.96),
                Color(red: 0.10, green: 0.60, blue: 0.84)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Widget View
// The main view that displays the word card in the widget
struct HomeWidgetEntryView: View {
    var entry: WordEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWordWidget(entry: entry)
            case .systemMedium:
                MediumWordWidget(entry: entry)
            case .systemLarge:
                LargeWordWidget(entry: entry)
            default:
                MediumWordWidget(entry: entry)
            }
        }
        // Add tap action to open the app
        .widgetURL(URL(string: "wordstock://home"))
    }
}

// MARK: - Small Widget (Compact view)
// Displays just the word and definition
struct SmallWordWidget: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(spacing: 8) {
            // App branding
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 12))
                Text("Word of the Day")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 0.91, green: 0.31, blue: 0.47))
                        .font(.system(size: 12))
                }
            }
            
            Spacer()
            
            // Word
            Text(entry.word)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            // Phonetic (if available)
            if !entry.phonetic.isEmpty {
                Text(entry.phonetic)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            
            // Definition
            Text(entry.definition)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(12)
    }
}

// MARK: - Medium Widget (Standard view)
// Displays word, phonetic, definition, and example
struct MediumWordWidget: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(spacing: 10) {
            // Header with branding and favorite indicator
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 14))
                Text("Word of the Day")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 0.91, green: 0.31, blue: 0.47))
                        .font(.system(size: 14))
                }
            }
            
            Spacer()
            
            // Word
            Text(entry.word)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            // Phonetic
            if !entry.phonetic.isEmpty {
                Text(entry.phonetic)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            
            // Definition
            Text(entry.definition)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(16)
    }
}

// MARK: - Large Widget (Full view)
// Displays all information including example sentence
struct LargeWordWidget: View {
    let entry: WordEntry
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 16))
                Text("Word of the Day")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                Spacer()
                if entry.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color(red: 0.91, green: 0.31, blue: 0.47))
                        .font(.system(size: 16))
                }
            }
            
            Spacer()
            
            // Word
            Text(entry.word)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            // Phonetic
            if !entry.phonetic.isEmpty {
                Text(entry.phonetic)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            
            // Definition
            Text(entry.definition)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)
            
            // Example (if available)
            if !entry.example.isEmpty {
                Text("\"\(entry.example)\"")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.85))
                    .italic()
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            // Footer hint
            Text("Tap to open Wordstock")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(20)
    }
}

// MARK: - Widget Configuration
struct HomeWidget: Widget {
    let kind: String = "HomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    WidgetBackground()
                }
        }
        .configurationDisplayName("Word of the Day")
        .description("Learn a new word every day with Wordstock")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    HomeWidget()
} timeline: {
    WordEntry(
        date: .now,
        word: "Ephemeral",
        definition: "Lasting for a very short time",
        phonetic: "/ɪˈfɛm(ə)rəl/",
        example: "The beauty of the sunset was ephemeral, lasting only minutes.",
        isFavorite: false
    )
    WordEntry(
        date: .now,
        word: "Serendipity",
        definition: "The occurrence of events by chance in a happy way",
        phonetic: "/ˌserənˈdɪpɪti/",
        example: "It was pure serendipity that we met at the coffee shop.",
        isFavorite: true
    )
}
