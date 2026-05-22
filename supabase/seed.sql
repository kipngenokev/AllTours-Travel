-- =====================================================================
-- All-Tours — seed data
-- Run AFTER schema.sql in the Supabase SQL Editor.
--
-- NOTE on media: image URLs use picsum.photos seeds so the app renders
-- reliably out-of-the-box. Swap cover_image_url / place_media.url for your
-- own Unsplash or Supabase-Storage URLs for production-quality visuals.
-- Sample videos come from Google's public test bucket.
-- =====================================================================

truncate table public.place_media cascade;
delete from public.places;

with seeded as (
  insert into public.places
    (name, country, continent, hemisphere, summary, description, guidelines,
     best_months, cover_image_url, video_url, latitude, longitude, tags, rating)
  values
  ('Paris', 'France', 'Europe', 'N',
   'The City of Light — art, cafés and the Eiffel Tower.',
   'Paris blends world-class museums, riverside walks and unmatched cuisine. Spring blossoms and golden autumn light are the most photogenic times to wander the Seine.',
   'Buy museum passes online to skip lines. The Metro is the fastest way around. Carry a light jacket in spring/autumn evenings. Beware pickpockets near major attractions.',
   '{5,6,9,10}', 'https://picsum.photos/seed/paris/1200/800',
   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
   48.8566, 2.3522, '{city,culture,romance,museums}', 4.8),

  ('Santorini', 'Greece', 'Europe', 'N',
   'Whitewashed cliffs and famous Aegean sunsets.',
   'Santorini''s caldera villages of Oia and Fira cascade down volcanic cliffs above a deep blue sea. Summer is warm, dry and ideal for island life.',
   'Sunsets in Oia are crowded — arrive 90 minutes early. Wear sturdy shoes for cobbled steps. Book caldera-view hotels well ahead in peak summer.',
   '{6,7,8,9}', 'https://picsum.photos/seed/santorini/1200/800',
   null, 36.3932, 25.4615, '{island,beach,sunset,romance}', 4.9),

  ('Kyoto', 'Japan', 'Asia', 'N',
   'Temples, geisha districts and cherry blossoms.',
   'Kyoto is Japan''s cultural heart: thousands of shrines, bamboo groves and traditional tea houses. Cherry blossom (spring) and fiery maples (autumn) are the signature seasons.',
   'Respect temple etiquette — remove shoes where indicated. Get an IC transit card. Reserve popular ryokan early during sakura season.',
   '{3,4,10,11}', 'https://picsum.photos/seed/kyoto/1200/800',
   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
   35.0116, 135.7681, '{culture,temples,nature,history}', 4.8),

  ('Bali', 'Indonesia', 'Asia', 'S',
   'Lush rice terraces, surf and temples.',
   'Bali offers volcanic landscapes, emerald rice paddies and a deeply spiritual culture. The dry season brings sunny days perfect for surfing and exploring.',
   'Rent a scooter only with a valid licence. Dress modestly at temples (sarong required). Stay hydrated and use reef-safe sunscreen.',
   '{5,6,7,8,9}', 'https://picsum.photos/seed/bali/1200/800',
   null, -8.4095, 115.1889, '{island,beach,surf,nature}', 4.7),

  ('Serengeti', 'Tanzania', 'Africa', 'S',
   'Endless plains and the Great Migration.',
   'The Serengeti hosts the planet''s greatest wildlife spectacle as millions of wildebeest and zebra cross its plains. The dry season concentrates animals around water.',
   'Book a licensed safari operator. Bring neutral-coloured clothing and binoculars. Follow your guide''s safety rules around wildlife at all times.',
   '{6,7,8,9,10}', 'https://picsum.photos/seed/serengeti/1200/800',
   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
   -2.3333, 34.8333, '{safari,wildlife,nature,adventure}', 4.9),

  ('Cape Town', 'South Africa', 'Africa', 'S',
   'Table Mountain between two oceans.',
   'Cape Town pairs a dramatic mountain backdrop with beaches, vineyards and vibrant neighbourhoods. The southern-hemisphere summer is warm and ideal for the outdoors.',
   'Take the cableway up Table Mountain early before the cloud "tablecloth" forms. Use registered taxis at night. Book Robben Island tours ahead.',
   '{11,12,1,2,3}', 'https://picsum.photos/seed/capetown/1200/800',
   null, -33.9249, 18.4241, '{city,beach,mountain,wine}', 4.7),

  ('Giza', 'Egypt', 'Africa', 'N',
   'The last standing Ancient Wonder.',
   'The Pyramids of Giza and the Great Sphinx rise from the desert at the edge of Cairo. Cooler winter months make daytime exploring comfortable.',
   'Hire an official guide at the gate. Agree camel/horse prices before riding. Bring water, a hat and sun protection — shade is scarce.',
   '{10,11,12,1,2,3}', 'https://picsum.photos/seed/giza/1200/800',
   null, 29.9792, 31.1342, '{history,desert,ancient,culture}', 4.6),

  ('Banff', 'Canada', 'North America', 'N',
   'Turquoise lakes in the Canadian Rockies.',
   'Banff National Park dazzles with glacier-fed lakes like Louise and Moraine, alpine trails and abundant wildlife. Summer unlocks hiking and canoeing.',
   'Buy a Parks Canada pass. Carry bear spray on trails and store food properly. Arrive early at Moraine Lake — parking fills fast.',
   '{6,7,8,9}', 'https://picsum.photos/seed/banff/1200/800',
   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
   51.4968, -115.9281, '{mountain,lakes,hiking,nature}', 4.9),

  ('New York City', 'USA', 'North America', 'N',
   'The city that never sleeps.',
   'NYC is a global capital of culture, food and skyline views. Spring and autumn offer mild weather; the holiday season sparkles with lights.',
   'Get a transit card for subways and buses. Many museums have "pay-what-you-wish" hours. Book Broadway and observation decks in advance.',
   '{4,5,6,9,10,11,12}', 'https://picsum.photos/seed/nyc/1200/800',
   null, 40.7128, -74.0060, '{city,culture,food,shopping}', 4.6),

  ('Machu Picchu', 'Peru', 'South America', 'S',
   'The lost city of the Inca.',
   'Perched high in the Andes, Machu Picchu''s stone terraces and peaks are a bucket-list wonder. The dry season offers the clearest mountain views.',
   'Permits and timed tickets are required — book months ahead. Acclimatise in Cusco first to avoid altitude sickness. Hire a guide for the ruins.',
   '{5,6,7,8,9}', 'https://picsum.photos/seed/machupicchu/1200/800',
   null, -13.1631, -72.5450, '{history,mountain,hiking,ancient}', 5.0),

  ('Rio de Janeiro', 'Brazil', 'South America', 'S',
   'Beaches, samba and Christ the Redeemer.',
   'Rio dazzles with Copacabana''s sands, Sugarloaf cable cars and Carnival energy. The southern summer is hot, festive and beach-perfect.',
   'Keep valuables hidden on the beach. Use apps for rides. Take the train up Corcovado early to beat haze and crowds.',
   '{12,1,2,3}', 'https://picsum.photos/seed/rio/1200/800',
   null, -22.9068, -43.1729, '{beach,city,carnival,culture}', 4.5),

  ('Queenstown', 'New Zealand', 'Oceania', 'S',
   'Adventure capital of the world.',
   'Set on Lake Wakatipu beneath the Remarkables, Queenstown is famed for bungee, skiing and jaw-dropping scenery year-round.',
   'Layer up — mountain weather changes fast. Book adventure activities and the Milford Sound day trip ahead. Drive on the left.',
   '{12,1,2,6,7,8}', 'https://picsum.photos/seed/queenstown/1200/800',
   null, -45.0312, 168.6626, '{adventure,mountain,lakes,ski}', 4.8),

  ('Sydney', 'Australia', 'Oceania', 'S',
   'Iconic harbour, Opera House and beaches.',
   'Sydney wraps a sparkling harbour with golden beaches like Bondi and a buzzing food scene. Warm spring-to-autumn months are best for the coast.',
   'Walk the Bondi-to-Coogee coastal path. Swim between the flags at patrolled beaches. An Opal card covers ferries, trains and buses.',
   '{9,10,11,12,1,2,3}', 'https://picsum.photos/seed/sydney/1200/800',
   null, -33.8688, 151.2093, '{city,beach,harbour,culture}', 4.7),

  ('Antarctic Peninsula', 'Antarctica', 'Antarctica', 'S',
   'The white continent''s accessible edge.',
   'The Antarctic Peninsula offers towering icebergs, penguin colonies and whales on expedition cruises. The austral summer is the only viable window.',
   'Travel only with IAATO-approved expeditions. Pack serious cold-weather layers. Follow strict biosecurity rules to protect the ecosystem.',
   '{11,12,1,2,3}', 'https://picsum.photos/seed/antarctica/1200/800',
   null, -64.0000, -61.0000, '{wildlife,ice,expedition,adventure}', 4.9)
  returning id, name
)
-- A couple of extra gallery photos per place so the detail carousel has content
insert into public.place_media (place_id, type, url, caption, position)
select s.id, 'photo',
       'https://picsum.photos/seed/' || lower(replace(s.name,' ','')) || g || '/1200/800',
       'View ' || g, g
from seeded s, generate_series(2,4) as g;
