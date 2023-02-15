db.createUser(
  {
    user: "beacon",
    pwd: "beacon",
    roles: [
      {
        role: "readWrite",
        db: "beacon"
      },
      {
        role: "readWrite",
        db: "beacon2"
      },
      {
        role: "readWrite",
        db: "beacon3"
      }
    ]
  }
)
