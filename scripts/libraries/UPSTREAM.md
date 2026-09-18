# Bundled library updates

The Forever port uses these pinned upstream snapshots. Only the libraries loaded by `scripts/embeds.xml` and their dependencies are retained; upstream Lua code is unchanged.

* Ace3 (including its embedded ChatThrottleLib, CallbackHandler and LibStub): [WoWUIDev/Ace3, 1e98fc0](https://github.com/WoWUIDev/Ace3/tree/1e98fc00874779334d7a3f0cb399c7ae9a15fead). Includes Forever character database keys, current settings widgets, and chat API compatibility. License: `Ace3-LICENSE.txt`.
* HereBeDragons core and pins: [Nevcairiel/HereBeDragons, 0547c95](https://github.com/Nevcairiel/HereBeDragons/tree/0547c95f1831f7c68acf3bd29a3c587ca20ce9b7). The obsolete map migration library and duplicate LibStub/CallbackHandler copies are omitted. Its TOC targets Forever and refers to shared dependencies. Upstream declares BSD licensing in its TOC.

Other bundled libraries retain their existing versions.
