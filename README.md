# Questions & Answers 

A class project at online school for rails developers [Thinknetica.com](http://www.thinknetica.com)

**Professional grade web application**

---
### Main features:
* A guest can read all the questions and answers as well as the comments to both
* A guest can also search through the entire application (full-text search)
* A guest can register himself by completing the form or by using his Twitter or Facebook account
* Registered user can ask a question, give an answer or leave a comment to any of both
* User can also attach a file to his question or answer
* There are options for a user for editing or deleting his question or answer
* User can also vote up or down for a question or specific answer
* Author of a question can check an answer as the best suitable answer for him
* When there is a new answer for a question, the author receives an email about this event
* Every user can receive a 24h digest which consists of a list of new questions
* Every user immediately sees a new question in the list of questions when it is created by someone else
* Also if you are at a question page and someone else has left a comment here you will see it immediately
* A third party application can use API for work with questions/answers

---
### Technical details
* **Ruby 2.3.3** and **Rails 5**
* **PostgreSQL 9.3**
* **Sphinx 2.0.4** as a search engine
* **Doorkeeper**: OAuth provider, REST API
* **SendGrid**: transaction email provider
* **ActiveJob/Sidekiq**: Delayed mail delivery
* **Redis**: cache store and queue store for Sidekiq
* **PrivatePub/Faye**: Websockets messaging (new question or new comment)
* Authentication: **Devise 4.2** + **OAuth** (Twitter, Facebook)
* Authorization: **CanCanCan**
* There is **AJAX** functionality for better responsiveness (voting, editing, etc.)
* Made with **BDD/TDD** approach (**RSpec**)

---
### Deploy
* This app is deployed at [http://qna.kudashkin.pro](http://qna.kudashkin.pro)
* Production server is powered by **Nginx** + **Unicorn** on **Ubuntu LTS 14 Server**
* **Whenever**: crontab tasks
* **Dotenv**: ENV variables
* **Capistrano** for deploying

---
#### Future plans
I'm planning to change **PrivatePub** to **ActionCable** in a couple of weeks.  
Also I'm willing to try **Pundit** for Authorization.
