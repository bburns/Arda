# Arda

Maps of J. R. R. Tolkien's Middle Earth, using a DEM (Digital Elevation Model) and place name vectors.

[Arda](https://en.wikipedia.org/wiki/Arda_(Tolkien)) was the name of the entire world, which included the part known as Middle Earth. 

![map](https://raw.githubusercontent.com/bburns/arda/master/renders/lotr-900px.jpg)

![map](https://raw.githubusercontent.com/bburns/arda/master/renders/ettenmoors-900px.jpg)


## Goals

- Make colored elevation maps with hillshading
- Make name placement and size similar to Tolkien's maps
- Use as detailed maps for Adventures in Middle Earth (D&D 5e) games


## Data

The DEM is stored in a 10k x 10k jpg file, made by monks and Redrobes on the [Outerra Worlds Forum](http://worlds.outercraft.com/forum/index.php). 

The vector data includes the place names, rivers, forests, mountains - made by monks, SeerBlue, and Redrobes, and maintained by jvangeld here - https://github.com/jvangeld/ME-GIS. 

The entire map covers 2000km on each axis, so the resolution of the DEM is 200m/px. 

The file `data/rasters/10K.wld` defines how the DEM corresponds to the map coordinate system as used by the vector data. This is currently slightly off - improvements could be made. 


## Installing

Clone this repo

    git clone https://github.com/bburns/arda.git
    cd arda

Clone [ME-GIS](https://github.com/jvangeld/ME-GIS) to the `data/vectors` subdirectory

    git clone https://github.com/jvangeld/ME-GIS data/vectors

Get the Tolkien font here - https://fontzone.net/font-details/tolkien

Install [QGIS](https://qgis.org/)

Open `arda.qgs` in QGIS

Build the hillshade layer - **Raster / Analysis / Hillshade** - enter a z-factor of 100.0 and click Run. Then adjust the global opacity of the layer to 50% - **Layer Styling sidebar / Transparency / Global Opacity**. This builds a ~100MB TIFF file in a temp folder so is not included in the repo. 


## Todo

- Add river sizes in meters and render widths accordingly
- Make map views for the Hobbit (overview, The Shire, Eriador, Misty Mountains, Mirkwood)
- Make map views for The Lord of the Rings corresponding to travels
- Explain QGIS and pull requests for shapefile data in readme
- Switch easily between colorful and minimal color versions - how do?
- Get access to 40k x 40k DEM (50m/px) version
- Render to tiles for Google Maps-like site, using Leaflet - try vector map tiles and mapboxGL? include search index
