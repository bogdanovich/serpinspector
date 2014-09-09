SERPInspector
=============

Rails 4 based search engine position checker web application. 
Utilizes delayed_job to schedule position cheking jobs. 
Uses selenium-webdriver and phantomjs for search engine parsing.

Featues
-------------

- Flexible scheduler of position checking tasks
- Convenient reports view
- Position change graph
- Multi user interface
- User behaviour emulation

Installaton
-------------

**PhantomJS**

Firstly, install phantomjs from http://phantomjs.org/.
Make sure the executable exists in your PATH and you can run it by typing 'phantomjs' in your terminal

PhantomJS Ubuntu installation:
<pre>sudo apt-get install phantomjs</pre>



**SERPInspector app**

<pre>
git clone https://github.com/bogdanovich/serpinspector
cd serpinspector
bundle install
</pre>

**MySQL database setup**

Edit configuration settings in **config/database.yml:**<br/>
Generate your own mysql user password and setup mysql user. 

<pre>
GRANT ALL ON `serpinspector_%`.* TO serpinspector@localhost 
IDENTIFIED BY '[your_generated_password]';
FLUSH PRIVILEGES;
</pre>

**Run tests**

<pre>
rake db:setup RAILS_ENV=test
RAILS_ENV=test bundle exec rspec
</pre>

**Production setup**

<pre>
rake db:setup RAILS_ENV=production
rake assets:precompile
</pre>

**Web Server Configuration**

Nginx + passenger config:
<pre>
server {
     listen       80;
     server_name  [server name] 
     access_log /[path to log]/serpinspector-access;
     error_log /[path to log]/serpinspector-error;
               
     root   /[path to app]/serpinspector/current/public;
     passenger_enabled on;
     rails_env production;
}
</pre>

**Delayed Job background service**

<pre>
chmod +x script/delayed_job

start:  
script/delayed_job start RAILS_ENV=production

stop:
script/delayed_job stop RAILS_ENV=production
</pre>

**Default login credentials:**
<pre>
login: admin
password: admin
</pre>

