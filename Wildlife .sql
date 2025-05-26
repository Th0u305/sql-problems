CREATE TABLE rangers(
    ranger_id int NOT NULL UNIQUE PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    "name" VARCHAR(50) NOT NULL,
    region VARCHAR(30)
);

CREATE Table species (
    species_id int NOT NULL UNIQUE PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(25)
);

CREATE Table sightings (
    sighting_id int NOT NULL UNIQUE PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    species_id INT REFERENCES species(species_id) NOT NULL,
    ranger_id INT REFERENCES rangers(ranger_id) NOT NULL,
    "location" VARCHAR(50) NOT NULL,
    sighting_time TIMESTAMP,
    notes VARCHAR(50)
);

INSERT INTO rangers (name,region) VALUES 
    ('Alice Green', 'Northern Hills'),
    ('Bob White ' ,'River Delta ' ),
    (' Carol King ' ,'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
    ('Snow Leopard' , 'Panthera uncia' , '1775-01-01' ,'Endangered'),      
    ('Bengal Tiger' ,  'Panthera tigris tigris' , '1758-01-01' ,'Endangered'),
    ('Red Panda' , 'Ailurus fulgens' ,  '1825-01-01'  , 'Vulnerable' ),
    ('Asiatic Elephant' , 'Elephas maximus indicus' , '1758-01-01' ,' Endangered');

INSERT INTO sightings (species_id,ranger_id, "location",sighting_time, notes) VALUES
    (1,1,'Peak Ridge ', '2024-05-10 07:45:00', 'Camera trap image captured'),
    (2 ,2 ,'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
    (3,3 ,'Bamboo Grove East', '2024-05-15 09:10:00' ,'Feeding observed'),
    (1 ,2 ,'Snowfall Pass' ,'2024-05-18 18:30:00', '(NULL)' );



INSERT INTO rangers ("name",region) VALUES ( 'Derek Fox', 'Derek Fox');


SELECT COUNT(DISTINCT species_id) AS number_of_unique_species_sighted FROM sightings;


SELECT * FROM sightings WHERE location LIKE '%Pass%'


SELECT 
    name, count(*) as total_sightings 
FROM 
    rangers 
JOIN 
    sightings ON rangers.ranger_id = sightings.ranger_id 
GROUP BY name;


SELECT common_name FROM species WHERE species.species_id NOT IN ( SELECT species_id FROM sightings )


SELECT 
    s.common_name, sg.sighting_time, r.name 
FROM 
    species as s
JOIN 
    sightings as sg ON sg.species_id = s.species_id 
JOIN 
    rangers as r ON r.ranger_id = sg.ranger_id 
ORDER BY 
    sg.sighting_time DESC 
LIMIT 2;


UPDATE species SET  conservation_status = 'Historic' WHERE extract(year from discovery_date) < '1800'


SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning' 
        WHEN EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon' 
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;


DELETE FROM rangers WHERE (rangers.ranger_id NOT IN ( SELECT ranger_id FROM sightings ))