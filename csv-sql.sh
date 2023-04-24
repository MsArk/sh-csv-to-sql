# File input: csv file
file_name="$1"

# Remove trailing commas
sed 's/\s*,*\s*$//g' "$file_name" > tmp.csv

# Get the first line of the file and create sql file
op=$(echo "$file_name" | cut -d"." -f 1)
opfile="$op.sql"

# Create the table
op="\`$op\`"
# Get the columns
columns=$(head --lines=1 tmp.csv | sed 's/,/`,`/g' | tr -d "\r\n")
# Add backticks
columns="\`$columns\`"
# Tail the file and create the insert statements
tail --lines=+2 tmp.csv | while read l ; do
values=$(echo $l | sed 's/,/\",\"/g' | tr -d "\r\n")
values="\"$values\""
echo "INSERT INTO $op($columns) VALUES ($values);"
done > "$opfile"

# Remove the tmp file
rm tmp.csv
