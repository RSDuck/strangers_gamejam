import nico

proc gameInit() = 
    echo "init"
    nico.loadPaletteFromGPL("palette.gpl")
    nico.loadSpriteSheet("spritesheet.png")
    nico.loadMusic(0, "Strangers_United.ogg")
    nico.musicVol(50)
    nico.music(0)
    

proc gameUpdate(dt: float) =
    discard

proc gameDraw() =
    cls()
    music(0)
    nico.spr(38, 100, 100, 2, 2)
    nico.spr(64, 0, 0, 2, 4)

nico.init("impbox", "stranger_jam")

nico.createWindow("stranger_jam", 128, 128, 4)
nico.run(gameInit, gameUpdate, gameDraw)
