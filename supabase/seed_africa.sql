-- =====================================================================
-- All-Tours — Africa attractions seed (South Africa, Tanzania, Egypt,
-- Rwanda, Morocco). Kenya lives in seed_kenya.sql.
--
-- Run order:  schema.sql  ->  (optional) seed.sql  ->  seed_kenya.sql
--             ->  seed_africa.sql
-- Safe to re-run: it replaces only these five countries' rows.
--
-- Experience categories used here:
--   wildlife · gorillas · coast · history · culture · mountains
--   · desert · lakes-rivers · hot-springs · food-wine
-- Images use picsum.photos seeds; swap for real photography for production.
-- =====================================================================

delete from public.places
where country in ('South Africa', 'Tanzania', 'Egypt', 'Rwanda', 'Morocco');

with seeded as (
  insert into public.places
    (name, country, continent, hemisphere, summary, description, guidelines,
     best_months, cover_image_url, latitude, longitude, tags, categories, rating)
  values

  -- ====================== SOUTH AFRICA ======================
  ('Kruger National Park', 'South Africa', 'Africa', 'S',
   'Iconic Big Five wilderness the size of a small country.',
   'Kruger is South Africa''s flagship reserve, home to lion, leopard, elephant, rhino and buffalo across vast bushveld. Self-drive or guided safaris both deliver superb sightings.',
   'Dry winter (May–September) concentrates game at waterholes. Book rest camps early. Stay in your vehicle except at marked points and keep to gate times.',
   '{5,6,7,8,9}', 'https://picsum.photos/seed/kruger/1200/800',
   -24.0100, 31.4900, '{safari,bigfive,bushveld}', '{wildlife}', 4.8),

  ('Table Mountain & Cape Town', 'South Africa', 'Africa', 'S',
   'A flat-topped icon above a city between two oceans.',
   'Table Mountain''s cableway and trails reward you with sweeping views over Cape Town, Robben Island and the Cape Peninsula. The city blends beaches, mountains and culture.',
   'Ride the cableway early before the cloud "tablecloth" forms and winds close it. Carry water for hikes. Use registered taxis or apps at night.',
   '{11,12,1,2,3}', 'https://picsum.photos/seed/tablemountain/1200/800',
   -33.9628, 18.4098, '{mountain,city,views}', '{mountains}', 4.8),

  ('Cape Winelands (Stellenbosch & Franschhoek)', 'South Africa', 'Africa', 'S',
   'Historic estates and world-class wine tasting.',
   'Just outside Cape Town, the Cape Dutch towns of Stellenbosch and Franschhoek sit among oak-lined vineyards and mountains, famed for cellar tours, tastings and fine dining.',
   'Use the hop-on wine tram or a designated driver — never drink and drive. Book popular estates ahead. Autumn (Mar–May) brings the grape harvest.',
   '{2,3,4,11,12}', 'https://picsum.photos/seed/capewinelands/1200/800',
   -33.9321, 18.8602, '{wine,food,vineyards}', '{food-wine,culture}', 4.7),

  ('Robben Island', 'South Africa', 'Africa', 'S',
   'The island prison where Mandela was held.',
   'A UNESCO World Heritage site off Cape Town, Robben Island held Nelson Mandela for 18 years. Former political prisoners guide tours of the cells and quarry.',
   'Book ferry tickets online well in advance — they sell out. Trips can cancel in rough seas. Allow around 3.5 hours round trip from the V&A Waterfront.',
   '{11,12,1,2,3}', 'https://picsum.photos/seed/robbenisland/1200/800',
   -33.8067, 18.3667, '{history,mandela,unesco}', '{history,culture}', 4.6),

  ('The Garden Route', 'South Africa', 'Africa', 'S',
   'A coastal drive of forests, lagoons and beaches.',
   'Stretching along the southern Cape coast, the Garden Route links Knysna''s lagoon, Tsitsikamma''s forests and cliffs, and golden beaches — a classic self-drive holiday.',
   'Allow several days to do it justice. Book whale-watching (Jun–Nov) around Hermanus/Plettenberg. Drive carefully on coastal passes.',
   '{10,11,12,1,2,3,4}', 'https://picsum.photos/seed/gardenroute/1200/800',
   -34.0500, 23.0500, '{coast,roadtrip,nature}', '{coast}', 4.6),

  ('Boulders Beach Penguins', 'South Africa', 'Africa', 'S',
   'A colony of African penguins on a sheltered beach.',
   'At Simon''s Town near Cape Town, boardwalks let you watch a colony of endangered African penguins waddle and swim among granite boulders and calm coves.',
   'Pay the reserve fee and stay on the boardwalks — do not touch the penguins. Mornings are quieter. Combine with a Cape Point day trip.',
   '{11,12,1,2,3}', 'https://picsum.photos/seed/boulderspenguins/1200/800',
   -34.1972, 18.4515, '{penguins,beach,coast}', '{coast,wildlife}', 4.5),

  ('Blyde River Canyon (Panorama Route)', 'South Africa', 'Africa', 'S',
   'One of the world''s largest green canyons.',
   'On the way to Kruger, the Panorama Route delivers the vast Blyde River Canyon, God''s Window, the Three Rondavels and waterfalls plunging through subtropical greenery.',
   'Drive the route over a full day with several viewpoint stops. Mist can hide views — go early. Watch footing at unfenced lookouts.',
   '{4,5,6,7,8,9}', 'https://picsum.photos/seed/blydecanyon/1200/800',
   -24.5833, 30.8000, '{canyon,viewpoints,waterfalls}', '{mountains}', 4.6),

  ('Soweto & Apartheid Museum', 'South Africa', 'Africa', 'S',
   'The living history of the freedom struggle.',
   'In Johannesburg, the powerful Apartheid Museum and a Soweto tour — Vilakazi Street, the Hector Pieterson Memorial and Mandela''s house — tell South Africa''s recent history.',
   'Allow 2–3 hours at the museum. Go with a local guide in Soweto for context and safety. Be respectful at memorial sites.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/soweto/1200/800',
   -26.2380, 27.8580, '{history,struggle,township}', '{history,culture}', 4.5),

  -- ======================== TANZANIA ========================
  ('Serengeti National Park', 'Tanzania', 'Africa', 'S',
   'Endless plains and the Great Migration.',
   'The Serengeti hosts the planet''s greatest wildlife spectacle as millions of wildebeest and zebra move across its plains, trailed by big cats and crocodiles at the river crossings.',
   'Book a licensed operator. The dry season concentrates game; the migration''s location shifts month to month. Bring neutral clothing and binoculars.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/serengetitz/1200/800',
   -2.3333, 34.8333, '{safari,migration,bigfive}', '{wildlife,migration}', 4.9),

  ('Ngorongoro Crater', 'Tanzania', 'Africa', 'S',
   'A wildlife-packed caldera and natural amphitheatre.',
   'The world''s largest intact volcanic caldera shelters dense populations of lion, elephant, rhino and flamingo on its floor — one of the best places in Africa to see the Big Five in a day.',
   'Descend early for the best light and game. Cooler highland air — pack a fleece. Maasai communities live on the surrounding rim.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/ngorongoro/1200/800',
   -3.2000, 35.5000, '{safari,caldera,bigfive}', '{wildlife}', 4.8),

  ('Mount Kilimanjaro', 'Tanzania', 'Africa', 'S',
   'The roof of Africa at 5,895 metres.',
   'Africa''s highest peak is a free-standing volcano trekkers can summit without technical climbing, passing through rainforest, moorland and arctic glaciers to Uhuru Peak.',
   'Choose a longer route (Lemosho/Machame) to acclimatise and boost summit success. Go with licensed guides and porters. Dry seasons are safest.',
   '{1,2,6,7,8,9,10}', 'https://picsum.photos/seed/kilimanjaro/1200/800',
   -3.0674, 37.3556, '{trekking,summit,volcano}', '{mountains}', 4.8),

  ('Stone Town, Zanzibar', 'Tanzania', 'Africa', 'S',
   'A Swahili spice-island trading city.',
   'Zanzibar''s UNESCO-listed Stone Town is a maze of coral-stone lanes, carved doors, bustling bazaars and a layered Swahili, Arab and Indian heritage, ringed by turquoise water.',
   'Dress modestly in this Muslim community. Take a guided spice-farm tour. Watch belongings in crowded markets and agree taxi fares first.',
   '{6,7,8,9,12,1,2}', 'https://picsum.photos/seed/stonetown/1200/800',
   -6.1639, 39.1900, '{swahili,spice,unesco}', '{history,culture,coast}', 4.7),

  ('Nungwi & Zanzibar Beaches', 'Tanzania', 'Africa', 'S',
   'Powder-white sand and dhow sunsets.',
   'Northern Zanzibar''s beaches — Nungwi and Kendwa — offer swimmable turquoise water unaffected by extreme tides, dhow cruises, snorkelling and famous Indian Ocean sunsets.',
   'December–February and June–October are driest. Use reef-safe sunscreen. Respect local dress away from the resort beach.',
   '{6,7,8,9,12,1,2}', 'https://picsum.photos/seed/nungwi/1200/800',
   -5.7261, 39.2960, '{beach,snorkelling,dhow}', '{coast}', 4.7),

  ('Tarangire National Park', 'Tanzania', 'Africa', 'S',
   'Giant baobabs and great elephant herds.',
   'Tarangire is known for its ancient baobab trees and large elephant herds drawn to the Tarangire River, especially in the dry season, plus excellent birdlife.',
   'Best in the dry months when game gathers at the river. Often combined with Ngorongoro and the Serengeti on a northern circuit.',
   '{6,7,8,9,10}', 'https://picsum.photos/seed/tarangire/1200/800',
   -3.8333, 36.0000, '{elephants,baobab,safari}', '{wildlife}', 4.5),

  ('Lake Manyara National Park', 'Tanzania', 'Africa', 'S',
   'Tree-climbing lions beside a soda lake.',
   'A compact park beneath the Rift escarpment, Manyara is famed for tree-climbing lions, flamingos on the soda lake, hippos and groundwater forest teeming with birds.',
   'A great half-day stop on the northern circuit. The canopy walkway gives a forest perspective. Bring binoculars for the lake birds.',
   '{6,7,8,9,10,1,2}', 'https://picsum.photos/seed/lakemanyara/1200/800',
   -3.6000, 35.8333, '{lions,flamingos,safari}', '{wildlife,lakes-rivers}', 4.4),

  -- ========================= EGYPT =========================
  ('Pyramids of Giza & the Sphinx', 'Egypt', 'Africa', 'N',
   'The last standing Ancient Wonder.',
   'On the edge of Cairo, the Great Pyramid and its companions, guarded by the Great Sphinx, have stood for 4,500 years — the only surviving wonder of the ancient world.',
   'Hire an official guide at the gate and agree camel/horse prices before riding. Go early for cooler air and fewer crowds. Bring water and sun cover.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/gizapyramids/1200/800',
   29.9792, 31.1342, '{ancient,pyramids,wonder}', '{history}', 4.8),

  ('Luxor — Karnak & Valley of the Kings', 'Egypt', 'Africa', 'N',
   'The world''s greatest open-air museum.',
   'Ancient Thebes spreads along the Nile at Luxor: the colossal temples of Karnak and Luxor on the east bank, and the royal tombs of the Valley of the Kings on the west.',
   'Start at dawn to beat the heat. A west-bank guide brings the tombs to life. Photo passes are needed inside some tombs.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/luxor/1200/800',
   25.6872, 32.6396, '{ancient,temples,tombs}', '{history}', 4.8),

  ('Nile River Cruise', 'Egypt', 'Africa', 'N',
   'Sail between the temples of Upper Egypt.',
   'A classic cruise between Luxor and Aswan glides past riverside life and stops at the temples of Edfu and Kom Ombo — the most relaxed way to see Upper Egypt''s antiquities.',
   'Three- to four-night cruises pair well with Luxor and Abu Simbel. A felucca sail at sunset in Aswan is a highlight. Pack modest dress for temples.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/nilecruise/1200/800',
   24.0889, 32.8998, '{nile,cruise,temples}', '{lakes-rivers,history}', 4.7),

  ('Abu Simbel Temples', 'Egypt', 'Africa', 'N',
   'Ramses II''s colossal rock temples.',
   'Carved into a cliff near the Sudanese border, the giant temples of Ramses II were famously relocated stone by stone to escape Lake Nasser — a marvel of ancient and modern engineering.',
   'Fly or join a guided convoy from Aswan; start very early. The twice-yearly sun alignment (Feb & Oct) draws crowds. Carry water and sun protection.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/abusimbel/1200/800',
   22.3372, 31.6258, '{ancient,temples,ramses}', '{history}', 4.7),

  ('Red Sea Riviera (Hurghada & Sharm el-Sheikh)', 'Egypt', 'Africa', 'N',
   'Coral reefs and year-round diving.',
   'Egypt''s Red Sea coast offers some of the world''s best diving and snorkelling among vivid coral reefs and marine life, with warm, calm water and resort beaches.',
   'Choose reputable, eco-minded dive centres. Use reef-safe sunscreen and never touch coral. Spring and autumn are most comfortable.',
   '{3,4,5,9,10,11}', 'https://picsum.photos/seed/redsea/1200/800',
   27.2579, 33.8116, '{diving,reef,beach}', '{coast}', 4.6),

  ('White Desert (Farafra)', 'Egypt', 'Africa', 'N',
   'Surreal chalk formations in the Western Desert.',
   'The White Desert''s wind-sculpted chalk towers glow under the sun and stars, a otherworldly landscape best experienced on an overnight 4x4 and camping safari.',
   'Go only with experienced desert operators. Overnight to see the formations at sunset and dawn. Nights are cold — pack warm layers.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/whitedesert/1200/800',
   27.0000, 28.0000, '{desert,camping,landscape}', '{desert}', 4.5),

  ('Cairo — Egyptian Museum & Khan el-Khalili', 'Egypt', 'Africa', 'N',
   'Treasures of the pharaohs and a historic bazaar.',
   'Cairo holds the unrivalled collection of pharaonic treasures (including Tutankhamun''s gold) and the centuries-old Khan el-Khalili bazaar in atmospheric Islamic Cairo.',
   'Allow half a day for the museum. Haggle politely in the bazaar and watch your belongings. Dress modestly around mosques.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/cairo/1200/800',
   30.0444, 31.2357, '{museum,bazaar,history}', '{history,culture}', 4.5),

  ('Siwa Oasis', 'Egypt', 'Africa', 'N',
   'Palm-fringed springs deep in the desert.',
   'Remote Siwa near the Libyan border is a Berber oasis of palm groves, salt lakes, ancient ruins and natural springs — including the famous Cleopatra''s Bath.',
   'A long drive from the coast — plan transport ahead. Swim in designated springs and respect the conservative local culture. Wonderful for stargazing.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/siwa/1200/800',
   29.2032, 25.5195, '{oasis,springs,berber}', '{desert,hot-springs}', 4.5),

  -- ========================= RWANDA =========================
  ('Volcanoes National Park', 'Rwanda', 'Africa', 'S',
   'Mountain gorilla trekking in the Virungas.',
   'On the forested slopes of the Virunga volcanoes, Volcanoes National Park offers life-changing treks to habituated mountain gorilla families, plus golden monkeys and Dian Fossey''s legacy.',
   'Gorilla permits are limited and must be booked well ahead. Treks can be steep and muddy — bring hiking boots and rain gear. Keep 7m from the gorillas.',
   '{6,7,8,9,12,1,2}', 'https://picsum.photos/seed/volcanoesnp/1200/800',
   -1.4833, 29.4900, '{gorillas,trekking,virunga}', '{gorillas,mountains}', 4.9),

  ('Nyungwe Forest National Park', 'Rwanda', 'Africa', 'S',
   'Chimps and a canopy walk in ancient rainforest.',
   'One of Africa''s oldest rainforests, Nyungwe is home to chimpanzees and many monkey species, with a thrilling suspended canopy walkway high above the treetops.',
   'Chimp tracking starts very early and isn''t guaranteed — be patient. Trails are steep and slippery. Book the canopy walk in advance.',
   '{6,7,8,9,12,1,2}', 'https://picsum.photos/seed/nyungwe/1200/800',
   -2.4833, 29.2000, '{chimps,rainforest,canopy}', '{gorillas,mountains}', 4.6),

  ('Lake Kivu', 'Rwanda', 'Africa', 'S',
   'A serene Great Rift lake of beaches and islands.',
   'One of Africa''s great lakes, Kivu offers calm beaches at Gisenyi, Kibuye and Rusizi, boat trips to islands, and a relaxing counterpoint to gorilla trekking.',
   'A great place to unwind after the Virungas. Boat trips and kayaking are popular. The Congo Nile Trail follows the shore for hikers and cyclists.',
   '{6,7,8,9,12,1,2}', 'https://picsum.photos/seed/lakekivu/1200/800',
   -1.9667, 29.1500, '{lake,beaches,relax}', '{lakes-rivers}', 4.4),

  ('Kigali Genocide Memorial', 'Rwanda', 'Africa', 'S',
   'A moving memorial to the 1994 genocide.',
   'The Kigali Genocide Memorial honours the victims of the 1994 genocide against the Tutsi and is the resting place of more than 250,000 people — a powerful, essential visit.',
   'Allow 2–3 hours and visit respectfully; photography is restricted inside. An audio guide adds context. Kigali itself is famously safe and clean.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/kigalimemorial/1200/800',
   -1.9300, 30.0590, '{history,memorial,kigali}', '{history,culture}', 4.7),

  ('Akagera National Park', 'Rwanda', 'Africa', 'S',
   'Rwanda''s Big Five savannah and lakes.',
   'In the east, Akagera''s rolling savannah and chain of lakes shelter lion, elephant, rhino, buffalo and hippo — a successful conservation comeback and Rwanda''s only Big Five park.',
   'Boat safaris on Lake Ihema add hippos and birds. Pairs well with a gorilla trek for a varied trip. Game drives are best early and late.',
   '{6,7,8,9,12,1,2}', 'https://picsum.photos/seed/akagera/1200/800',
   -1.8700, 30.7200, '{safari,bigfive,lakes}', '{wildlife}', 4.5),

  -- ========================= MOROCCO =========================
  ('Marrakech Medina & Jemaa el-Fnaa', 'Morocco', 'Africa', 'N',
   'A walled old city and its theatrical square.',
   'Marrakech''s UNESCO medina hides souks, riads, palaces and the Koutoubia minaret, all centred on Jemaa el-Fnaa — a square that erupts each evening with food stalls and performers.',
   'Hire a guide to navigate the souks and agree prices before buying. Dress modestly. The square is liveliest after sunset — mind your belongings.',
   '{3,4,5,9,10,11}', 'https://picsum.photos/seed/marrakech/1200/800',
   31.6258, -7.9891, '{medina,souk,unesco}', '{history,culture}', 4.7),

  ('Sahara Desert — Erg Chebbi (Merzouga)', 'Morocco', 'Africa', 'N',
   'Towering golden dunes and desert camps.',
   'At Merzouga, the great dunes of Erg Chebbi rise from the Sahara. Ride camels over the sand to a Berber camp for sunset, stargazing and music around the fire.',
   'Overnight to catch sunset and sunrise on the dunes. It''s a long drive from Marrakech — break the journey via Ait Benhaddou. Pack warm layers for cold nights.',
   '{3,4,10,11}', 'https://picsum.photos/seed/sahara/1200/800',
   31.0995, -4.0136, '{desert,dunes,camel}', '{desert}', 4.8),

  ('High Atlas & Mount Toubkal', 'Morocco', 'Africa', 'N',
   'North Africa''s highest peak and Berber villages.',
   'The High Atlas rises behind Marrakech, with trails through terraced Berber villages and the trek up Mount Toubkal (4,167m), North Africa''s tallest summit.',
   'Use a licensed mountain guide for Toubkal. Summer is best for the high peaks; winter needs crampons. Respect village customs in the valleys.',
   '{5,6,7,8,9}', 'https://picsum.photos/seed/toubkal/1200/800',
   31.0606, -7.9152, '{trekking,berber,summit}', '{mountains}', 4.6),

  ('Fes el-Bali Medina', 'Morocco', 'Africa', 'N',
   'The world''s largest car-free medieval city.',
   'Fes el-Bali is a labyrinth of thousands of lanes, home to ancient tanneries, the Al-Qarawiyyin (one of the oldest universities) and craft workshops — a sensory step back in time.',
   'A local guide is invaluable to avoid getting lost. Carry mint at the tanneries for the smell. Dress modestly and ask before photographing people.',
   '{3,4,5,9,10,11}', 'https://picsum.photos/seed/fes/1200/800',
   34.0654, -4.9789, '{medina,tanneries,history}', '{history,culture}', 4.6),

  ('Chefchaouen — the Blue City', 'Morocco', 'Africa', 'N',
   'A mountain town washed in shades of blue.',
   'Tucked in the Rif Mountains, Chefchaouen''s old town is painted in countless blues — a relaxed, photogenic place for wandering, shopping for crafts and mountain day hikes.',
   'Mornings are best for photos before crowds arrive. Wear comfortable shoes for steep lanes. Hike up to the Spanish Mosque for sunset views.',
   '{3,4,5,9,10,11}', 'https://picsum.photos/seed/chefchaouen/1200/800',
   35.1688, -5.2636, '{bluecity,rif,photography}', '{culture}', 4.6),

  ('Essaouira', 'Morocco', 'Africa', 'N',
   'A breezy Atlantic port with a walled medina.',
   'Windswept Essaouira pairs a UNESCO medina and working fishing harbour with wide beaches popular for kitesurfing and a laid-back, artistic atmosphere.',
   'Strong Atlantic wind makes it cooler than inland — bring a layer. Try fresh grilled fish at the port. A relaxed contrast to Marrakech.',
   '{4,5,6,9,10}', 'https://picsum.photos/seed/essaouira/1200/800',
   31.5085, -9.7595, '{coast,medina,kitesurf}', '{coast,history}', 4.5),

  ('Casablanca — Hassan II Mosque', 'Morocco', 'Africa', 'N',
   'A vast mosque rising over the Atlantic.',
   'Morocco''s economic hub is crowned by the Hassan II Mosque, one of the world''s largest, with a 210m minaret and a hall partly built over the sea — open to non-Muslim guided tours.',
   'Book a guided tour to enter (one of the few mosques non-Muslims may visit). Dress modestly. Pair with the seaside Corniche.',
   '{3,4,5,9,10,11}', 'https://picsum.photos/seed/casablanca/1200/800',
   33.6084, -7.6325, '{mosque,architecture,coast}', '{history,culture}', 4.4),

  ('Moroccan Food Trails', 'Morocco', 'Africa', 'N',
   'Tagine, mint tea and the flavours of the souk.',
   'Moroccan cuisine is a destination in itself — slow-cooked tagines, fragrant couscous, fresh bread, pastries and ceremonial mint tea, best discovered on a market tour or cooking class.',
   'Book a guided street-food tour or a riad cooking class. Drink bottled or filtered water. Sample seasonal produce at the local souks.',
   '{1,2,3,4,5,6,7,8,9,10,11,12}', 'https://picsum.photos/seed/moroccofood/1200/800',
   31.6200, -7.9800, '{food,tagine,cooking}', '{food-wine,culture}', 4.6)

  returning id, name
)
-- A few gallery photos per place so the detail carousel has content.
insert into public.place_media (place_id, type, url, caption, position)
select s.id, 'photo',
       'https://picsum.photos/seed/' ||
         regexp_replace(lower(s.name), '[^a-z0-9]', '', 'g') || g || '/1200/800',
       'View ' || g, g
from seeded s, generate_series(2,4) as g;
