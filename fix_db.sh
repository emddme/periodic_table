#!/bin/bash
PSQL="psql --username=emd --dbname=periodic_table --no-align --tuples-only -c";

#1. Rename properties.weight to properties.atomic_mass;
resp=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass");
echo "fix 1: $resp"

#2. Rename properties.melting_point to properties.melting_point_celsius and set NOT NULL constraint;
resp=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius");
echo "fix 2.1: $resp";
resp=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL");
echo "fix 2.2: $resp";

#3. Rename propertes.boiling_point to properties.boiling_point_celsius and set NOT NULL constraint;
resp=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius");
echo "fix 3.1: $resp";
resp=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL");
echo "fix 3.2: $resp";

#4. Set UNIQUE and NOT NULL constraints to elements.name and elements.symbol;
resp=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL");
echo "fix 4.1: $resp";
resp=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL");
echo "fix 4.2: $resp";
resp=$($PSQL "ALTER TABLE elements ADD CONSTRAINT elements_name_unique UNIQUE(name)");
echo "fix 4.3: $resp";
resp=$($PSQL "ALTER TABLE elements ADD CONSTRAINT elements_symbol_unique UNIQUE(symbol)");
echo "fix 4.4: $resp";

#5. Set foreign key properties.atomic_number ref elements.atomic_number;
resp=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number)");
echo "fix 5: $resp";

#6. Create table types(type_id int primary key, type varchar not null);
resp=$($PSQL "CREATE TABLE types(type_id INT PRIMARY KEY, type VARCHAR(20) NOT NULL)");
echo "fix 6: $resp";

#7. Add three rows to types (see properties);
unique_types=($($PSQL "SELECT DISTINCT type FROM properties"));
for (( i = 0; i < ${#unique_types[@]}; i++ ))
    do
        type=${unique_types[i]};
        resp=$($PSQL "INSERT INTO types VALUES($i, '$type')");
        echo "fix 7.$i: $resp"; 
done

#8.1 Add column: properties.type_id INT REFS -> types.type_id;
resp=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id)");
echo "fix 8.1: $resp";

#8.2 Fill column properties.type_id
type_ids=($($PSQL "SELECT type_id FROM types"));
types=($($PSQL "SELECT type FROM types"));
for (( i = 0; i < ${#type_ids[@]}; i++ ))
    do
        type_id=${type_ids[i]};
        type=${types[i]};
        resp=$($PSQL "UPDATE properties SET type_id=$type_id WHERE type='$type'");
        echo "fix 8.2.$i: $resp";
done

#8.3 Add constraint NOT NULL to column properties.type_id
resp=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL");
echo "fix 8.3: $resp";

#9 Capitalize all first letters of symbol values in elements table;
symbols=($($PSQL "SELECT symbol FROM elements"));
for (( i = 0; i < ${#symbols[@]}; i++ ))
    do
        symbol=${symbols[i]};
        symbol_capt="$(tr '[:lower:]' '[:upper:]' <<< ${symbol:0:1})${symbol:1}"
        resp=$($PSQL "UPDATE elements SET symbol='$symbol_capt' WHERE symbol='$symbol'");
        echo "fix 9.$i: $resp";
done

#10.1 Change properties.atomic_mass to data type DECIMAL
resp=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL");
echo "fix 10.1: $resp";

#10.2 Adjust properties.atomic_mass values: eliminate trailing zeroes after decimal point (see atomic_mass.txt);
atomic_mass_arr=($($PSQL "SELECT atomic_mass FROM properties"));
for (( i = 0; i < ${#atomic_mass_arr[@]}; i++ ))
    do
        atomic_mass=${atomic_mass_arr[i]};
        atomic_mass_clipped=$(echo $atomic_mass | sed -E 's/0+$//');
        resp=$($PSQL "UPDATE properties SET atomic_mass=$atomic_mass_clipped WHERE atomic_mass=$atomic_mass");
        echo "fix 10.2.$i: $resp";
done

#11.1 Add element Fluorine: atomic_number=9, name='Fluorine', symbol='F';
resp=$($PSQL "INSERT INTO elements(atomic_number, name, symbol) VALUES(9, 'Fluorine', 'F')");
echo "fix 11.1: $resp"

#11.2 Add properties Fluorine: atomic_mass=18.998, melting_point_celsius=-220, boiling_point_celsius=-188.1, type='nonmetal';
resp=$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type, type_id) VALUES(9, 18.998, -220, -188.1, 'nonmetal', 2)");
echo "fix 11.2: $resp"

#12.1 Add element Neon: atomic_number=10, name='Neon', symbol='Ne'
resp=$($PSQL "INSERT INTO elements(atomic_number, name, symbol) VALUES(10, 'Neon', 'Ne')");
echo "fix 12.1: $resp"

#12.2 Add properties Neon: atomic_mass=20.18, melting_point_celsius=248.6, boiling_point_celsius=246.1, type='nonmetal';
resp=$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type, type_id) VALUES(10, 20.18, -248.6, -246.1, 'nonmetal', 2)");
echo "fix 12.2: $resp"

echo -e "\nFIX DB -- DONE\n"