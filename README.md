# Arda

Maps of J. R. R. Tolkien's Middle Earth, using a DEM (Digital Elevation Model) and place name vectors.

[Arda](https://en.wikipedia.org/wiki/Arda_(Tolkien)) was the name of the entire world, which included the realms known as Middle Earth. 


## Goals

- Make colored elevation maps with hillshading and place names
- Use as detailed maps for D&D Adventures in Middle Earth games


## Data

The DEM is stored in a 10k x 10k jpg file, made by users monks and __ on the Outerra Worlds Forum. 

The vector data includes the place names, rivers, forests, mountains - made by monks, __, and maintained by __. 

The entire map covers 2000km on each axis, so the resolution of the DEM is 200m/px. 

The file `data/raster/10K.wld` defines how the DEM corresponds to the map coordinate system as used by the vector data. This is currently slightly off - improvements could be made. 


## Installing

Install [QGIS](https://qgis.org/) or similar GIS program.

Obtain the `10K.jpg` DEM and put in `data/raster` subdirectory.

Build the hillshade layer.


## Todo

- Make name placement, size, and visibility similar to Tolkien's maps - eg ERIADOR as angled line, visibile only at largest scales
- Add river sizes in meters and render widths accordingly
- Make map views for the Hobbit (overview, The Shire, Eriador, Misty Mountains, Mirkwood) - how do?
- Merge with existing shapefile project
- Get access to 40k x 40k DEM (50m/px) version
- Explain QGIS and pull requests for shapefile data in readme
- Post to Outerra forum, Reddit and find people to collaborate on project - r/lotr, r/thehobbit, r/tolkienfans, r/gis, etc
- Make map views for The Lord of the Rings corresponding to travels
- Update/organize placenames - current shapefile includes mountains/regions but as points
- Switch easily between colorful and minimal color versions - how do?
- Render to tiles for Google Maps-like site, using Leaflet - try vector map tiles and mapboxGL? include search index
