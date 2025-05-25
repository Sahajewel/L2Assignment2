
--  Create Rangers Table //
create table rangers (
    ranger_id SERIAL PRIMARY KEY,
     name VARCHAR(50),
      region VARCHAR(100)
    );

-- insert rengers table //

insert into rangers(name, region)
 VALUES
        ('Alice Green', 'Northern Hills'),
        ('Bob Whitte', 'River Delta'),
        ('Carol King', 'Mountain Range');
    

    -- create species table //

create table species (
    species_id SERIAL PRIMARY key,
    common_name VARCHAR(50),
    scientific_name  VARCHAR(150),
    discovery_date date,
    conservation_status VARCHAR(50)
);

-- insert species table //

INSERT into species (common_name, scientific_name,discovery_date, conservation_status)
VALUES
            ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
            ('Bengal Tiger', 'Panthera tigris', '1758-01-01', 'Endangered'),
            ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
            ('Asiatic Elephant', 'Elephas maximus indicus', '1778-01-01', 'Endangered');



-- create sighting table //

create table sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    location VARCHAR(100),
    sighting_time TIMESTAMP,
    notes TEXT
);


-- insert sightings table //

INSERT into sightings(species_id, ranger_id, location, sighting_time, notes)
VALUES
(1,1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2,2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3,3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1,2, 'Snowfall pass', '2024-05-18 18:30:00', NULL);



---------------------------- problem 1 ----------------------------------
--  Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains';

INSERT into rangers(NAME,region) 
VALUES
        ('Derek Fox', 'Coastal Plains');
      
      

---------------------------- problem 2 ----------------------------------
--  Count unique species ever sighted.

SELECT count(DISTINCT species_id) as unique_species_count from species;

---------------------------- problem 3 ----------------------------------
--  Find all sightings where the location includes "Pass".

SELECT * FROM sightings
WHERE location  iLIKE  '%pass%';

---------------------------- problem 4 ----------------------------------
-- List each ranger's name and their total number of sightings.
SELECT name, count(sightings.sighting_id) as total_sightings  FROM rangers
JOIN  sightings on  rangers.ranger_id = sightings.ranger_id
GROUP BY rangers.name
ORDER BY rangers.name;

---------------------------- problem 5 ----------------------------------
-- List species that have never been sighted.
SELECT species.common_name FROM species
WHERE species_id not in (
    SELECT DISTINCT species_id FROM sightings);
    SELECT * FROM sightings;


---------------------------- problem 6 ----------------------------------
--  Show the most recent 2 sightings.
SELECT species.common_name, sightings.sighting_time, rangers.name
 from sightings
 JOIN species ON sightings.species_id = species.species_id
 JOIN rangers ON sightings.ranger_id = rangers.ranger_id
 ORDER BY sightings.sighting_time desc
 LIMIT 2;

 ---------------------------- problem 7 ----------------------------------
-- Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
set conservation_status = 'Historic'
WHERE extract(YEAR from discovery_date) < 1800
;

 ---------------------------- problem 8 ----------------------------------
--  Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

 SELECT sighting_id,
 CASE 
    WHEN extract(HOUR from sighting_time) < 12 THEN  'Morning'
    when extract(hour FROM sighting_time) BETWEEN 12 and 17 then 'Evening'
    ELSE  'Evening'
 END as time_of_day
  from sightings;

   ---------------------------- problem 9 ----------------------------------
--  Delete rangers who have never sighted any species.
   
   
   DELETE FROM rangers
   WHERE ranger_id not in(
    SELECT DISTINCT ranger_id FROM sightings
   );