import Foundation

/// Represents AI-suggested changes to a playlist.
/// Generated when the user asks to "refine" or "clean up" a playlist.
@available(macOS 26.0, *)
struct PlaylistChanges {
    /// Video IDs of tracks to remove from the playlist.
    let removals: [String]

    /// Reordered list of video IDs representing the new order.
    /// If nil, order should not change.
    let reorderedIds: [String]?

    /// Brief explanation of why these changes were suggested.
    let reasoning: String

    struct PartiallyGenerated {
        let removals: [String]?
        let reorderedIds: [String]?
        let reasoning: String?
    }

    /// Normalizes no-op reorder output so UI code can treat it as "no reordering".
    func normalized(forOriginalTrackIds originalTrackIds: [String]) -> Self {
        let normalizedReorderedIds: [String]? = if let reorderedIds = self.reorderedIds,
                                                   !reorderedIds.isEmpty,
                                                   reorderedIds != originalTrackIds
        {
            reorderedIds
        } else {
            nil
        }

        return Self(
            removals: self.removals,
            reorderedIds: normalizedReorderedIds,
            reasoning: self.reasoning
        )
    }
}
