
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
roi <- sf::st_as_sf(data.frame(geom="Polygon ((17.66230354052624563 3.67542151541521456, 17.66174846452226888 3.96073058146009194, 17.96648519070638983 3.95073921338848155, 17.9842476228336956 3.66376491933166903, 17.66230354052624563 3.67542151541521456))"), wkt="geom", crs = 4326)
time_range<-as.Date(c("2020-01-01","2020-03-01"))

# get Sentinel 1 products available
s1_products_available <- shr_list_products(collection = "S1-AWS-IW-VVVH", roi = roi, time_range = time_range)
print(str(s1_products_available$properties))
#> 'data.frame':    9 obs. of  7 variables:
#>  $ id            : chr  "S1B_IW_GRDH_1SDV_20200226T043216_20200226T043243_020435_026B82_8DED" "S1A_IW_GRDH_1SDV_20200220T043247_20200220T043316_031331_039AF3_AB08" "S1B_IW_GRDH_1SDV_20200214T043217_20200214T043243_020260_0265E1_B2A0" "S1A_IW_GRDH_1SDV_20200208T043247_20200208T043316_031156_0394EB_A256" ...
#>  $ date          : chr  "2020-02-26" "2020-02-20" "2020-02-14" "2020-02-08" ...
#>  $ time          : chr  "04:32:16" "04:32:47" "04:32:17" "04:32:47" ...
#>  $ path          : chr  "s3://sentinel-s1-l1c/GRD/2020/2/26/IW/DV/S1B_IW_GRDH_1SDV_20200226T043216_20200226T043243_020435_026B82_8DED" "s3://sentinel-s1-l1c/GRD/2020/2/20/IW/DV/S1A_IW_GRDH_1SDV_20200220T043247_20200220T043316_031331_039AF3_AB08" "s3://sentinel-s1-l1c/GRD/2020/2/14/IW/DV/S1B_IW_GRDH_1SDV_20200214T043217_20200214T043243_020260_0265E1_B2A0" "s3://sentinel-s1-l1c/GRD/2020/2/8/IW/DV/S1A_IW_GRDH_1SDV_20200208T043247_20200208T043316_031156_0394EB_A256" ...
#>  $ crs           : chr  "EPSG:32633" "EPSG:32633" "EPSG:32633" "EPSG:32633" ...
#>  $ mbr           : chr  "696495.77247,317995.746383 975389.828543,532652.020966" "705863.646809,364849.631492 988486.764529,595514.76631" "696460.717442,318005.69774 975354.655982,532654.689433" "705828.198821,364840.241792 988455.822025,595531.693961" ...
#>  $ orbitDirection: chr  "DESCENDING" "DESCENDING" "DESCENDING" "DESCENDING" ...
#> NULL

# get Sentinel 2 L2A products available
s2l2a_products_available <- shr_list_products(collection = "S2L2A", roi = roi, time_range = time_range)
print(str(s2l2a_products_available$properties))
#> 'data.frame':    24 obs. of  7 variables:
#>  $ id                  : chr  "S2A_OPER_MSI_L2A_TL_EPA__20200304T161004_A024457_T33NYE_N02.14" "S2A_OPER_MSI_L2A_TL_EPA__20200304T161004_A024457_T33NZE_N02.14" "S2B_OPER_MSI_L2A_TL_EPAE_20200222T125024_A015477_T33NYE_N02.14" "S2B_OPER_MSI_L2A_TL_EPAE_20200222T125024_A015477_T33NZE_N02.14" ...
#>  $ date                : chr  "2020-02-27" "2020-02-27" "2020-02-22" "2020-02-22" ...
#>  $ time                : chr  "09:19:24" "09:19:21" "09:19:25" "09:19:22" ...
#>  $ path                : chr  "s3://sentinel-s2-l2a/tiles/33/N/YE/2020/2/27/0" "s3://sentinel-s2-l2a/tiles/33/N/ZE/2020/2/27/0" "s3://sentinel-s2-l2a/tiles/33/N/YE/2020/2/22/0" "s3://sentinel-s2-l2a/tiles/33/N/ZE/2020/2/22/0" ...
#>  $ crs                 : chr  "EPSG:32633" "EPSG:32633" "EPSG:32633" "EPSG:32633" ...
#>  $ mbr                 : chr  "699960,390240 809760,500040" "799980,390240 909780,500040" "699960,390240 809760,500040" "799980,390240 909780,500040" ...
#>  $ cloudCoverPercentage: num  80 68.3 65.9 31.8 19.2 ...
#> NULL

# get URLs for Sentinel 1 products for the bands VV and VH
#s1_urls <- shr_get_url(collection = "S1-AWS-IW-VVVH", variables = c("VV","VH"), roi = roi, time_range = time_range)
#print(str(s1_urls))

# get URLs for Sentinel 2 products for the bands B04, B08, B08A, B11, 9_SCENE_CLASSIFICATION
s2l2a_urls <- shr_get_url(collection = "S2L2A", variables = c("B04","B08","B8A","B11","9_SCENE_CLASSIFICATION"), roi = roi, time_range = time_range, cloud_cover_max = 30)
print(str(s2l2a_urls))
#> 'data.frame':    160 obs. of  4 variables:
#>  $ name      : chr  "S2L2A_20200217_9_SCENE_CLASSIFICATION__p1" "S2L2A_20200217_9_SCENE_CLASSIFICATION__p2" "S2L2A_20200217_9_SCENE_CLASSIFICATION__p3" "S2L2A_20200217_9_SCENE_CLASSIFICATION__p4" ...
#>  $ time_start: chr  "2020-02-17" "2020-02-17" "2020-02-17" "2020-02-17" ...
#>  $ destfile  : chr  "S2L2A/S2L2A_20200217_9_SCENE_CLASSIFICATION__p1.tif" "S2L2A/S2L2A_20200217_9_SCENE_CLASSIFICATION__p2.tif" "S2L2A/S2L2A_20200217_9_SCENE_CLASSIFICATION__p3.tif" "S2L2A/S2L2A_20200217_9_SCENE_CLASSIFICATION__p4.tif" ...
#>  $ url       : chr  "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ "https://services.sentinel-hub.com/ogc/wms/26fc2e12-219a-42eb-9dde-f9f0287a7823?version=1.1.1&service=WMS&reques"| __truncated__ ...
#> NULL
```
