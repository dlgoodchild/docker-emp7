# docker-emp7
Docker setup for Nginx, MySQL and PHP7.  
Compile any version of PHP greater than 5.4.

### What's Installed
1. PHP7.1RC2
 - Xdebug 2.4.1
 - IMagick extension
 - ImageMagick library
 - wkhtmltopdf library
 - Sass compiler
 - Composer
2. Nginx (latest from apt-get on Ubuntu 14.04 / Trusty)
3. MySQL 5.5 (Ubuntu 14.04 / Trusty)

### Usage
1. Clone this repository into a folder named _docker_.  
2. Update the _.env_ file:
 - `project_prefix` : this is a small prefix which will uniquely identify this project (so you can reuse docker-emp7)
 - `project_source` : this is the path to where your website is located, relative to _docker-compose.yml_.
3. Update _nginx/sites/project.site_ according to how you want your site to function.
4. Update _docker-compose.yml_ with a read-only github authentication token (line 20: `github_auth`)
5. If you're installing on MacOSX manually edit the _php7/Dockerfile_. Uncomment the line `RUN usermod -u 1000 www-data`
6. Run `cd docker`; if you named the folder _docker_ as per step 1.
7. Run `docker-compose -p $project_prefix build` using the same _project_prefix_ defined in _.env_
8. Run `docker-compose -p $project_prefix up -d` 

### Directory structure
The configuration of Nginx assumes that your web directory (which you will mount as a volume) contains  
- www
- error

The _error/_ directory can contain .html files such as 404.html, 500.html, where the name is the http error code.  
The _www/_ directory will contain your publicly accessible project files, such as index.php.  

Further, Nginx is configured to pass all requests that do not contain a .php extension to the index.php file.  
The site configuration file is located _/etc/nginx/sites-enabled/project.site_ in the `$project_prefix`-nginx container.

### Project Integration
Optionally delete the .git after clone and commit direct to your project's root directory under the _docker_ folder.

### Notes
The site is accessible at http://localhost  
The MySQL database credentials are: admin / test


