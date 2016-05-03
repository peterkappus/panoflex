#a helper script to download the latest OKR sample spreadsheet from Google docs
#https://docs.google.com/spreadsheets/d/<DOCUMENT_KEY_GOES_HERE>/
curl -o okr_sample_import.csv https://docs.google.com/spreadsheets/d/<DOCUMENT_KEY_GOES_HERE>/export?format=csv&gid=0
