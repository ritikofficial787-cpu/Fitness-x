// ─────────────────────────────────────────────────────────────────────────────
// meal_model.dart
//
// Simple Meal data model with 12 Indian meals.
// All values are local dummy data – no database, no Firebase, no API.
// Easy to edit: just update the list below.
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a single meal with nutrition info, ingredients and cooking steps.
class MealModel {
  final String name;
  final String imagePath; // asset path or empty string
  final String category; // 'Breakfast', 'Lunch', 'Dinner', 'Snacks', etc.
  final int calories;
  final int protein; // grams
  final int carbs; // grams
  final int fat; // grams
  final int fiber; // grams
  final String preparationTime; // e.g. "25 minutes"
  final String difficulty; // 'Easy', 'Medium', 'Hard'
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> tags; // for filtering by category chips

  const MealModel({
    required this.name,
    required this.imagePath,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.preparationTime,
    required this.difficulty,
    required this.description,
    required this.ingredients,
    required this.steps,
    this.tags = const [],
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// GLOBAL MEAL LIST
//
// 12 popular Indian meals with approximate nutrition values.
// These are demo values for the UI only – not medical/dietary advice.
// ─────────────────────────────────────────────────────────────────────────────

final List<MealModel> allMeals = [
  // ── 1. Idli + Sambar ────────────────────────────────────────────────────
  MealModel(
    name: 'Idli + Sambar',
    imagePath: 'assets/images/onboarding1.png',
    category: 'Breakfast',
    calories: 320,
    protein: 12,
    carbs: 52,
    fat: 6,
    fiber: 7,
    preparationTime: '25 minutes',
    difficulty: 'Easy',
    description:
        'A classic South Indian breakfast. Soft steamed idlis served with hot, '
        'tangy sambar packed with lentils and vegetables. Light, nutritious '
        'and perfect to start your morning.',
    ingredients: [
      'Idli batter - 2 cups',
      'Toor dal - ½ cup',
      'Tomato - 1 large',
      'Onion - 1 medium',
      'Drumstick - 2 pieces',
      'Tamarind pulp - 1 tbsp',
      'Sambar masala - 1 tsp',
      'Oil - 1 tsp',
      'Mustard seeds - ½ tsp',
      'Curry leaves - a few',
      'Salt to taste',
    ],
    steps: [
      'Grease idli moulds with oil and pour the idli batter into each mould.',
      'Steam the idlis in a steamer for 10–12 minutes until a toothpick comes out clean.',
      'Meanwhile, pressure cook toor dal with tomato and a pinch of turmeric for 3 whistles.',
      'In a pan, heat oil and add mustard seeds, curry leaves and onions. Sauté until golden.',
      'Add drumstick, tamarind pulp, sambar masala and cooked dal. Simmer for 8–10 minutes.',
      'Serve hot idlis with sambar and coconut chutney.',
    ],
    tags: ['Breakfast', 'Vegetarian', 'Healthy'],
  ),

  // ── 2. Poha ────────────────────────────────────────────────────────────
  MealModel(
    name: 'Poha',
    imagePath: 'assets/images/onboarding2.png',
    category: 'Breakfast',
    calories: 280,
    protein: 7,
    carbs: 48,
    fat: 8,
    fiber: 4,
    preparationTime: '15 minutes',
    difficulty: 'Easy',
    description:
        'Light and fluffy flattened rice cooked with onions, green chillies and '
        'tempered with mustard seeds. A quick, healthy breakfast popular across India.',
    ingredients: [
      'Poha (flattened rice) - 2 cups',
      'Onion - 1 large',
      'Green chilli - 2',
      'Mustard seeds - ½ tsp',
      'Turmeric powder - ¼ tsp',
      'Curry leaves - a few',
      'Lemon juice - 1 tbsp',
      'Coriander leaves - 2 tbsp',
      'Oil - 2 tsp',
      'Salt to taste',
    ],
    steps: [
      'Rinse poha gently under water and drain. Set aside for 5 minutes to soften.',
      'Heat oil in a pan. Add mustard seeds and let them splutter.',
      'Add curry leaves, green chilli and onion. Sauté until onion turns translucent.',
      'Add turmeric and salt. Mix well.',
      'Add the soaked poha and toss gently to combine.',
      'Cook on low heat for 2 minutes. Squeeze lemon juice and garnish with coriander. Serve hot.',
    ],
    tags: ['Breakfast', 'Vegetarian', 'Healthy'],
  ),

  // ── 3. Vegetable Upma ──────────────────────────────────────────────────
  MealModel(
    name: 'Vegetable Upma',
    imagePath: 'assets/images/onboarding3.png',
    category: 'Breakfast',
    calories: 260,
    protein: 8,
    carbs: 44,
    fat: 7,
    fiber: 5,
    preparationTime: '20 minutes',
    difficulty: 'Easy',
    description:
        'Semolina cooked with mixed vegetables and tempered spices. A wholesome '
        'South Indian breakfast that is filling, nutritious and easy to make.',
    ingredients: [
      'Semolina (rava) - 1 cup',
      'Carrot - ½ cup (diced)',
      'Peas - ¼ cup',
      'Onion - 1 medium',
      'Green chilli - 1',
      'Ginger - ½ tsp (grated)',
      'Mustard seeds - ½ tsp',
      'Chana dal - 1 tsp',
      'Oil - 2 tsp',
      'Water - 2 cups',
      'Salt to taste',
    ],
    steps: [
      'Dry roast semolina in a pan on medium heat until lightly golden. Set aside.',
      'Heat oil in the same pan. Add mustard seeds and chana dal. Let them splutter.',
      'Add onion, green chilli and ginger. Sauté for 2 minutes.',
      'Add carrots and peas. Cook for 3 minutes.',
      'Pour 2 cups of water and bring to a boil. Add salt.',
      'Slowly stir in the roasted semolina while stirring continuously. Cook until thick. Serve hot.',
    ],
    tags: ['Breakfast', 'Vegetarian', 'Healthy'],
  ),

  // ── 4. Masala Oats ─────────────────────────────────────────────────────
  MealModel(
    name: 'Masala Oats',
    imagePath: 'assets/images/onboarding4.png',
    category: 'Breakfast',
    calories: 240,
    protein: 10,
    carbs: 38,
    fat: 5,
    fiber: 6,
    preparationTime: '10 minutes',
    difficulty: 'Easy',
    description:
        'A spicy, savory twist on classic oats. Cooked with vegetables, '
        'Indian spices and a squeeze of lemon. High in fiber and protein, '
        'ideal for a fit morning.',
    ingredients: [
      'Rolled oats - 1 cup',
      'Onion - 1 small (chopped)',
      'Tomato - 1 small (chopped)',
      'Green chilli - 1',
      'Ginger - ¼ tsp',
      'Cumin seeds - ½ tsp',
      'Turmeric - ¼ tsp',
      'Garam masala - ¼ tsp',
      'Oil - 1 tsp',
      'Water - 1½ cups',
      'Salt to taste',
    ],
    steps: [
      'Heat oil in a pan and add cumin seeds. Let them crackle.',
      'Add onion, green chilli and ginger. Sauté for 2 minutes.',
      'Add tomato, turmeric and garam masala. Cook for 2 minutes until soft.',
      'Pour water and bring to a boil.',
      'Add oats and stir well. Cook for 3–4 minutes until water is absorbed.',
      'Season with salt, squeeze lemon juice and serve hot.',
    ],
    tags: ['Breakfast', 'Vegetarian', 'Healthy', 'High Protein'],
  ),

  // ── 5. Paneer Roti ─────────────────────────────────────────────────────
  MealModel(
    name: 'Paneer Roti',
    imagePath: 'assets/images/onboarding1.png',
    category: 'Lunch',
    calories: 480,
    protein: 22,
    carbs: 54,
    fat: 16,
    fiber: 5,
    preparationTime: '30 minutes',
    difficulty: 'Medium',
    description:
        'Whole wheat flatbread stuffed with a spiced paneer and onion filling. '
        'High in protein and calcium – a great post-workout meal.',
    ingredients: [
      'Whole wheat flour - 2 cups',
      'Paneer - 200g (crumbled)',
      'Onion - 1 medium (finely chopped)',
      'Tomato - 1 small',
      'Green chilli - 1',
      'Coriander powder - ½ tsp',
      'Garam masala - ¼ tsp',
      'Oil/ghee - 2 tsp',
      'Salt to taste',
      'Water (for dough)',
    ],
    steps: [
      'Make a soft dough with wheat flour, salt and water. Rest for 10 minutes.',
      'Mix crumbled paneer, onion, tomato, green chilli and spices to make the filling.',
      'Divide dough into balls. Flatten each ball, place the paneer filling in the centre.',
      'Seal the edges and roll gently into a flat roti.',
      'Cook on a hot tawa for 2–3 minutes on each side, applying ghee or oil.',
      'Serve hot with yogurt or pickle.',
    ],
    tags: ['Lunch', 'High Protein', 'Vegetarian'],
  ),

  // ── 6. Dal Rice ────────────────────────────────────────────────────────
  MealModel(
    name: 'Dal Rice',
    imagePath: 'assets/images/onboarding2.png',
    category: 'Lunch',
    calories: 420,
    protein: 15,
    carbs: 70,
    fat: 8,
    fiber: 9,
    preparationTime: '25 minutes',
    difficulty: 'Easy',
    description:
        'The ultimate comfort food of India. Yellow dal tempered with cumin and '
        'garlic, served over fluffy steamed rice. Balanced, nutritious and satisfying.',
    ingredients: [
      'Toor dal - ½ cup',
      'Basmati rice - 1 cup',
      'Onion - 1 medium',
      'Tomato - 1 large',
      'Garlic - 3 cloves',
      'Cumin seeds - ½ tsp',
      'Turmeric - ¼ tsp',
      'Red chilli powder - ½ tsp',
      'Ghee - 1 tsp',
      'Salt to taste',
    ],
    steps: [
      'Wash and cook rice separately until fluffy. Set aside.',
      'Pressure cook toor dal with turmeric and water for 3 whistles until soft.',
      'Heat ghee in a pan. Add cumin seeds and garlic. Sauté until golden.',
      'Add onion and tomato. Cook until soft and masala-like.',
      'Add the cooked dal, red chilli powder and salt. Simmer for 5 minutes.',
      'Serve the dal over steamed rice with a dollop of ghee.',
    ],
    tags: ['Lunch', 'Vegetarian', 'Healthy'],
  ),

  // ── 7. Rajma Rice ──────────────────────────────────────────────────────
  MealModel(
    name: 'Rajma Rice',
    imagePath: 'assets/images/onboarding3.png',
    category: 'Lunch',
    calories: 510,
    protein: 20,
    carbs: 78,
    fat: 10,
    fiber: 12,
    preparationTime: '40 minutes',
    difficulty: 'Medium',
    description:
        'Red kidney beans cooked in a rich, spiced onion-tomato gravy served '
        'with basmati rice. A Punjabi classic that is high in protein and fiber.',
    ingredients: [
      'Rajma (kidney beans) - 1 cup (soaked overnight)',
      'Basmati rice - 1 cup',
      'Onion - 2 medium',
      'Tomato - 2 large',
      'Ginger-garlic paste - 1 tbsp',
      'Rajma masala - 1½ tsp',
      'Cumin seeds - ½ tsp',
      'Oil - 2 tsp',
      'Salt to taste',
    ],
    steps: [
      'Pressure cook soaked rajma until soft (about 4–5 whistles).',
      'Cook rice separately until fluffy.',
      'Heat oil, add cumin seeds, then onions. Sauté until golden brown.',
      'Add ginger-garlic paste and cook for 1 minute.',
      'Add tomatoes and rajma masala. Cook until oil separates.',
      'Add cooked rajma with cooking water. Simmer for 10 minutes. Serve over rice.',
    ],
    tags: ['Lunch', 'High Protein', 'Vegetarian'],
  ),

  // ── 8. Chole Roti ──────────────────────────────────────────────────────
  MealModel(
    name: 'Chole Roti',
    imagePath: 'assets/images/onboarding4.png',
    category: 'Dinner',
    calories: 460,
    protein: 18,
    carbs: 65,
    fat: 12,
    fiber: 11,
    preparationTime: '35 minutes',
    difficulty: 'Medium',
    description:
        'Spicy chickpea curry paired with whole wheat roti. A protein-rich North '
        'Indian staple that is incredibly filling and nutritious.',
    ingredients: [
      'Chickpeas - 1 cup (soaked and cooked)',
      'Onion - 2 large',
      'Tomato - 2 large',
      'Chole masala - 1½ tsp',
      'Ginger-garlic paste - 1 tbsp',
      'Whole wheat flour - 2 cups (for roti)',
      'Oil - 2 tsp',
      'Salt to taste',
    ],
    steps: [
      'Make a soft roti dough with wheat flour and water. Rest for 10 minutes.',
      'Heat oil in a pan. Sauté onions until golden. Add ginger-garlic paste.',
      'Add tomatoes and cook until masala is thick. Add chole masala and salt.',
      'Add cooked chickpeas and simmer for 10 minutes, mashing a few for texture.',
      'Roll the dough into rotis and cook on a hot tawa until golden spots appear.',
      'Serve hot chole with fresh rotis and sliced onion.',
    ],
    tags: ['Dinner', 'High Protein', 'Vegetarian'],
  ),

  // ── 9. Paneer Bhurji ───────────────────────────────────────────────────
  MealModel(
    name: 'Paneer Bhurji',
    imagePath: 'assets/images/onboarding1.png',
    category: 'Dinner',
    calories: 380,
    protein: 24,
    carbs: 18,
    fat: 22,
    fiber: 3,
    preparationTime: '20 minutes',
    difficulty: 'Easy',
    description:
        'Scrambled paneer cooked with onions, tomatoes and aromatic Indian spices. '
        'A quick, high-protein dish that can be eaten with roti, paratha or bread.',
    ingredients: [
      'Paneer - 250g (crumbled)',
      'Onion - 1 large',
      'Tomato - 1 large',
      'Capsicum - ½',
      'Green chilli - 1',
      'Cumin seeds - ½ tsp',
      'Turmeric - ¼ tsp',
      'Coriander powder - 1 tsp',
      'Oil - 2 tsp',
      'Salt to taste',
    ],
    steps: [
      'Heat oil in a pan and add cumin seeds. Let them crackle.',
      'Add onion and green chilli. Sauté until translucent.',
      'Add tomato and capsicum. Cook for 3 minutes until soft.',
      'Add turmeric, coriander powder and salt. Mix well.',
      'Add crumbled paneer and stir gently to combine with the masala.',
      'Cook for 2–3 minutes. Garnish with coriander and serve hot.',
    ],
    tags: ['Dinner', 'High Protein', 'Vegetarian'],
  ),

  // ── 10. Moong Dal Khichdi ──────────────────────────────────────────────
  MealModel(
    name: 'Moong Dal Khichdi',
    imagePath: 'assets/images/onboarding2.png',
    category: 'Dinner',
    calories: 360,
    protein: 16,
    carbs: 58,
    fat: 7,
    fiber: 8,
    preparationTime: '25 minutes',
    difficulty: 'Easy',
    description:
        'A gentle one-pot meal of rice and moong dal. Light on the stomach, '
        'easy to digest and packed with protein. Often called the "Indian comfort food".',
    ingredients: [
      'Rice - ½ cup',
      'Moong dal (split) - ½ cup',
      'Ghee - 1 tsp',
      'Cumin seeds - ½ tsp',
      'Asafoetida - a pinch',
      'Turmeric - ¼ tsp',
      'Ginger - ½ tsp',
      'Water - 3 cups',
      'Salt to taste',
    ],
    steps: [
      'Wash rice and moong dal together. Drain and set aside.',
      'Heat ghee in a pressure cooker. Add cumin seeds and asafoetida.',
      'Add ginger and sauté for 30 seconds.',
      'Add the washed rice and dal mixture. Stir to coat with ghee.',
      'Add water, turmeric and salt. Pressure cook for 3 whistles.',
      'Let pressure release naturally. Serve warm with a drizzle of ghee.',
    ],
    tags: ['Dinner', 'Vegetarian', 'Healthy'],
  ),

  // ── 11. Sprouts Chaat ──────────────────────────────────────────────────
  MealModel(
    name: 'Sprouts Chaat',
    imagePath: 'assets/images/onboarding3.png',
    category: 'Snacks',
    calories: 180,
    protein: 10,
    carbs: 28,
    fat: 3,
    fiber: 7,
    preparationTime: '10 minutes',
    difficulty: 'Easy',
    description:
        'Mixed sprouts tossed with fresh vegetables, spices and lemon juice. '
        'A super-healthy, no-cook snack loaded with plant protein, fiber and vitamins.',
    ingredients: [
      'Mixed sprouts - 1 cup',
      'Onion - 1 small (chopped)',
      'Tomato - 1 small (chopped)',
      'Cucumber - ½ (chopped)',
      'Green chilli - ½',
      'Lemon juice - 1 tbsp',
      'Chaat masala - ½ tsp',
      'Coriander leaves - 2 tbsp',
      'Salt to taste',
    ],
    steps: [
      'Steam or boil the sprouts lightly for 3–4 minutes. Let them cool.',
      'Add chopped onion, tomato and cucumber to the sprouts.',
      'Mix in green chilli, chaat masala and salt.',
      'Squeeze lemon juice and toss everything together.',
      'Garnish with fresh coriander leaves.',
      'Serve immediately for best taste and nutrition.',
    ],
    tags: ['Snacks', 'High Protein', 'Healthy', 'Vegetarian'],
  ),

  // ── 12. Curd + Fruit Bowl ──────────────────────────────────────────────
  MealModel(
    name: 'Curd + Fruit Bowl',
    imagePath: 'assets/images/onboarding4.png',
    category: 'Snacks',
    calories: 200,
    protein: 9,
    carbs: 32,
    fat: 4,
    fiber: 4,
    preparationTime: '5 minutes',
    difficulty: 'Easy',
    description:
        'Fresh curd topped with seasonal fruits like banana, apple and pomegranate. '
        'Rich in probiotics, calcium and vitamins. A perfect light snack or dessert.',
    ingredients: [
      'Fresh curd (yogurt) - 1 cup',
      'Banana - 1 (sliced)',
      'Apple - ½ (diced)',
      'Pomegranate seeds - 2 tbsp',
      'Honey - 1 tsp',
      'Roasted cumin powder - a pinch',
    ],
    steps: [
      'Pour fresh curd into a bowl.',
      'Add sliced banana and diced apple.',
      'Sprinkle pomegranate seeds on top.',
      'Drizzle honey over the fruits.',
      'Add a tiny pinch of roasted cumin powder for flavour.',
      'Mix gently or leave layered. Serve chilled.',
    ],
    tags: ['Snacks', 'Healthy', 'Vegetarian'],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORY LIST
// Used to render the horizontal category chips on the Meal Planner screen.
// ─────────────────────────────────────────────────────────────────────────────

class MealCategory {
  final String name;
  final String emoji;

  const MealCategory({required this.name, required this.emoji});
}

const List<MealCategory> mealCategories = [
  MealCategory(name: 'All', emoji: '🍽️'),
  MealCategory(name: 'Breakfast', emoji: '🍳'),
  MealCategory(name: 'Lunch', emoji: '🍛'),
  MealCategory(name: 'Dinner', emoji: '🥘'),
  MealCategory(name: 'Snacks', emoji: '🍎'),
  MealCategory(name: 'High Protein', emoji: '💪'),
  MealCategory(name: 'Vegetarian', emoji: '🥬'),
  MealCategory(name: 'Healthy', emoji: '🥗'),
];
