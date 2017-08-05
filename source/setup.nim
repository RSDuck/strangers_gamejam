import sdl2

proc initSetup*(width = 1024, height = 576, title = ""): (WindowPtr, RendererPtr) =
    sdl2.init(INIT_EVERYTHING)

    result[0] = createWindow(title,
        cint SDL_WINDOWPOS_CENTERED, cint SDL_WINDOWPOS_CENTERED,
        cint width, cint height,
        SDL_WINDOW_SHOWN)
    result[1] = createRenderer(result[0], -1, Renderer_Accelerated or Renderer_PresentVsync)

proc deinitSetup*(window: WindowPtr, renderer: RendererPtr) =
    destroy renderer
    destroy window

    sdl2.quit()

var keysdown: array[ord SDL_NUM_SCANCODES, bool]

proc isKeyDown*(scancode: Scancode): bool = keysdown[scancode.ord]

proc mainloop*(loop: proc(events: openArray[sdl2.Event], dt: float)) =
    var 
        running = true
        currentEvent = sdl2.Event(kind: QuitEvent)
        eventList = newSeqOfCap[sdl2.Event](10)
        lastTime = getTicks()
    while running:
        eventList.setLen(0)
        while sdl2.pollEvent(currentEvent):
            if currentEvent.kind == QuitEvent:
                running = false
            elif currentEvent.kind == KeyDown:
                keysdown[currentEvent.key.keysym.scancode.ord] = true
            elif currentEvent.kind == KeyUp:
                keysdown[currentEvent.key.keysym.scancode.ord] = false
            eventList.add(currentEvent)
        
        let currentTime = getTicks()
        let dt = currentTime - lastTime
        lastTime = currentTime

        loop(eventList, float(dt) / 1000)
