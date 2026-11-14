<div align="center">

<img src="docs/graphic.png" alt="Voquill Logo" width="400" />

[![Discord](https://img.shields.io/discord/1454230702106345514?logo=discord&label=Discord&color=5865F2)](https://discord.gg/5jXkDvdVdt)

# Your keyboard is holding you back.

### Make voice your new keyboard. Type four times faster by using your voice.

<br/>

**[Visit our website →](https://voquill.com)**

<br/>
<br/>

**Dictation**

<img src="docs/demo.gif" alt="Voquill Demo" width="600" style="border-radius: 12px;" />

<br/>
<br/>

**Assistant**

<img src="docs/assistant.gif" alt="Voquill Assistant" width="600" style="border-radius: 12px;" />

</div>
</br>

Voquill is an open-source, cross-platform AI voice typing app that lets you dictate into any desktop application, clean the transcript with AI, and keep your personal glossary in sync. The repository contains the desktop and mobile apps, documentation site, enterprise services, CLI, and shared packages.

## Fedora 45 build (this fork)

The upstream Linux packages do not start on Fedora 45: they need `libxdo.so.3`, and Fedora 45 ships `libxdo.so.4`. This fork rebuilds the unchanged app on Fedora 45, including the Vulkan GPU transcription sidecar.

**Install:** download the RPM from [Releases](../../releases), then:

```bash
sudo dnf install ./voquill-desktop-*.rpm
```

**Build it yourself** on Fedora 45 (needs Node, pnpm and Rust):

```bash
sudo dnf install -y jq clang21-libs
VOQUILL_ENABLE_GPU=1 ./apps/desktop/scripts/setup-linux.sh
./apps/desktop/scripts/build-fedora-rpm.sh 0.0.653
```

The same build runs on GitHub through the `Build Fedora RPM` workflow.

Things to know:

- This is an unofficial, unsigned build. In-app auto-update does not work; install a newer RPM from Releases instead.
- Sign-in and cloud features still use the original Voquill services, which this fork does not control. Local transcription does not depend on them.

## Highlights

- Voice input everywhere: overlay, hotkeys, and system integrations work across macOS, Windows, and Linux.
- Choose your engine: run Whisper locally (with optional GPU acceleration) or point to a cloud provider of your choice.
- AI text cleanup: remove filler words and false starts automatically.
- Personal dictionary: create glossary terms and replacement rules so recurring names and phrases stay accurate.
- Batteries included: Tauri auto-updates, enterprise services, and shared utilities and types.
- Privacy first: You have full control over your data. Run Voquill against any backend you wish, even offline.

## Screenshots

|                                                                                                                           |                                            |
| ------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| **Home** — Track your streaks, words per minute, and recent transcriptions at a glance.                                   | ![Home](docs/home-page.png)                |
| **History** — Browse and replay past transcriptions with full audio playback.                                             | ![History](docs/history.png)               |
| **Writing Styles** — Switch between tones like Polished, Verbatim, and Chat to control how your voice sounds on the page. | ![Writing Styles](docs/writing-styles.png) |
| **Dictionary** — Add custom terms and replacement rules so Voquill always spells your words correctly.                    | ![Dictionary](docs/dictionary.png)         |
| **Providers** — Bring your own API key and choose your preferred transcription and post-processing provider.              | ![Providers](docs/providers.png)           |
| **Chats** — Have voice-powered conversations with an AI assistant directly inside Voquill.                                | ![Chats](docs/chats-page.png)              |

## License

Unless otherwise noted, Voquill is released under the AGPLv3. See `LICENCE` for the complete terms and third-party attributions.

## Contributing

See [docs/getting-started.md](docs/getting-started.md) for setup instructions and architecture details.

We love our community! Thank you to everyone who has contributed to Voquill!

<a href="https://github.com/voquill/voquill/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=voquill/voquill" />
</a>
