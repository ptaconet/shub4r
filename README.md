
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shub4r

<!-- badges: start -->

<!-- badges: end -->

This package is a small personal interface to the [Sentinel Hub OGC web
services](https://sentinel-hub.com/develop/capabilities/wms). It is far
from being a full implementation of the possibilites offered by these
web services.

See doc here : <https://sentinel-hub.com/develop/capabilities/wms>

  - wms server :
    [http://services.sentinel-hub.com/ogc/wms/{INSTANCE\_ID}](http://services.sentinel-hub.com/ogc/wms/%7BINSTANCE_ID%7D)
  - wfs server :
    [http://services.sentinel-hub.com/ogc/wfs/{INSTANCE\_ID}](http://services.sentinel-hub.com/ogc/wfs/%7BINSTANCE_ID%7D)

Example :

``` r
require(shub4r)
#> Loading required package: shub4r
require(sf)
#> Loading required package: sf
#> Linking to GEOS 3.7.0, GDAL 2.3.2, PROJ 5.2.0

# login
instance_id_s1 <- Sys.getenv("instance_id_shub_s1")
instance_id_s2 <- Sys.getenv("instance_id_shub_s2")

shr_login(instance_id_s1,source = "sentinel1")
#> Successfull login to sentinel1
shr_login(instance_id_s2,source = "sentinel2")
#> Successfull login to sentinel2

# set up roi and time range
roi <- sf::st_as_sf(data.frame(geom="POLYGON ((-5.82 9.54, -5.42 9.55, -5.41 8.84, -5.81 8.84, -5.82 9.54))"), wkt="geom", crs = 4326)
time_range<-as.Date(c("2017-01-01","2017-01-30"))

# get Sentinel 1 products available
s1_products_available <- shr_list_products(collection = "S1-AWS-IW-VVVH", roi = roi, time_range = time_range)
print(str(s1_products_available$properties))
#> 'data.frame':    2 obs. of  7 variables:
#>  $ id            : chr  "S1A_IW_GRDH_1SDV_20170130T183503_20170130T183528_015065_0189E7_CB95" "S1A_IW_GRDH_1SDV_20170106T183504_20170106T183529_014715_017F22_45FB"
#>  $ date          : chr  "2017-01-30" "2017-01-06"
#>  $ time          : chr  "18:35:03" "18:35:04"
#>  $ path          : chr  "s3://sentinel-s1-l1c/GRD/2017/1/30/IW/DV/S1A_IW_GRDH_1SDV_20170130T183503_20170130T183528_015065_0189E7_CB95" "s3://sentinel-s1-l1c/GRD/2017/1/6/IW/DV/S1A_IW_GRDH_1SDV_20170106T183504_20170106T183529_014715_017F22_45FB"
#>  $ crs           : chr  "EPSG:32630" "EPSG:32630"
#>  $ mbr           : chr  "98667.743906,878959.615968 377404.813884,1094474.132735" "98731.309492,878965.386308 377470.070066,1094482.55275"
#>  $ orbitDirection: chr  "ASCENDING" "ASCENDING"
#> NULL

# get Sentinel 2 L2A products available
s2l2a_products_available <- shr_list_products(collection = "S2L2A", roi = roi, time_range = time_range)
print(str(s2l2a_products_available$properties))
#> 'data.frame':    14 obs. of  7 variables:
#>  $ id                  : chr  "S2A_OPER_MSI_L2A_TL_SHIT_20191122T060727_A008156_T29PRL_N00.01" "S2A_OPER_MSI_L2A_TL_SHIT_20191122T060743_A008156_T29PRK_N00.01" "S2A_OPER_MSI_L2A_TL_SHIT_20201101T233908_A008156_T29PRK_N00.01" "S2A_OPER_MSI_L2A_TL_SHIT_20191122T060802_A008156_T30PTQ_N00.01" ...
#>  $ date                : chr  "2017-01-13" "2017-01-13" "2017-01-13" "2017-01-13" ...
#>  $ time                : chr  "10:55:56" "10:55:56" "10:55:56" "10:55:56" ...
#>  $ path                : chr  "s3://sentinel-s2-l2a/tiles/29/P/RL/2017/1/13/0" "s3://sentinel-s2-l2a/tiles/29/P/RK/2017/1/13/0" "s3://sentinel-s2-l2a/tiles/29/P/RK/2017/1/13/0" "s3://sentinel-s2-l2a/tiles/30/P/TQ/2017/1/13/0" ...
#>  $ crs                 : chr  "EPSG:32629" "EPSG:32629" "EPSG:32629" "EPSG:32630" ...
#>  $ mbr                 : chr  "799980,990240 909780,1100040" "799980,890220 909780,1000020" "799980,890220 909780,1000020" "199980,890220 309780,1000020" ...
#>  $ cloudCoverPercentage: num  32 79 79 76.5 54.5 ...
#> NULL

# get URLs for Sentinel 1 products for the bands VV and VH
s1_urls <- shr_get_url(collection = "S1-AWS-IW-VVVH", variables = c("VV","VH"), roi = roi, time_range = time_range)
print(str(s1_urls))
#> 'data.frame':    32 obs. of  4 variables:
#>  $ name      : chr  "S1-AWS-IW-VVVH_20170130_VH__p1" "S1-AWS-IW-VVVH_20170130_VH__p2" "S1-AWS-IW-VVVH_20170130_VH__p3" "S1-AWS-IW-VVVH_20170130_VH__p4" ...
#>  $ time_start: chr  "2017-01-30" "2017-01-30" "2017-01-30" "2017-01-30" ...
#>  $ destfile  : chr  "S1-AWS-IW-VVVH/S1-AWS-IW-VVVH_20170130_VH__p1.tif" "S1-AWS-IW-VVVH/S1-AWS-IW-VVVH_20170130_VH__p2.tif" "S1-AWS-IW-VVVH/S1-AWS-IW-VVVH_20170130_VH__p3.tif" "S1-AWS-IW-VVVH/S1-AWS-IW-VVVH_20170130_VH__p4.tif" ...
#>  $ url       : chr  "https://services.sentinel-hub.com/ogc/wms/bfbfc449-320a-4a56-b493-61c9d4fc67e8?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/bfbfc449-320a-4a56-b493-61c9d4fc67e8?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/bfbfc449-320a-4a56-b493-61c9d4fc67e8?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/bfbfc449-320a-4a56-b493-61c9d4fc67e8?version=1.1.1&service=WMS&reques"| __truncated__ ...
#> NULL

# get URLs for Sentinel 2 products for the bands B04, B08, B08A, B11, 9_SCENE_CLASSIFICATION
s2l2a_urls <- shr_get_url(collection = "S2L2A", variables = c("B04","B08","B8A","B11","9_SCENE_CLASSIFICATION"), roi = roi, time_range = time_range)
print(str(s2l2a_urls))
#> 'data.frame':    80 obs. of  4 variables:
#>  $ name      : chr  "S2L2A_20170113_9_SCENE_CLASSIFICATION__p1" "S2L2A_20170113_9_SCENE_CLASSIFICATION__p2" "S2L2A_20170113_9_SCENE_CLASSIFICATION__p3" "S2L2A_20170113_9_SCENE_CLASSIFICATION__p4" ...
#>  $ time_start: chr  "2017-01-13" "2017-01-13" "2017-01-13" "2017-01-13" ...
#>  $ destfile  : chr  "S2L2A/S2L2A_20170113_9_SCENE_CLASSIFICATION__p1.tif" "S2L2A/S2L2A_20170113_9_SCENE_CLASSIFICATION__p2.tif" "S2L2A/S2L2A_20170113_9_SCENE_CLASSIFICATION__p3.tif" "S2L2A/S2L2A_20170113_9_SCENE_CLASSIFICATION__p4.tif" ...
#>  $ url       : chr  "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ ...
#> NULL

# download
#httr::GET(s2l2a_urls$url[1],write_disk(s2l2a_urls$destfile[1]),progress(),config = list(maxredirs=-1))
```
