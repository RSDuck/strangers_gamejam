import 
    sdl2,
    sdl2/image,

    json,
    os,
    math

proc loadTexture*(renderer: RendererPtr, file: string): (TexturePtr, int, int) =
    let surface = load(file)

    result[0] = createTextureFromSurface(renderer, surface)
    result[1] = surface.w
    result[2] = surface.h

    destroy surface


type Sprite* = object
    sprite: sdl2.TexturePtr
    frame*: int
    timer: uint32
    sheetWidth, sheetHeight: int
    frameWidth, frameHeight: int
    frameDuration: uint32
    x*, y*: float32
    running*: bool
    flip*: bool

proc loadSprite*(renderer: RendererPtr, file: string): Sprite =
    let 
        jsonFile = open(file, fmRead)
        jsonText = jsonFile.readAll()
    jsonFile.close()

    let 
        jsonData = parseJson(jsonText)
        frames = jsonData["frames"]
    for subnode in pairs(frames):
        let 
            filename = file.splitFile[0].joinPath(file.splitFile[1]) & ".png"
            texture = loadTexture(renderer, filename)
        
        result.sprite = texture[0]
        result.frameWidth = int subnode.val["frame"]["w"].num
        result.frameHeight = int subnode.val["frame"]["h"].num
        result.sheetWidth = texture[1]
        result.sheetHeight = texture[2]
        result.frameDuration = uint32 subnode.val["duration"].num
        result.running = true

        break

proc drawAndUpdate*(self: var Sprite, renderer: RendererPtr, dt: uint32, camX, camY: int) =
    if self.running:
        self.timer += dt
        
    if self.timer >= self.frameDuration:
        self.frame = (self.frame + 1) mod (self.sheetWidth div self.frameWidth)
        
        self.timer = 0
    
    var
        srcRect: Rect = (
            cint(self.frame * self.frameWidth), cint 0,
            cint(self.frameWidth), cint(self.frameHeight))
        dstRect: Rect = (
            cint(int(round(self.x)) - camX), cint(int(round(self.y)) - camY),
            cint self.frameWidth, cint self.frameHeight)

    renderer.copyEx(self.sprite, addr srcRect, addr dstRect, 0.0, nil, SDL_FLIP_HORIZONTAL * cint(self.flip))