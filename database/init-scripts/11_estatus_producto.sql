SET session_replication_role = 'replica';

TRUNCATE TABLE "estatus_producto" CASCADE;

INSERT INTO "estatus_producto" ("id", "nombre", "descripcion", "activo", "created_at") VALUES
(1, 'En espera de recolección', 'Rich and flavorful chicken broth, great for soups.', '1', '2024-09-26 15:53:43'),
(2, 'En tránsito', 'Tender ribs smothered in a honey barbecue sauce.', '0', '2024-09-26 15:56:49'),
(3, 'En cuarentena', 'Stackable steamers for healthy cooking of vegetables and seafood.', '0', '2024-09-26 16:02:14'),
(4, 'Descontinuado', 'Lightweight and portable picnic table for outdoor use.', '0', '2024-09-26 16:03:35'),
(5, 'En revisión', 'Compact fan for personal cooling at work or home.', '1', '2024-09-26 16:11:25'),
(6, 'Reservado', 'String lights for decorating holiday trees.', '1', '2024-09-26 16:15:11'),
(7, 'Agotado', 'Yoga socks designed to provide better grip and stability.', '1', '2024-09-26 16:18:23'),
(8, 'En exhibición', 'Creamy goat cheese infused with herbs and garlic, perfect for spreading on crackers.', '1', '2024-09-26 16:25:49'),
(9, 'En almacén', 'Water bottle that tracks your hydration levels.', '1', '2024-09-26 16:29:46'),
(10, 'En proceso de entrega', 'Frozen pizza loaded with fresh vegetables and mozzarella cheese.', '1', '2024-09-26 16:37:44'),
(11, 'Disponible', 'Creamy cottage cheese, perfect for healthy snacking.', '1', '2024-09-26 16:42:48'),
(12, 'En oferta', 'Refreshing tea with honey and lemon flavor, perfect for a warm drink.', '0', '2024-09-26 16:44:31'),
(13, 'Bloqueado', 'Wide range of flavored wings, perfect for parties or casual snacking.', '0', '2024-09-26 16:51:52'),
(14, 'En espera de pago', 'Bell peppers filled with quinoa and vegetables.', '0', '2024-09-26 16:57:22'),
(15, 'En producción', 'Eco-friendly cutting board that is safe for dishwashers.', '1', '2024-09-26 17:04:13'),
(16, 'En devolución', 'No-bake energy balls made with oats, chocolate chips, and honey.', '0', '2024-09-26 17:13:02'),
(17, 'En espera de despacho', 'A warm and sustainable wool scarf for chilly days.', '1', '2024-09-26 17:21:59'),
(18, 'Pendiente de reposición', 'Effective brush for removing loose hair from pets.', '0', '2024-09-26 17:31:33'),
(19, 'En espera de aprobación', 'A mix of strawberries, blueberries, and raspberries.', '0', '2024-09-26 17:32:49'),
(20, 'En reparación', 'Control lights remotely with this smart switch.', '0', '2024-09-26 17:37:56');

