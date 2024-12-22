#!/bin/bash
PSQL="psql --username=emd --dbname=periodic_table --no-align --tuples-only -c";

# 1.1 remove element with atomic_number=1000 from properties;
resp=$($PSQL "DELETE FROM properties WHERE atomic_number=1000");
echo "cleanup 1.1: $resp";

# 1.2 remove element with atomic_number=1000 from properties;
resp=$($PSQL "DELETE FROM elements WHERE atomic_number=1000");
echo "cleanup 1.2: $resp";

# 2 remove properties.type column
resp=$($PSQL "ALTER TABLE properties DROP COLUMN type");
echo "cleanup 2: $resp";

echo -e "\nCLEANUP DB -- DONE\n"