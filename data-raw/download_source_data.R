### Script to download the raw data from Census NZ
### Matt Lie
### Last updated: 19 Mar 2020

# Download Census Data ----------------------------------------------------

download_dir = './data-raw/downloads'
census_url = 'https://www3.stats.govt.nz/SA1Dataset12mar/Statistical%20Area%201%20dataset%20for%20Census%202018%20-%20total%20New%20Zealand%20-%20CSV_updated_12-3-20.zip'
census_zip = paste0(download_dir, '/nz-census-2018.zip')

if (!dir.exists(download_dir)) {
  dir.create(download_dir)
}

download.file(url = census_url, destfile = census_zip, mode = 'wb')
unzip(zipfile = census_zip, exdir = download_dir)
file.remove(census_zip)


