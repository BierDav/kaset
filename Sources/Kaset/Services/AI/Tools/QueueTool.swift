import Foundation

/// A tool that provides the current playback queue context to the language model.
/// This allows AI to understand what's in the queue before making changes.
@available(macOS 26.0, *)
@MainActor
struct QueueTool {
    /// The PlayerService used to access queue state.
    private let playerService: PlayerService

    /// Logger for debugging.
    private let logger = DiagnosticsLogger.ai

    /// Creates a new QueueTool.
    /// - Parameter playerService: The PlayerService to access queue state from.
    init(playerService: PlayerService) {
        self.playerService = playerService
    }

    /// Returns the current queue state as a formatted string.
    nonisolated func currentQueueDescription(limit: Int = 20) async -> String {
        await MainActor.run {
            let queue = self.playerService.queue
            let currentIndex = self.playerService.currentIndex
            let normalizedLimit = limit > 0 ? limit : 20

            guard !queue.isEmpty else {
                return "Queue is empty. No tracks are queued."
            }

            var output = "Current Queue (\(queue.count) tracks):\n"

            for (index, song) in queue.prefix(normalizedLimit).enumerated() {
                let marker = index == currentIndex ? "▶ NOW PLAYING" : "  "
                output += "\(marker) \(index + 1). \"\(song.title)\" by \(song.artistsDisplay) [videoId: \(song.videoId)]\n"
            }

            if queue.count > normalizedLimit {
                output += "... and \(queue.count - normalizedLimit) more tracks"
            }

            self.logger.debug("QueueTool returned \(queue.count) tracks")
            return output
        }
    }
}
