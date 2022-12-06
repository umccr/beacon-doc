db.createUser(
  {
    user: "beacon",
    pwd: "beacon",
    roles: [
      {
        role: "readWrite",
        db: "beacon"
      }
    ]
  }
)
