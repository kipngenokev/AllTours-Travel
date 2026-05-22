-- =====================================================================
-- All-Tours — Kenya attractions seed
-- Run AFTER schema.sql. Safe to re-run: it replaces only the Kenya rows.
--
-- Each place is tagged with one or more experience `categories`, which power
-- the "Explore Kenya by experience" browse:
--   wildlife · coast · culture · nganya · hot-springs · lakes-rivers · mountains
--
-- Images use picsum.photos seeds so the app renders out-of-the-box. Swap
-- cover_image_url / place_media.url for real photos for production.
-- =====================================================================

-- Replace just the Kenya catalogue (place_media cascades on delete).
delete from public.places where country = 'Kenya';

with seeded as (
  insert into public.places
    (name, country, continent, hemisphere, summary, description, guidelines,
     best_months, cover_image_url, latitude, longitude, tags, categories, rating)
  values

  -- ---------------- WILDLIFE & SAFARI ----------------
  ('Maasai Mara National Reserve', 'Kenya', 'Africa', 'S',
   'Kenya''s flagship safari and the Great Migration.',
   'The Mara''s rolling savannah teems with lions, elephants, cheetahs and, from July to October, the wildebeest migration crossing the Mara River. Maasai communities border and co-manage much of the ecosystem.',
   'Book a licensed operator or reputable camp. July–October is peak migration — reserve early. Keep a safe distance from wildlife and follow your guide. Conservancy fees support local Maasai.',
   '{7,8,9,10,1,2}', 'https://picsum.photos/seed/maasaimara/1200/800',
   -1.5061, 35.1432, '{safari,migration,bigfive}', '{wildlife,migration,culture}', 4.9),

  ('Amboseli National Park', 'Kenya', 'Africa', 'S',
   'Great elephant herds beneath Mount Kilimanjaro.',
   'Amboseli is famous for large, relaxed elephant families framed by snow-capped Kilimanjaro across the Tanzanian border. Its swamps draw plentiful birds and plains game.',
   'Mornings give the clearest Kilimanjaro views before cloud builds. Dusty roads — bring a scarf. Respect Maasai land outside the park gates.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/amboseli/1200/800',
   -2.6527, 37.2606, '{safari,elephants,kilimanjaro}', '{wildlife}', 4.8),

  ('Tsavo East & West National Parks', 'Kenya', 'Africa', 'S',
   'Kenya''s largest wilderness — red elephants and lava.',
   'Together Tsavo East and West form one of the world''s biggest protected areas: dust-red elephants, the Mzima Springs, Yatta plateau and rugged volcanic scenery between Nairobi and Mombasa.',
   'Vast and remote — go with a guide and full fuel/water. Combine easily with a coast trip. Mzima Springs has an underwater hippo viewing chamber.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/tsavo/1200/800',
   -2.7833, 38.5000, '{safari,elephants,wilderness}', '{wildlife}', 4.6),

  ('Samburu National Reserve', 'Kenya', 'Africa', 'N',
   'Arid north home to the "Special Five".',
   'Along the Ewaso Ng''iro river, Samburu hosts species found nowhere further south — Grevy''s zebra, reticulated giraffe, gerenuk, Beisa oryx and Somali ostrich — and the proud Samburu people.',
   'Hotter and drier than the Mara. River wildlife gathers at dawn and dusk. Samburu cultural visits are widely offered — agree fees beforehand.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/samburu/1200/800',
   0.6167, 37.5333, '{safari,specialfive,arid}', '{wildlife,culture}', 4.7),

  ('Nairobi National Park', 'Kenya', 'Africa', 'S',
   'A wild savannah on the capital''s doorstep.',
   'The only national park within a capital city: lions, rhinos and giraffes roam against a backdrop of Nairobi''s skyline. Perfect for a half-day safari before or after a flight.',
   'Ideal for short layovers. Visit the nearby elephant orphanage and giraffe centre. Go early to beat traffic and heat.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/nairobinp/1200/800',
   -1.3733, 36.8580, '{safari,rhino,cityescape}', '{wildlife}', 4.5),

  ('Ol Pejeta Conservancy', 'Kenya', 'Africa', 'N',
   'Home of the last northern white rhinos.',
   'On the Laikipia plateau, Ol Pejeta is East Africa''s largest black rhino sanctuary, guardian of the world''s last two northern white rhinos and a chimpanzee sanctuary, with Mount Kenya views.',
   'Book guided rhino and chimp encounters in advance. Cooler highland climate — pack a fleece. Community-owned conservancy; fees fund conservation.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/olpejeta/1200/800',
   0.0000, 36.9000, '{safari,rhino,conservancy}', '{wildlife}', 4.8),

  ('Lake Nakuru National Park', 'Kenya', 'Africa', 'S',
   'Flamingo-pink shores and rhino sanctuary.',
   'A Rift Valley soda lake fringed by forests and cliffs, Nakuru is known for flocks of flamingos, both black and white rhino, Rothschild''s giraffe and tree-climbing lions.',
   'Flamingo numbers vary with water levels — check before visiting. Baboon Cliff gives the classic panorama. Easy day trip from Nairobi.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/lakenakuru/1200/800',
   -0.3631, 36.0800, '{safari,flamingos,rhino}', '{wildlife,lakes-rivers}', 4.7),

  -- ---------------- COASTAL LIFE ----------------
  ('Diani Beach', 'Kenya', 'Africa', 'S',
   'Powder-white sand and turquoise Indian Ocean.',
   'South of Mombasa, Diani''s palm-lined white beach is consistently rated among Africa''s best — ideal for swimming, kitesurfing, diving and dhow trips to the reef.',
   'December–March is hot and dry; the long rains hit April–May. Use sunscreen and reef-safe products. Agree taxi/tuk-tuk fares before riding.',
   '{12,1,2,3,7,8,9}', 'https://picsum.photos/seed/diani/1200/800',
   -4.3167, 39.5833, '{beach,diving,reef}', '{coast}', 4.8),

  ('Watamu Marine National Park', 'Kenya', 'Africa', 'S',
   'Coral gardens, turtles and a marine reserve.',
   'Watamu protects vibrant coral reefs, sea turtles and the Mida Creek mangroves. Snorkelling and diving here are superb, and turtle-watch programmes run year-round.',
   'Snorkel at low tide for the clearest reef. Support local turtle conservation groups. Mosquito precautions advised near the creek at dusk.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/watamu/1200/800',
   -3.3500, 40.0167, '{beach,reef,turtles}', '{coast,wildlife}', 4.7),

  ('Mombasa Old Town & Fort Jesus', 'Kenya', 'Africa', 'S',
   'Swahili streets and a 16th-century fort.',
   'Mombasa''s Old Town winds through Swahili, Arab and Portuguese history, crowned by the UNESCO-listed Fort Jesus. Carved doors, spice shops and coastal cuisine fill the lanes.',
   'Dress modestly in this largely Muslim quarter. Hire a local guide for the fort''s history. Try Swahili biryani and fresh coconut.',
   '{12,1,2,3,6,7,8,9}', 'https://picsum.photos/seed/mombasa/1200/800',
   -4.0626, 39.6699, '{history,swahili,unesco}', '{coast,culture}', 4.5),

  ('Lamu Old Town', 'Kenya', 'Africa', 'S',
   'Kenya''s oldest living Swahili settlement.',
   'A UNESCO World Heritage site, car-free Lamu moves by donkey and dhow. Coral-stone houses, the annual Maulidi festival and timeless Swahili culture make it utterly distinct.',
   'No cars — travel on foot, donkey or boat. Respect conservative dress and customs. Book dhow sunset sails through reputable operators.',
   '{12,1,2,3,6,7,8,9}', 'https://picsum.photos/seed/lamu/1200/800',
   -2.2717, 40.9020, '{swahili,unesco,dhow}', '{coast,culture}', 4.7),

  ('Wasini Island & Kisite Marine Park', 'Kenya', 'Africa', 'S',
   'Dolphin sails and pristine coral off the south coast.',
   'Boat trips from Shimoni reach Kisite-Mpunguti Marine Park for snorkelling among coral and dolphins, ending with Swahili seafood on car-free Wasini Island.',
   'Full-day dhow trips include snorkelling gear and lunch. Sea can be choppy in the windy months. Choose operators that respect dolphin distance rules.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/wasini/1200/800',
   -4.6600, 39.3800, '{dolphins,reef,dhow}', '{coast,wildlife}', 4.6),

  -- ---------------- MAASAI & SAMBURU CULTURE ----------------
  ('Bomas of Kenya', 'Kenya', 'Africa', 'S',
   'Traditional homesteads and dance under one roof.',
   'On the edge of Nairobi, Bomas of Kenya recreates the homesteads (bomas) of the country''s ethnic communities and stages daily traditional music and dance performances.',
   'Catch the afternoon dance show. Great rainy-day or pre-safari culture stop. Photography is generally welcome inside the bomas.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/bomas/1200/800',
   -1.3650, 36.7800, '{culture,dance,heritage}', '{culture}', 4.3),

  ('Maasai Village Visit (Mara)', 'Kenya', 'Africa', 'S',
   'Step inside a living Maasai manyatta.',
   'Near the Mara, Maasai communities welcome visitors into their manyattas to share herding life, the adumu jumping dance, beadwork and fire-making — a window into a proud pastoral culture.',
   'Agree the visit fee with the village beforehand. Ask before photographing people. Buying beadwork directly supports families.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/maasaivillage/1200/800',
   -1.5000, 35.2000, '{maasai,beadwork,tradition}', '{culture}', 4.5),

  ('Samburu Cultural Manyatta', 'Kenya', 'Africa', 'N',
   'Warrior traditions of Kenya''s northern plains.',
   'The Samburu, close cousins of the Maasai, keep vivid traditions of dress, song and warriorhood. Cultural visits near the reserve reveal daily life on the arid northern frontier.',
   'Arrange through your camp or a community guide. Dress respectfully. Fees and craft purchases go directly to the community.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/samburuculture/1200/800',
   0.6000, 37.5000, '{samburu,warriors,tradition}', '{culture}', 4.4),

  -- ---------------- NGANYA / MATATU CULTURE ----------------
  ('Nairobi Matatu (Nganya) Culture', 'Kenya', 'Africa', 'S',
   'The city''s loud, graffiti-bright bus art scene.',
   'Nairobi''s "nganya" — pimped-out matatus blasting music, wrapped in airbrushed graffiti, LED lights and pop-culture tributes — are a moving art form and the pulse of city street culture.',
   'Ride well-known routes in daylight and watch your belongings. Tom Mboya Street and the CBD stages are the heart of the scene. Ask before filming crews/touts.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/nganya/1200/800',
   -1.2864, 36.8230, '{matatu,streetart,urban}', '{nganya,culture}', 4.4),

  -- ---------------- HOT SPRINGS & GEOTHERMAL ----------------
  ('Lake Bogoria Hot Springs & Geysers', 'Kenya', 'Africa', 'N',
   'Spouting geysers beside a flamingo soda lake.',
   'Lake Bogoria''s shoreline hisses with hot springs and erupting geysers, while thousands of lesser flamingos crowd the soda lake — one of the Rift Valley''s most surreal sights.',
   'Stay on marked paths — the water is scalding. Best light early morning. Combine with nearby Lake Baringo for birdlife.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/bogoria/1200/800',
   0.2500, 36.1000, '{geysers,flamingos,rift}', '{hot-springs,lakes-rivers,wildlife}', 4.6),

  ('Hell''s Gate National Park', 'Kenya', 'Africa', 'S',
   'Cycle through gorges and geothermal steam.',
   'One of few parks you can explore on foot or bike, Hell''s Gate offers dramatic cliffs and gorges, towering rock columns, plains game and the steaming Olkaria geothermal field with its hot-spring spa.',
   'Hire a bike at the gate and a guide for the gorge. The Olkaria geothermal spa is a warm soak after hiking. Flash floods possible in the gorge after rain.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/hellsgate/1200/800',
   -0.8833, 36.3167, '{gorge,cycling,geothermal}', '{hot-springs,mountains,wildlife}', 4.6),

  ('Lake Magadi Hot Springs', 'Kenya', 'Africa', 'S',
   'A pink soda lake with bubbling warm springs.',
   'In the floor of the southern Rift, Lake Magadi shimmers pink and white with soda crust, fed by hot springs at its edges. It draws flamingos, wading birds and dramatic photography.',
   'Extremely hot and remote — carry water and sun protection. A high-clearance vehicle helps. Best combined with a Magadi day trip from Nairobi.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/magadi/1200/800',
   -1.9000, 36.2667, '{soda,springs,rift}', '{hot-springs,lakes-rivers}', 4.2),

  -- ---------------- LAKES & RIVERS ----------------
  ('Lake Naivasha', 'Kenya', 'Africa', 'S',
   'Freshwater lake of hippos and fish eagles.',
   'A freshwater Rift Valley lake ringed by acacia and flower farms, Naivasha brims with hippos, pelicans and fish eagles. Boat rides and the walking safari at Crescent Island are highlights.',
   'Take a morning boat ride to spot hippos safely from distance. Crescent Island lets you walk among giraffes and zebra. Gateway to Hell''s Gate.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/naivasha/1200/800',
   -0.7667, 36.3500, '{lake,hippos,boat}', '{lakes-rivers,wildlife}', 4.6),

  ('Lake Turkana — the Jade Sea', 'Kenya', 'Africa', 'N',
   'The world''s largest desert lake.',
   'Remote and otherworldly, jade-green Turkana lies in Kenya''s far north — a UNESCO site rich in fossils ("Cradle of Mankind"), Nile crocodiles and the cultures of the Turkana and El Molo.',
   'A serious expedition — go with experienced operators and convoys. Extreme heat and wind. The Lake Turkana Festival showcases northern cultures.',
   '{6,7,8,9,1,2}', 'https://picsum.photos/seed/turkana/1200/800',
   3.0667, 36.0500, '{desertlake,fossils,remote}', '{lakes-rivers,culture}', 4.5),

  ('Lake Victoria (Kisumu)', 'Kenya', 'Africa', 'S',
   'Africa''s greatest lake and lakeside life.',
   'On Kenya''s western shore, Lake Victoria anchors the city of Kisumu — sunset boat rides, Hippo Point, fishing villages, the Kit Mikayi rock and tilapia fresh from the water.',
   'Evening boat trips catch sunsets and hippos. Try local fish at lakeside eateries. Dunga Beach is the classic spot.',
   '{1,2,6,7,8,9,12}', 'https://picsum.photos/seed/victoria/1200/800',
   -0.1000, 34.7500, '{lake,sunset,fishing}', '{lakes-rivers}', 4.3),

  ('Mara River Crossing Points', 'Kenya', 'Africa', 'S',
   'Stage of the migration''s dramatic crossings.',
   'The Mara River cuts through the reserve where, from July to October, vast herds of wildebeest brave crocodile-filled waters in the migration''s most heart-stopping spectacle.',
   'Crossings are unpredictable — patience and a good guide are key. Keep quiet and still at crossing points. Peak window is August–September.',
   '{7,8,9,10}', 'https://picsum.photos/seed/marariver/1200/800',
   -1.4000, 35.0500, '{migration,crocodiles,river}', '{lakes-rivers,wildlife,migration}', 4.8),

  -- ---------------- MOUNTAINS & LANDSCAPES ----------------
  ('Mount Kenya', 'Kenya', 'Africa', 'N',
   'Africa''s second-highest peak.',
   'A glaciated volcano and UNESCO site, Mount Kenya rises to 5,199m. Point Lenana (4,985m) is a trekkable summit through bamboo forest, moorland and alpine tarns rich in unique flora.',
   'Acclimatise to avoid altitude sickness; the Sirimon–Chogoria route is scenic. Go with licensed guides/porters. Dry seasons give the safest trekking.',
   '{1,2,6,7,8,9}', 'https://picsum.photos/seed/mountkenya/1200/800',
   -0.1521, 37.3084, '{trekking,alpine,unesco}', '{mountains}', 4.8),

  ('Mount Longonot', 'Kenya', 'Africa', 'S',
   'A dormant volcano with a crater-rim hike.',
   'Rising above Lake Naivasha, Longonot rewards a steep climb with a trail around its forested crater rim and sweeping Rift Valley views — a popular day hike from Nairobi.',
   'Start early; little shade on the rim. Carry plenty of water. The full crater loop takes about 4–5 hours.',
   '{1,2,6,7,8,9,12}', 'https://picsum.photos/seed/longonot/1200/800',
   -0.9140, 36.4600, '{volcano,hiking,rift}', '{mountains}', 4.5),

  ('Menengai Crater', 'Kenya', 'Africa', 'S',
   'One of the world''s largest calderas.',
   'Above Nakuru, the vast Menengai caldera plunges to a steaming geothermal floor. Viewpoints on the rim offer huge Rift Valley vistas at sunrise and sunset.',
   'Easy to reach by car from Nakuru. Best at sunrise/sunset for light and cooler air. Watch footing near unfenced edges.',
   '{1,2,6,7,8,9,12}', 'https://picsum.photos/seed/menengai/1200/800',
   -0.2000, 36.0667, '{caldera,viewpoint,rift}', '{mountains}', 4.3),

  ('Thomson''s Falls (Nyahururu)', 'Kenya', 'Africa', 'N',
   'A 74-metre highland waterfall.',
   'Near Nyahururu, the Ewaso Ng''iro river plunges 74m through a fern-draped ravine. A short trail leads down to the foot of the falls in the cool central highlands.',
   'The descent path can be slippery — wear good shoes. Vendors and viewpoints sit at the top. Bring a light jacket for the highland chill.',
   '{1,2,6,7,8,9,12}', 'https://picsum.photos/seed/thomsonsfalls/1200/800',
   0.0500, 36.3667, '{waterfall,highlands,nature}', '{mountains,lakes-rivers}', 4.4),

  ('Karura Forest', 'Kenya', 'Africa', 'S',
   'A forest of trails and waterfalls in the city.',
   'A rare urban forest in Nairobi, Karura offers walking and cycling trails, a waterfall, caves and a tranquil escape from the city — a favourite of locals and a legacy of the late Wangari Maathai.',
   'Pay the gate fee and grab a trail map. Good for running, cycling and birding. Safe and well managed during daylight hours.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/karura/1200/800',
   -1.2333, 36.8333, '{forest,waterfall,trails}', '{mountains,lakes-rivers}', 4.5)

  returning id, name
)
-- A few gallery photos per place so the detail carousel has content.
insert into public.place_media (place_id, type, url, caption, position)
select s.id, 'photo',
       'https://picsum.photos/seed/' ||
         regexp_replace(lower(s.name), '[^a-z0-9]', '', 'g') || g || '/1200/800',
       'View ' || g, g
from seeded s, generate_series(2,4) as g;
