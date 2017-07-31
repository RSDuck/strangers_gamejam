import nico

proc gameInit() = 
    echo "init"

proc gameUpdate(dt: float) =
     discard

proc gameDraw() =
    cls()
    setColor(7)
    print("hello world", 42, 60)

nico.init("impbox", "stranger_jam")

nico.createWindow("stranger_jam", 128, 128, 4)
nico.run(gameInit, gameUpdate, gameDraw)
