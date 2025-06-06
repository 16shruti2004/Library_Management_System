import mysql.connector
from datetime import datetime

# Connect to MySQL database
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="LibraryDB"
)
cursor = conn.cursor()

# Utility Functions
def add_author():
    name = input("Enter author name: ")
    country = input("Enter author country: ")
    
    cursor.execute("INSERT INTO Authors (Name, Country) VALUES (%s, %s)", (name, country))
    conn.commit()
    print("✅ Author added successfully.")

def add_book():
    title = input("Enter book title: ")
    author_id = input("Enter author ID: ")
    category = input("Enter category: ")
    price = input("Enter price: ")
    
    if not author_id.isdigit() or not price.replace('.', '', 1).isdigit():
        print("❌ Invalid input. Author ID must be a number, and price must be a decimal.")
        return
    
    cursor.execute("INSERT INTO Books (Title, AuthorID, Category, Price) VALUES (%s, %s, %s, %s)",
                   (title, int(author_id), category, float(price)))
    conn.commit()
    print("✅ Book added successfully.")

def add_member():
    name = input("Enter member name: ")
    join_date = input("Enter join date (YYYY-MM-DD): ")
    
    try:
        datetime.strptime(join_date, "%Y-%m-%d")
    except ValueError:
        print("❌ Invalid date format. Use YYYY-MM-DD.")
        return

    cursor.execute("INSERT INTO Members (Name, JoinDate) VALUES (%s, %s)", (name, join_date))
    conn.commit()
    print("✅ Member added successfully.")

def borrow_book():
    member_id = input("Enter member ID: ")
    item_id = input("Enter item ID: ")
    checkout_date = input("Enter checkout date (YYYY-MM-DD): ")
    due_date = input("Enter due date (YYYY-MM-DD): ")
    
    try:
        datetime.strptime(checkout_date, "%Y-%m-%d")
        datetime.strptime(due_date, "%Y-%m-%d")
    except ValueError:
        print("❌ Invalid date format. Use YYYY-MM-DD.")
        return

    if not member_id.isdigit() or not item_id.isdigit():
        print("❌ Invalid ID format. Member ID and Item ID must be numbers.")
        return
    
    cursor.execute("""
        INSERT INTO Borrowing (MemberID, ItemID, CheckoutDate, DueDate)
        VALUES (%s, %s, %s, %s)
    """, (int(member_id), int(item_id), checkout_date, due_date))
    conn.commit()
    print("✅ Book borrowed successfully.")

def show_table(table_name):
    cursor.execute(f"SELECT * FROM {table_name}")
    rows = cursor.fetchall()
    if rows:
        for row in rows:
            print(row)
    else:
        print(f"ℹ️ No records found in {table_name}.")

# Menu
while True:
    print("\n=== 📚 Library Management System ===")
    print("1️⃣ Add Author")
    print("2️⃣ Add Book")
    print("3️⃣ Add Member")
    print("4️⃣ Borrow Book")
    print("5️⃣ Show Authors")
    print("6️⃣ Show Books")
    print("7️⃣ Show Members")
    print("8️⃣ Show Borrowing Records")
    print("9️⃣ Exit")

    choice = input("Enter your choice: ")

    if choice == "1":
        add_author()
    elif choice == "2":
        add_book()
    elif choice == "3":
        add_member()
    elif choice == "4":
        borrow_book()
    elif choice == "5":
        show_table("Authors")
    elif choice == "6":
        show_table("Books")
    elif choice == "7":
        show_table("Members")
    elif choice == "8":
        show_table("Borrowing")
    elif choice == "9":
        print("👋 Exiting... Have a great day!")
        break
    else:
        print("❌ Invalid choice. Try again.")

# Close connection
cursor.close()
conn.close()