# Security and Safety

This project parses legacy game files, save data and eventually mod/content packages. Treat all external inputs as untrusted.

## Reporting

For parser, memory-safety or path-handling issues, provide a minimal reproducer when possible and avoid attaching proprietary game data to public reports.

## Project safety rules

- never manipulate Xbox thermal protections or fan controls for presentation effects;
- never intentionally corrupt real profile/save data for narrative effects;
- simulated corruption/system-failure sequences must operate only inside the game's own presentation/state layer;
- file importers must defend against traversal, malformed lengths and endian/overflow errors;
- fuzzing and sanitizer builds belong on host platforms before parsers are trusted on Xbox 360.
