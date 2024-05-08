
Design:

Game: Everything
  - Asset Manager
    - Title and code assets for quick use.
    - Textures
    - Sounds
    - Music
    - Palettes
    - Fonts
State: Gameplay/Menu state that contains machines via a single Group
Group: Contains Machines and other Groups
Machines: Contains Parts
Parts: Basic building blocks of the game world
 - Types
   - Position
   - Rectangle
   - Circle
   - Sprite
   - Sound
   - Timer
   - Action
     - Takes multiple inputs and a callback
     - Provide behavior when triggered
     - Provide interface for custom trigger parameters
