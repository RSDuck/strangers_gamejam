import 
    json,

    sdl2

type
    Layer* = object
        width, height: int
        visible: bool
        x, y: int
        `type`: string
        opacity: int
        data: seq[int]
        name: string
    Tileset* = object
        firstgid: int
        source: string
    Map* = object
        width*, height*: int
        nextobjectid: int
        orientation: string
        renderorder: string
        tilewidth, tileheight: int
        `type`: string
        version: string

        layers: seq[Layer]

proc loadMap*(file: string): Map =
    let 
        file = open(file, fmRead)
        input = file.readAll()
    file.close()
    let nodes = parseJson(input)
    result = nodes.to(Map)

proc getTile*(self: Map, x, y, layer: int): int =
      self.layers[layer].data[x + y * self.width]
    

proc drawMap*(self: Map, renderer: sdl2.RendererPtr, scrollX, scrollY, tileswidth: int, tileset: sdl2.TexturePtr, renderInBetween: proc()) =
    for layer in 0..high(self.layers):
        if layer == 2:
            renderInBetween()

        if self.layers[layer].visible:
            for x in 0..self.width - 1:
                for y in 0..self.height - 1:
                    let 
                        tile = self.getTile(x, y, layer) - 1
                    if tile >= 0:
                        var
                            srcRect: Rect = 
                                (cint(tile mod tileswidth * self.tilewidth), cint(tile div tileswidth * self.tileheight), 
                                cint self.tilewidth, cint self.tileheight)
                            dstRect: Rect = 
                                (cint(x * self.tilewidth - scrollX), cint(y * self.tileheight - scrollY), 
                                cint self.tilewidth, cint self.tileheight)

                        renderer.copy(tileset, addr srcRect, addr dstRect)
