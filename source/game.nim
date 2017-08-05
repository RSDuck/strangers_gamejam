import
    sdl2,

    maploader,
    sprite,
    setup

let (window, renderer) = initSetup(title = "Strangers")

mainloop do (event: openArray[sdl2.Event], dt: float):
    renderer.clear()

    renderer.present()

deinitSetup(window, renderer)