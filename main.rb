# main.rb
require_relative 'competition_manager'

puts "=== 1. ТЕСТ ЗАВАНТАЖЕННЯ (ОБРОБКА ПОМИЛОК) ==="
catalog = load_from_json("fake_data.json")

puts "\n=== 2. ДОДАВАННЯ ТЕСТОВИХ ДАНИХ (CRUD: Create) ==="
add_competition(catalog, "Чемпіонат України з футболу", ["Футбол"], ["Динамо", "Шахтар", "Металіст"], "Київ", "2024-03-01", "2024-05-30", 100000.00, "upcoming")
add_competition(catalog, "Марафон Київ 2024", ["Легка атлетика"], ["Збірна України", "Збірна Польщі"], "Київ", "2024-04-21", "2024-04-21", 50000.00, "upcoming")
add_competition(catalog, "Турнір з тенісу", ["Теніс"], ["Світоліна", "Костюк"], "Львів", "2024-06-10", "2024-06-15", 75000.00, "ongoing")

puts "\n--- Тест 'захисту' (невалідний статус) ---"
add_competition(catalog, "Дворова ліга", ["Футбол"], ["Мій двір", "Сусідній двір"], "Одеса", "2024-05-01", "2024-05-02", 500.00, "super_active")

puts "\n=== 3. ВИВІД ВСІХ ЗМАГАНЬ (CRUD: Read) ==="
list_competitions(catalog)

puts "\n=== 4. РЕДАГУВАННЯ ЗАПИСУ (CRUD: Update) ==="
# Змінюємо статус і призовий фонд другого змагання (Марафон)
puts "--- Редагуємо змагання з ID 2 ---"
edit_competition(catalog, 2, { status: "completed", prize_fund: 60000.00 })

puts "--- Тест 'захисту' (редагування неіснуючого ID) ---"
edit_competition(catalog, 999, { status: "cancelled" })

puts "\n=== 5. ВИДАЛЕННЯ ЗАПИСУ (CRUD: Delete) ==="
puts "--- Видаляємо змагання з ID 4 (Дворова ліга) ---"
delete_competition(catalog, 4)

puts "--- Тест 'захисту' (видалення неіснуючого ID) ---"
delete_competition(catalog, 888)

puts "\n=== 6. ВИВІД ПІСЛЯ РЕДАГУВАННЯ ТА ВИДАЛЕННЯ ==="
list_competitions(catalog)

puts "\n=== 7. ПОШУК ТА ФІЛЬТРАЦІЯ ==="
puts "--- Пошук за назвою 'чемпіонат' ---"
find_by_title(catalog, "чемпіонат")

puts "--- Фільтрація за спортом 'футБоЛ' (тест регістру) ---"
filter_by_sport(catalog, "футБоЛ")

puts "--- Фільтрація за статусом 'ongoing' ---"
filter_by_status(catalog, "ongoing")

puts "\n=== 8. РОБОТА З ФАЙЛАМИ (JSON та YAML) ==="
# Зберігаємо нашу ідеальну колекцію у два формати
# save_to_json(catalog, "competitions.json")
# save_to_yaml(catalog, "competitions.yml")

puts "\n--- Тест завантаження збережених файлів ---"
# Створюємо нові змінні-хеші, щоб перевірити, що дані реально тягнуться з файлів
catalog_from_json = load_from_json("competitions.json")
catalog_from_yaml = load_from_yaml("competitions.yml")

puts "\n--- Вивід даних, завантажених з YAML ---"
list_competitions(catalog_from_json)

puts "\n--- Вивід даних, завантажених з YAML ---"
list_competitions(catalog_from_yaml)
