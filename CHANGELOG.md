# Changelog

## [2026-10-15]

### Changed
- Engine: Zig 0.14.1 → 0.17.0 (latest stable; Zig has no LTS track)
- `server.zig` ported to the new Zig I/O API: `main` takes `std.process.Init`, networking moved from `std.net` to `std.Io.net`, `GeneralPurposeAllocator` removed in favour of the provided environment map
- README normalized to the Clever Cloud example format

### Added
- `.gitignore` for the build output and the Clever Cloud link file
- `.last-checked` maintenance stamp

### Notes
- No third-party dependencies (standard library only)
- Zig 0.17.0 was released on 2026-10-01, exactly 14 days before this update
