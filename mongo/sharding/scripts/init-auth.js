admin = db.getSiblingDB("admin")
admin.createUser(
    {
        user: "admin123",
        pwd: "admin123",
        roles: [{ role: "root", db: "admin" }]
    }
)