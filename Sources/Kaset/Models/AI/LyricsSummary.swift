import Foundation

/// AI-generated summary and analysis of song lyrics.
/// Provides themes, mood analysis, and an explanation of the song's meaning.
@available(macOS 26.0, *)
struct LyricsSummary {
    /// Key themes or topics in the lyrics (e.g., "love", "loss", "hope").
    let themes: [String]

    /// The overall mood or emotional tone of the song.
    let mood: String

    /// A brief explanation of what the song is about.
    let explanation: String

    struct PartiallyGenerated {
        let themes: [String]?
        let mood: String?
        let explanation: String?
    }
}
