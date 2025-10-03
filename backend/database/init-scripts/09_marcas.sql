SET session_replication_role = 'replica';

TRUNCATE TABLE "marcas" CASCADE;

INSERT INTO "marcas" ("id", "nombre", "categoria_id", "descripcion", "logo_url", "activo", "created_at", "updated_at") VALUES
(2, 'ActiveGear', '48', 'Convenient stroller for pets to enjoy outdoor walks.', 'https://oaic.gov.au/eum/voluptate/vivere/nec/enim/ferreum.pem?quasi&perpetua', '0', '2024-09-26 15:58:40', '2024-09-28 22:10:42'),
(35, 'AeroCool', '1', 'Natural air purifiers to absorb odors and moisture.', 'https://alibaba.com/in/et.p12?amoris', '0', '2024-09-26 19:01:12', '2024-10-01 21:37:35'),
(11, 'AquaPure', '5', 'Crispy chickpeas roasted with honey for a sweet and satisfying snack.', 'https://ed.gov/delectari/corporis.json?laboriosam', '1', '2024-09-26 16:50:12', '2024-10-03 06:04:48'),
(43, 'Aqualia', '41', 'All-natural skincare set for daily use.', 'https://mapy.cz/possimus/omnis/voluptas/assumenda/est/nacti.odf?putat&epicurus&terminari&summam', '0', '2024-09-26 19:52:27', '2024-09-29 06:29:11'),
(31, 'BioSense', '25', 'Classic marinara sauce for all pasta dishes.', 'https://weather.com/reprehensiones/maxime.pptx?iucundius&nec', '0', '2024-09-26 18:37:05', '2024-09-30 06:33:09'),
(8, 'BluePeak', '1', 'Juicy meatballs made with a blend of beef and pork, seasoned with Italian herbs.', 'http://netscape.com/illaberetur/inquit.csr?imperiis', '0', '2024-09-26 16:37:08', '2024-10-01 01:11:41'),
(48, 'BrightNest', '19', 'Plant-based sausage links with spices and herbs.', 'https://wunderground.com/eam/non/possim/accommodare/hac.log?nec&necessariae&quarum', '1', '2024-09-26 20:18:01', '2024-10-01 02:51:17'),
(38, 'BrightView', '39', 'Aromatic long-grain basmati rice, perfect for curries.', 'https://spiegel.de/inmensae/et/inanes/divitiarum/est.zip?scripserit', '1', '2024-09-26 19:15:46', '2024-10-01 11:54:07'),
(22, 'ChillZone', '20', 'A tangy marinade for meats and veggies, packed with garlic flavor.', 'https://fda.gov/tempus/aut/reprehensiones.pfx?vellem', '0', '2024-09-26 17:54:37', '2024-09-29 02:07:11'),
(36, 'CleanSweep', '15', 'A mix of carrots, peas, and corn, easy to stir-fry.', 'https://flickr.com/modo/quondam.jsp?cibo&et&potione&fames&sitisque', '1', '2024-09-26 19:05:20', '2024-10-05 22:40:17'),
(33, 'ComfyNest', '34', 'Lightweight and moisture-wicking racerback tank for workouts.', 'http://about.me/difficile/est/tamen/illae.psc1?campum&si&canes&si&equos', '1', '2024-09-26 18:53:15', '2024-10-01 10:48:43'),
(5, 'CrystalClear', '78', 'Individually packaged bars made with dried fruits and nuts.', 'http://ning.com/quidem/etsi.csv?', '1', '2024-09-26 16:26:40', '2024-09-26 17:32:12'),
(1, 'EcoLite', '24', 'Ultra-soft fleece hoodie for warmth and comfort during chilly days.', 'https://theatlantic.com/et/corporis/voluptatibus/probaretur.rtf?animi&quam', '1', '2024-09-26 15:53:43', '2024-09-27 06:40:03'),
(44, 'EcoPure', '58', 'Spicy buffalo sauce ideal for wings or dipping.', 'https://de.vu/loquuntur/magistra/ac/duce/natura/hoc.xml?fuisse', '1', '2024-09-26 19:55:37', '2024-10-01 07:13:11'),
(32, 'FlexiFit', '1', 'Complete set designed for children to learn gardening.', 'http://so-net.ne.jp/eo/non/arbitrantur/eos.ods?si&qui&e&nostris', '0', '2024-09-26 18:45:15', '2024-10-01 12:13:11'),
(25, 'FlexiHome', '66', 'Healthy salad made with quinoa, almonds, and mixed greens, perfect for a light meal.', 'http://apache.org/vel/illum/qui/tamen.ogg?', '1', '2024-09-26 18:10:12', '2024-09-30 00:34:24'),
(15, 'FreshBite', '35', 'Modern lamp featuring a USB port for convenient charging.', 'https://nature.com/enim/tranquillitate.bat?ea&cum&accedit', '0', '2024-09-26 17:06:00', '2024-10-03 00:13:49'),
(28, 'FreshStart', '1', 'Everything you need to build a festive gingerbread house.', 'https://state.gov/ratione/dici/non/necesse/est/afflueret.pem?eo&delectari', '0', '2024-09-26 18:29:51', '2024-10-04 13:34:17'),
(16, 'GreenLeaf', '40', 'Crunchy granola mixed with coconut flakes.', 'http://sina.com.cn/a/platone/disputata/sunt/haec/enim.psc1?exquisitaque&doctrina&philosophi&graeco', '1', '2024-09-26 17:12:53', '2024-09-29 05:47:05'),
(41, 'GreenSprout', '17', 'Durable speaker designed for outdoor use with water resistance.', 'https://ucla.edu/refugiendi/et/et.conf?erigimur&quae&expectamus&sic', '1', '2024-09-26 19:40:23', '2024-10-06 09:51:44'),
(12, 'HomeEase', '6', 'Crunchy granola with toasted coconut flakes, perfect for breakfast or snacks.', 'http://t.co/possunt/conficiuntur/et/quippiam.bz2?dolore&magnam&aliquam&quaerat&voluptatem', '1', '2024-09-26 16:51:57', '2024-10-05 09:38:41'),
(17, 'LuminaTech', '63', 'Notepad made from recycled paper for sustainable note-taking.', 'https://domainmarket.com/disseretur/inter/principes/comparandae.csv?etiam&legum&iudiciorumque&poenis&obligantur', '0', '2024-09-26 17:21:42', '2024-10-05 04:41:44'),
(9, 'MaxDrive', '53', 'Continuous stream of fresh water for pets, promoting hydration.', 'https://jigsy.com/imperiis/aut/comprehenderit.odp?causa&importari&putant', '1', '2024-09-26 16:46:13', '2024-10-01 22:33:59'),
(6, 'NatureGlow', '68', 'Track steps, heart rate, and sleep patterns.', 'https://wix.com/sapiens/erit/saepe.md?non&didicisse', '1', '2024-09-26 16:28:13', '2024-09-28 20:38:38'),
(23, 'NovaSkin', '23', 'Crunchy crackers topped with real cheddar cheese flavor.', 'https://hostgator.com/enim/epicurus/videretur.jks?consequantur', '0', '2024-09-26 18:02:18', '2024-10-04 00:50:47'),
(27, 'NutriPlus', '27', 'Smart speaker with Alexa and music streaming features.', 'https://shutterfly.com/ea/scientia/voluptatem.apk?et&splendide', '1', '2024-09-26 18:22:18', '2024-10-04 17:34:51'),
(24, 'OptiVision', '54', 'A nutrient-packed salad mix with kale, quinoa, and a lemon vinaigrette, ready to eat.', 'https://usda.gov/disciplinam/iuvaret/an/ille/studio.ods?cum&sit&inter&doctissimos&summa', '1', '2024-09-26 18:03:27', '2024-09-27 23:28:51'),
(37, 'PeakPerformance', '42', 'A spicy glaze made with sriracha and honey, perfect for meats.', 'https://spotify.com/potest/ipsum.flac?in', '0', '2024-09-26 19:10:35', '2024-10-03 07:30:56'),
(39, 'PowerEdge', '44', 'Soft and warm corn tortillas, perfect for tacos and burritos.', 'https://freewebs.com/enim/certe/nihil/homini/possit/stulti.wmv?est&propterea', '1', '2024-09-26 19:25:34', '2024-09-29 05:22:32'),
(14, 'PowerPulse', '4', 'Leak-proof cooler bag ideal for picnics and camping.', 'https://umich.edu/ipsa/ne/simulent/ipsam.gif?', '1', '2024-09-26 17:02:35', '2024-10-03 05:56:40'),
(30, 'PrimeTaste', '75', 'Delicious cookies with rich chocolate flavor and a hint of mint.', 'https://mediafire.com/est/cur/verear/phaedrum.7z?quibus&ex&omnibus&iudicari&potest', '1', '2024-09-26 18:35:53', '2024-09-28 07:48:16'),
(42, 'PureJoy', '14', 'Green salsa with a spicy kick, great for dipping.', 'https://washingtonpost.com/debemus/pacem.htm?vester&plane', '0', '2024-09-26 19:47:14', '2024-10-03 08:50:37'),
(18, 'PureTaste', '38', 'Classic A-line skirt that flatters every figure, perfect for work or play.', 'https://live.com/corporis/gravioribus/morbis/vitae/semper.php?illa', '1', '2024-09-26 17:29:11', '2024-10-04 03:43:55'),
(4, 'QuickFix', '3', 'Pure maple syrup for pancakes and more.', 'https://chron.com/vitae/iucunditas/de.gpg?si&ita&res&se&habeat', '1', '2024-09-26 16:17:56', '2024-10-05 16:17:07'),
(34, 'RapidCharge', '69', 'A hearty salad with grains, dried fruits, and nuts.', 'https://privacy.gov.au/pueri/mutae/etiam/bestiae/paene/mediocritatem.docx?e&nostris&qui', '1', '2024-09-26 18:58:49', '2024-10-06 13:59:46'),
(47, 'SafeGuard', '30', 'Supportive pillow designed for a good night''s sleep.', 'https://imageshack.us/malum/est/vivere/esse.desktop?aut&ad', '0', '2024-09-26 20:14:50', '2024-10-05 07:22:32'),
(10, 'SmartFuel', '1', 'Hearty lentil soup for a quick meal.', 'https://adobe.com/ipsas/sollicitudines/pendet.doc?ab&ipsis&qui&eam', '1', '2024-09-26 16:47:15', '2024-09-29 09:18:44'),
(46, 'SmartHome', '16', 'Crispy fries tossed in truffle oil and parmesan, a gourmet snack.', 'https://smh.com.au/adipiscing/elit/sed/est.bz2?putat&ut', '0', '2024-09-26 20:07:57', '2024-10-04 16:48:00'),
(13, 'Solara', '64', 'Silicone tray for making ice cubes with a lid to prevent spills.', 'https://independent.co.uk/est/omnis/dolor/vita.md?', '0', '2024-09-26 16:56:52', '2024-10-03 21:55:12'),
(20, 'SonicWave', '37', 'Eco-friendly bamboo holder for toothbrushes.', 'http://163.com/quod/quamquam/gaudere.txt?aliquo&sed&ipsius&honestatis', '1', '2024-09-26 17:42:44', '2024-10-03 03:09:30'),
(3, 'TrueBlend', '11', 'Gluten-free bread mix made with almond flour.', 'https://com.com/adversarium/contenta.mp4?ea', '1', '2024-09-26 16:08:08', '2024-10-02 03:09:54'),
(21, 'UltraClean', '80', 'Educational robotics kit for building and programming.', 'https://ucoz.com/et/cum.pdf?autem&quem&timeam', '1', '2024-09-26 17:46:00', '2024-10-05 15:25:04'),
(45, 'UrbanPulse', '70', 'Pasta alternative made from sweet potatoes, gluten-free and rich in flavor.', 'https://twitpic.com/mente/consedit/hoc/ipso/iudicia.sh?saepe&disserui&latinam&linguam', '0', '2024-09-26 19:58:20', '2024-09-30 10:01:43'),
(40, 'UrbanRoots', '52', 'A tangy and spicy BBQ sauce that''s perfect for grilling.', 'https://bbc.co.uk/nostrum/posidonium/quid/theophrastus/amorem.asp?movere&hominum', '1', '2024-09-26 19:31:09', '2024-09-28 17:27:01'),
(26, 'UrbanWear', '45', 'Make delicious ice cream at home with this user-friendly machine.', 'https://myspace.com/physici/credere/vocent.img?ornateque&dictas&quis&non', '0', '2024-09-26 18:19:12', '2024-09-26 23:41:12'),
(49, 'VitaFresh', '65', 'Indoor putting green for practicing your putting skills.', 'http://so-net.ne.jp/tempus/numquam/est/metus/erroribus.pptx?', '0', '2024-09-26 20:23:02', '2024-10-01 01:53:23'),
(19, 'VitalEase', '8', 'Breathable tank top perfect for workouts or casual wear.', 'https://theguardian.com/voluptatibus/videtisne/quam/nihil/molestiae/non.cer?susciperet&eosdem&suscipiet&propter&amici', '0', '2024-09-26 17:36:04', '2024-09-26 21:58:34'),
(7, 'VividTone', '61', 'A mix of strawberries, blueberries, and raspberries.', 'https://webnode.com/sermo/patrius/cum/et.mp4?etiam&indoctum', '1', '2024-09-26 16:31:14', '2024-09-27 12:46:54'),
(29, 'Zenith', '50', 'Low-carb pizza crust made from almond flour, gluten-free.', 'https://springer.com/iucunditatis/vel/plurimum/integre.htm?arbitratu&sic&faciam&igitur&inquit', '0', '2024-09-26 18:31:57', '2024-10-01 20:25:22');


-- fabricate-flush


SET session_replication_role = 'origin';
