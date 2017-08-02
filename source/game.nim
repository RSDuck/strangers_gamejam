import nico

proc gameInit() = 
    echo "init"
    nico.loadPaletteFromGPL("palette.gpl")
    nico.loadSpriteSheet("spritesheet.png")

proc gameUpdate(dt: float) =
     discard

proc gameDraw() =
    cls()
    setColor(7)
    print("hello world", 42, 60)

    nico.spr(38, 0, 0, 2, 2)
    nico.spr(64, 0, 0, 2, 4)

nico.init("impbox", "stranger_jam")

nico.createWindow("stranger_jam", 128, 128, 4)
nico.run(gameInit, gameUpdate, gameDraw)
