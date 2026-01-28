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
7. Run rake task to generate HMAC token, dispute ID, and Timestamp
   Use these to get a fake webhook request that will insert disputes in database
   rails webhook:sign
   
<img width="1467" height="133" alt="Screenshot 2026-01-28 at 9 21 18 AM" src="https://github.com/user-attachments/assets/69dd6761-6376-4de5-a05c-99c492a5c603" />
<img width="692" height="415" alt="Screenshot 2026-01-28 at 9 24 53 AM" src="https://github.com/user-attachments/assets/eb888bae-94e6-4860-9f8c-ffc840bfabcc" />

<img width="651" height="440" alt="Screenshot 2026-01-28 at 9 25 02 AM" src="https://github.com/user-attachments/assets/eaf8025e-7d98-487d-9da7-9f4cbf7c1371" />

Login using seeded admin credentials to manage users.
<img width="1459" height="780" alt="login_page" src="https://github.com/user-attachments/assets/b7ae4f20-5f28-4f8c-bc56-c6579208ec28" />
<img width="1457" height="596" alt="Screenshot 2026-01-28 at 7 34 35 AM" src="https://github.com/user-attachments/assets/3f7426c3-553d-4a51-b287-d179af2e6d5c" />
<img width="1460" height="513" alt="Screenshot 2026-01-28 at 7 35 14 AM" src="https://github.com/user-attachments/assets/01e5f4be-fd1d-4b80-8acb-6132325d5737" />
<img width="1462" height="357" alt="Screenshot 2026-01-28 at 7 36 51 AM" src="https://github.com/user-attachments/assets/33612f9c-71ad-4e4a-9541-d1939ba5161c" />
<img width="1464" height="434" alt="Screenshot 2026-01-28 at 7 37 03 AM" src="https://github.com/user-attachments/assets/6c089d97-4e5a-49f3-91fd-50e12e554846" />
<img width="1462" height="834" alt="Screenshot 2026-01-28 at 7 37 23 AM" src="https://github.com/user-attachments/assets/dfc5e486-e685-42a5-9331-bd0be6371c33" />
<img width="1462" height="720" alt="Screenshot 2026-01-28 at 7 37 35 AM" src="https://github.com/user-attachments/assets/c5302764-90e7-4fdf-91cc-9e9568342d64" />



