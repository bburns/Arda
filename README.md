# Arda

Maps of J. R. R. Tolkien's Middle Earth, using a DEM (Digital Elevation Model) and place name vectors.

[Arda](https://en.wikipedia.org/wiki/Arda_(Tolkien)) was the name of the entire world, which included the part known as Middle Earth. 

![map](https://raw.githubusercontent.com/bburns/arda/master/renders/lotr-900px.jpg)


## Goals

- Make colored elevation maps with hillshading
- Make name placement and size similar to Tolkien's maps
- Make detailed maps to correspond to parts of books
- Use as detailed maps for Adventures in Middle Earth (D&D 5e) games


## Data

The DEM is stored in a 10k x 10k jpg file, made by monks and Redrobes on the [Outerra Worlds Forum](http://worlds.outercraft.com/forum/index.php). 

The vector data includes the place names, rivers, forests, mountains - made by monks and Redrobes, and maintained by jvangeld [here](https://github.com/jvangeld/ME-GIS). 

The entire map covers 2000km on each axis, so the resolution of the DEM is 200m/px. 

The file `data/raster/10K.wld` defines how the DEM corresponds to the map coordinate system as used by the vector data. This is currently slightly off - improvements could be made. 


## Installing

Install [QGIS](https://qgis.org/) or similar GIS program.

Obtain the `10K.jpg` DEM and put in `data/raster` subdirectory.

Build the hillshade layer.


## Todo

- Merge with existing shapefile project
- Update/organize placenames - current shapefile includes mountains/regions but as points - split different types out into separate shapefiles? incl name and fontsizeKm
- Add river sizes in meters and render widths accordingly
- Make map views for the Hobbit (overview, The Shire, Eriador, Misty Mountains, Mirkwood)
- Make map views for The Lord of the Rings corresponding to travels
- Explain QGIS and pull requests for shapefile data in readme
- Switch easily between colorful and minimal color versions - how do?
- Get access to 40k x 40k DEM (50m/px) version
- Render to tiles for Google Maps-like site, using Leaflet - try vector map tiles and mapboxGL? include search index
