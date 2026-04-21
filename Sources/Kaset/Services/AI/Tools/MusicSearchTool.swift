import Foundation

/// A tool that allows the language model to search the YouTube Music catalog.
/// This grounds AI responses in real music data rather than hallucinated song IDs.
@available(macOS 26.0, *)
struct MusicSearchTool {
    /// The YTMusicClient used for API calls.
    private let client: any YTMusicClientProtocol

    /// Logger for debugging.
    private let logger = DiagnosticsLogger.ai

    /// Creates a new MusicSearchTool.
    /// - Parameter client: The YTMusicClient to use for searches.
    init(client: any YTMusicClientProtocol) {
        self.client = client
    }

    /// Performs the search and returns formatted results.
    func search(query: String, filter: String = "all") async throws -> String {
        self.logger.info("MusicSearchTool searching for: \(query)")

        let response = try await client.search(query: query)

        // Format results based on filter
        var results: [String] = []

        let includeAll = filter.isEmpty || filter == "all"

        if includeAll || filter == "songs" {
            let songs = response.songs.prefix(5)
            for song in songs {
                results.append("SONG: \"\(song.title)\" by \(song.artistsDisplay) [videoId: \(song.videoId)]")
            }
        }

        if includeAll || filter == "albums" {
            let albums = response.albums.prefix(3)
            for album in albums {
                results.append("ALBUM: \"\(album.title)\" by \(album.artistsDisplay) [browseId: \(album.id)]")
            }
        }

        if includeAll || filter == "artists" {
            let artists = response.artists.prefix(3)
            for artist in artists {
                results.append("ARTIST: \(artist.name) [channelId: \(artist.id)]")
            }
        }

        if includeAll || filter == "playlists" {
            let playlists = response.playlists.prefix(3)
            for playlist in playlists {
                let author = playlist.author ?? "Unknown"
                results.append("PLAYLIST: \"\(playlist.title)\" by \(author) [playlistId: \(playlist.id)]")
            }
        }

        if results.isEmpty {
            return "No results found for '\(query)'"
        }

        let output = """
        Search results for '\(query)':
        \(results.joined(separator: "\n"))
        """

        self.logger.debug("MusicSearchTool found \(results.count) results")
        return output
    }
}
