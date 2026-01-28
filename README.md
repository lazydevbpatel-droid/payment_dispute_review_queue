# Payment Dispute Review Queue – User Management Assignment

This Rails application demonstrates **role-based access control** using **Devise** for authentication and **Pundit** for authorization.

The assignment focuses on:

- Admin-only user management (CRUD)
- Public access to Home page
- Secure data visibility using policy scopes
- Clean separation between authentication and authorization

---

## Tech Stack

- Ruby on Rails
- PostgreSQL
- Devise (authentication)
- Pundit (authorization)
- ERB views
- Rails enum for roles

---

## User Roles

The application supports the following roles:

| Role      | Description                                             |
| --------- | ------------------------------------------------------- |
| admin     | Full access. Can create, edit, update, and delete users |
| reviewer  | Can access the Home page but cannot see user data       |
| read_only | Can access the Home page but cannot see user data       |

Roles are implemented using Rails `enum`:

```ruby
enum role: { read_only: 0, admin: 1, reviewer: 2 }
```

1. Clone repository
   git clone https://github.com/lazydevbpatel-droid/payment_dispute_review_queue.git (https)
   cd payment_dispute_review_queue

2. Install dependencies
   bundle install

3. Setup database
   bin/rails db:create db:migrate db:seed

4. Start server
   bin/rails s

5. Database creattion and Seeding
   Seeded Users
   Admin -> admin@example.com -> Password@123
   Reviewer -> reviewer@example.com -> Password@123
   Read-only -> readonly@example.com -> Password@123

Run:
bin/rails db:create db:migrate db:seed

6. Login

Visit:

http://localhost:3000

Login using seeded admin credentials to manage users.
